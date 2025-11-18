import 'package:characterbook/ui/pages/characters/character_management_page.dart';
import 'package:characterbook/ui/widgets/list/list_state_indicator.dart';
import 'package:characterbook/ui/widgets/list/optimized_list_view.dart';
import 'package:characterbook/ui/widgets/performance/optimized_value_listenable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hive/hive.dart';
import 'package:characterbook/models/template_model.dart';
import 'package:characterbook/services/template_service.dart';
import 'package:characterbook/ui/widgets/context_menu.dart';
import 'package:characterbook/ui/widgets/custom_app_bar.dart';
import 'package:characterbook/ui/widgets/custom_floating_buttons.dart';
import 'package:characterbook/ui/pages/templates/template_edit_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../generated/l10n.dart';

class TemplatesPage extends StatefulWidget {
  const TemplatesPage({super.key});

  @override
  State<TemplatesPage> createState() => _TemplatesPageState();
}

class _TemplatesPageState extends State<TemplatesPage> {
  final TemplateService _templateService = TemplateService();
  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  
  bool isSearching = false;
  bool isImporting = false;
  bool isFabVisible = true;
  String? errorMessage;
  String _searchQuery = '';
  QuestionnaireTemplate? _selectedTemplate;

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {
        _searchQuery = searchController.text.toLowerCase();
      });
    });
    scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    searchController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void _refreshTemplates() {
    setState(() {});
  }

  Future<void> _deleteTemplate(String name) async {
    final confirmed = await _showDeleteConfirmationDialog(
      S.of(context).template_delete_title,
      S.of(context).template_delete_confirm,
    );

    if (confirmed) {
      await _templateService.deleteTemplate(name);
      if (mounted) _showSnackBar(S.of(context).template_deleted);
      _refreshTemplates();
    }
  }

  Future<void> _importTemplate() async {
    try {
      setState(() {
        isImporting = true;
        errorMessage = null;
      });

      final template = await _templateService.pickAndImportTemplate();

      if (template != null) {
        final box = Hive.box<QuestionnaireTemplate>('templates');
        if (box.containsKey(template.name)) {
          final shouldReplace = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(S.of(context).template_exists),
              content: Text(S.of(context).template_replace_confirm(template.name)),
              actions: [
                TextButton(
                  child: Text(S.of(context).cancel),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                TextButton(
                  child: Text(S.of(context).replace),
                  onPressed: () => Navigator.of(context).pop(true),
                ),
              ],
            ),
          );

          if (shouldReplace != true) {
            if (mounted) _showSnackBar(S.of(context).import_cancelled);
            return;
          }
        }

        await box.put(template.name, template);
        if (mounted) _showSnackBar(S.of(context).template_imported(template.name));
        _refreshTemplates();
      } else {
        if (mounted) _showSnackBar(S.of(context).import_cancelled);
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
      if (mounted) _showSnackBar(S.of(context).import_error(e.toString()));
    } finally {
      setState(() {
        isImporting = false;
      });
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Future<bool> _showDeleteConfirmationDialog(String title, String content) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(S.of(context).cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              S.of(context).delete,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    ) ?? false;
  }

  void _showTemplateContextMenu(QuestionnaireTemplate template, BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => ContextMenu(
        item: template,
        onEdit: () => _editTemplate(template),
        onDelete: () => _deleteTemplate(template.name),
        showExportPdf: false,
        showCopy: false,
      ),
    );
  }

  Future<void> _editTemplate(QuestionnaireTemplate template) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => TemplateEditPage(template: template),
      ),
    );
    if (result == true && mounted) {
      _refreshTemplates();
    }
  }

  Future<void> _createCharacterFromTemplate(QuestionnaireTemplate template) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CharacterEditPage(template: template),
      ),
    );

    if (result == true && mounted) {
      _showSnackBar(S.of(context).character_created_from_template(template.name));
    }
  }

  List<QuestionnaireTemplate> _filterTemplates(List<QuestionnaireTemplate> templates) {
    if (_searchQuery.isEmpty) return templates;
    return templates.where((template) =>
    template.name.toLowerCase().contains(_searchQuery) ||
        template.standardFields.any((field) => field.toLowerCase().contains(_searchQuery)) ||
        template.customFields.any((field) =>
        field.key.toLowerCase().contains(_searchQuery) ||
            field.value.toLowerCase().contains(_searchQuery))
    ).toList();
  }

  Widget _buildTemplateCard(BuildContext context, QuestionnaireTemplate template, int index) {
    final theme = Theme.of(context);
    final isWideScreen = MediaQuery.of(context).size.width > 1000;
    final isSelected = _selectedTemplate?.name == template.name;

    return Card(
      key: ValueKey(template.name),
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      elevation: 0,
      color: isSelected
          ? theme.colorScheme.secondaryContainer
          : theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected
              ? theme.colorScheme.secondary
              : theme.colorScheme.outlineVariant,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          if (isWideScreen) {
            setState(() => _selectedTemplate = template);
          } else {
            _createCharacterFromTemplate(template);
          }
        },
        onLongPress: () => _showTemplateContextMenu(template, context),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                child: Icon(
                  Icons.library_books,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(template.name, style: theme.textTheme.bodyLarge),
                    Text(
                      S.of(context).fields_count(template.standardFields.length + template.customFields.length),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.more_vert, color: theme.colorScheme.onSurfaceVariant),
                onPressed: () => _showTemplateContextMenu(template, context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTemplatesList(List<QuestionnaireTemplate> templates, ThemeData theme) {
    if (templates.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.library_books_outlined,
              size: 48,
              color: theme.colorScheme.onSurface,
            ),
            const SizedBox(height: 16),
            Text(
              isSearching && searchController.text.isNotEmpty
                  ? S.of(context).templates_not_found
                  : S.of(context).no_templates,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
            if (!isSearching)
              TextButton(
                onPressed: _importTemplate,
                child: Text(S.of(context).import_template),
              ),
          ],
        ),
      );
    }

    return OptimizedListView<QuestionnaireTemplate>(
      items: templates,
      itemBuilder: _buildTemplateCard,
      onReorder: (oldIndex, newIndex) => Future.value(),
      scrollController: scrollController,
      enableReorder: false,
    );
  }

  Widget _buildTemplateDetails(QuestionnaireTemplate template, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            template.name,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            S.of(context).standard_fields,
            style: theme.textTheme.titleMedium,
          ),
          ...template.standardFields.map((field) => ListTile(
            title: Text(field),
            leading: const Icon(Icons.check_box_outlined),
          )),
          if (template.customFields.isNotEmpty) ...[
            Text(
              S.of(context).custom_fields,
              style: theme.textTheme.titleMedium,
            ),
            ...template.customFields.map((field) => ListTile(
              title: Text(field.key),
              subtitle: field.value.isNotEmpty ? Text(field.value) : null,
              leading: const Icon(Icons.add_box_outlined),
            )),
          ],
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(S.of(context).back),
              ),
              const SizedBox(width: 16),
              FilledButton(
                onPressed: () => _createCharacterFromTemplate(template),
                child: Text(S.of(context).create_character),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _onScroll() {
    final isScrollingDown = scrollController.position.userScrollDirection == 
        ScrollDirection.reverse;
    if (isScrollingDown && isFabVisible) {
      setState(() => isFabVisible = false);
    } else if (!isScrollingDown && !isFabVisible) {
      setState(() => isFabVisible = true);
    }
  }

  void _handleSearchToggle() {
    setState(() {
      isSearching = !isSearching;
      if (!isSearching) {
        searchController.clear();
        _searchQuery = '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isWideScreen = MediaQuery.of(context).size.width > 1000;

    return Scaffold(
      appBar: CustomAppBar(
        title: S.of(context).templates,
        isSearching: isSearching,
        searchController: searchController,
        searchHint: S.of(context).search,
        onSearchToggle: _handleSearchToggle,
      ),
      body: Column(
        children: [
          ListStateIndicator(
            isLoading: isImporting,
            errorMessage: errorMessage,
            onErrorClose: () => setState(() => errorMessage = null),
          ),
          Expanded(
            child: OptimizedValueListenable<QuestionnaireTemplate>(
              box: Hive.box<QuestionnaireTemplate>('templates'),
              listen: true,
              builder: (context, allTemplates) {
                final templates = _filterTemplates(allTemplates);

                return isWideScreen
                    ? _buildWideLayout(templates, theme)
                    : _buildMobileLayout(templates, theme);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: isFabVisible 
          ? CustomFloatingButtons(
              onImport: _importTemplate,
              onAdd: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TemplateEditPage(onSaved: _refreshTemplates),
                ),
              ),
              importTooltip: S.of(context).import_template_tooltip,
              addTooltip: S.of(context).create_template_tooltip,
              templateTooltip: S.of(context).create_from_template_tooltip,
            )
          : null,
    );
  }

  Widget _buildWideLayout(List<QuestionnaireTemplate> templates, ThemeData theme) {
    return Row(
      children: [
        Container(
          width: 400,
          decoration: BoxDecoration(
            border: Border(right: BorderSide(color: theme.dividerColor)),
          ),
          child: _buildTemplatesList(templates, theme),
        ),
        Expanded(
          child: _selectedTemplate != null
              ? _buildTemplateDetails(_selectedTemplate!, theme)
              : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.library_books_outlined,
                  size: 48,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: 16),
                Text(
                  S.of(context).select_template,
                  style: theme.textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(List<QuestionnaireTemplate> templates, ThemeData theme) {
    return _buildTemplatesList(templates, theme);
  }
}
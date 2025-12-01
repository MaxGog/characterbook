import 'package:characterbook/generated/l10n.dart';
import 'package:characterbook/models/template_model.dart';
import 'package:characterbook/services/template_service.dart';
import 'package:characterbook/ui/widgets/list/base_list_page.dart';
import 'package:characterbook/ui/widgets/list/optimized_list_view.dart';
import 'package:characterbook/ui/widgets/list/list_state_indicator.dart';
import 'package:characterbook/ui/widgets/cards/template_card.dart';
import 'package:characterbook/ui/widgets/tools_context_menu.dart';
import 'package:characterbook/ui/widgets/appbar/common_main_app_bar.dart';
import 'package:characterbook/ui/widgets/buttons/common_list_floating_buttons.dart';
import 'package:characterbook/ui/pages/template_edit_page.dart';
import 'package:characterbook/ui/pages/character_management_page.dart';
import 'package:characterbook/ui/widgets/tags/tag_filter.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TemplatesPage extends BaseListPage<QuestionnaireTemplate> {
  const TemplatesPage({super.key})
      : super(
          boxName: 'templates',
          titleKey: 'templates',
        );

  @override
  State<TemplatesPage> createState() => _TemplatesPageState();
}

class _TemplatesPageState extends BaseListPageState<QuestionnaireTemplate, TemplatesPage> {
  final TemplateService _templateService = TemplateService();

  @override
  void initState() {
    super.initState();
    _initializeDefaultTemplates();
  }

  Future<void> _initializeDefaultTemplates() async {
    final box = Hive.box<QuestionnaireTemplate>(widget.boxName);
    if (box.isEmpty) {
      await _templateService.initializeDefaultTemplates();
      if (mounted) {
        final allTemplates = box.values.cast<QuestionnaireTemplate>();
        filterItems(searchController.text, allTemplates.toList());
      }
    }
  }

  void showTemplateContextMenu(QuestionnaireTemplate template) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => ContextMenu(
        item: template,
        onEdit: () => navigateToEdit(template),
        onDelete: () => deleteItem(template),
        showExportPdf: false,
        showCopy: false,
      ),
    );
  }

  void navigateToDetail(QuestionnaireTemplate template) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildTemplateDetailsModal(template),
    );
  }

  Widget _buildTemplateDetailsModal(QuestionnaireTemplate template) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final s = S.of(context);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.outline.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.library_books_rounded, 
                  color: colorScheme.primary, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      template.name,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      s.fields_count(template.standardFields.length + template.customFields.length),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          _buildFieldsSection(
            context,
            title: s.standard_fields,
            fields: template.standardFields,
            icon: Icons.check_circle_rounded,
            color: colorScheme.primary,
          ),
          
          const SizedBox(height: 20),
          
          if (template.customFields.isNotEmpty)
            _buildFieldsSection(
              context,
              title: s.custom_fields,
              fields: template.customFields.map((f) => f.key).toList(),
              icon: Icons.add_circle_rounded,
              color: colorScheme.tertiary,
            ),
          
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(s.cancel),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _createCharacterFromTemplate(template);
                  },
                  child: Text(s.create),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFieldsSection(
    BuildContext context, {
    required String title,
    required List<String> fields,
    required IconData icon,
    required Color color,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                fields.length.toString(),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: fields.map((field) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                field,
                style: theme.textTheme.bodyMedium,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Future<void> _createCharacterFromTemplate(QuestionnaireTemplate template) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CharacterEditPage(template: template),
      ),
    );

    if (result == true && mounted) {
      showSnackBar(S.of(context).character_created_from_template(template.name));
    }
  }

  @override
  List<String> getTags(List<QuestionnaireTemplate> templates) {
    final s = S.of(context);
    return [
      s.a_to_z,
      s.z_to_a,
      s.fields_asc,
      s.fields_desc,
    ];
  }

  @override
  bool matchesSearch(QuestionnaireTemplate template, String query) {
    final queryLower = query.toLowerCase();
    return template.name.toLowerCase().contains(queryLower) ||
        template.standardFields.any((field) => field.toLowerCase().contains(queryLower)) ||
        template.customFields.any((field) =>
            field.key.toLowerCase().contains(queryLower) ||
            field.value.toLowerCase().contains(queryLower));
  }

  @override
  bool matchesTagFilter(QuestionnaireTemplate template, String? tag) {
    if (tag == null) return true;
    
    final s = S.of(context);
    if (tag == s.a_to_z || tag == s.z_to_a || 
        tag == s.fields_asc || tag == s.fields_desc) {
      return true;
    }
    
    return false;
  }

  @override
  Widget buildItemCard(QuestionnaireTemplate template, int index) {
    return TemplateCard(
      key: ValueKey('${template.name}-$index'),
      template: template,
      isSelected: false,
      onTap: () => navigateToDetail(template),
      onLongPress: () => showTemplateContextMenu(template),
      onMenuPressed: () => showTemplateContextMenu(template),
    );
  }

  @override
  Future<void> importItem() async {
    try {
      setState(() {
        isImporting = true;
        errorMessage = null;
      });

      final template = await _templateService.pickAndImportTemplate();

      if (template != null) {
        final box = Hive.box<QuestionnaireTemplate>(widget.boxName);
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
            if (mounted) showSnackBar(S.of(context).import_cancelled);
            return;
          }
        }

        await box.put(template.name, template);
        if (mounted) showSnackBar(S.of(context).template_imported(template.name));
      } else {
        if (mounted) showSnackBar(S.of(context).import_cancelled);
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
      if (mounted) showSnackBar(S.of(context).import_error(e.toString()));
    } finally {
      setState(() {
        isImporting = false;
      });
    }
  }

  @override
  Future<void> deleteItem(QuestionnaireTemplate template) async {
    final confirmed = await showDeleteConfirmation(
      S.of(context).template_delete_title,
      S.of(context).template_delete_confirm,
    );

    if (confirmed) {
      await _templateService.deleteTemplate(template.name);
      if (mounted) showSnackBar(S.of(context).template_deleted);
    }
  }

  @override
  Future<void> reorderItems(int oldIndex, int newIndex) async {
    return;
  }

  @override
  void navigateToEdit(QuestionnaireTemplate template) {
    Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => TemplateEditPage(template: template),
      ),
    ).then((result) {
      if (result == true && mounted) {
        final templates = Hive.box<QuestionnaireTemplate>(widget.boxName).values.cast<QuestionnaireTemplate>();
        filterItems(searchController.text, templates.toList());
      }
    });
  }

  @override
  void navigateToCreate() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TemplateEditPage(onSaved: () {
          final templates = Hive.box<QuestionnaireTemplate>(widget.boxName).values.cast<QuestionnaireTemplate>();
          filterItems(searchController.text, templates.toList());
        }),
      ),
    );
  }

  void filterItems(String query, List<QuestionnaireTemplate> allTemplates) {
    final queryLower = query.toLowerCase();
    
    setState(() {
      filteredItems = allTemplates.where((template) {
        final matchesSearch = query.isEmpty ||
            template.name.toLowerCase().contains(queryLower) ||
            template.standardFields.any((field) => field.toLowerCase().contains(queryLower)) ||
            template.customFields.any((field) =>
                field.key.toLowerCase().contains(queryLower) ||
                field.value.toLowerCase().contains(queryLower));

        return matchesSearch && matchesTagFilter(template, selectedTag);
      }).toList();

      final s = S.of(context);
      if (selectedTag == s.a_to_z) {
        filteredItems.sort((a, b) => a.name.compareTo(b.name));
      } else if (selectedTag == s.z_to_a) {
        filteredItems.sort((a, b) => b.name.compareTo(a.name));
      } else if (selectedTag == s.fields_asc) {
        filteredItems.sort((a, b) => (a.standardFields.length + a.customFields.length)
            .compareTo(b.standardFields.length + b.customFields.length));
      } else if (selectedTag == s.fields_desc) {
        filteredItems.sort((a, b) => (b.standardFields.length + b.customFields.length)
            .compareTo(a.standardFields.length + a.customFields.length));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonMainAppBar(
        title: S.of(context).templates,
        isSearching: isSearching,
        searchController: searchController,
        searchHint: S.of(context).search,
        onSearchToggle: () => setState(() {
          isSearching = !isSearching;
          if (!isSearching) {
            searchController.clear();
            selectedTag = null;
            filteredItems = [];
          }
        }),
        onSearchChanged: (query) {
          final allTemplates = Hive.box<QuestionnaireTemplate>(widget.boxName).values.cast<QuestionnaireTemplate>();
          filterItems(query, allTemplates.toList());
        },
      ),
      body: Column(
        children: [
          ListStateIndicator(
            isLoading: isImporting,
            errorMessage: errorMessage,
            onErrorClose: () => setState(() => errorMessage = null),
          ),
          Expanded(
            child: ValueListenableBuilder<Box<QuestionnaireTemplate>>(
              valueListenable: Hive.box<QuestionnaireTemplate>(widget.boxName).listenable(),
              builder: (context, box, _) {
                final allTemplates = box.values.toList().cast<QuestionnaireTemplate>();
                final tags = getTags(allTemplates);
                final templatesToShow = isSearching || selectedTag != null
                    ? filteredItems
                    : allTemplates;

                return Column(
                  children: [
                    if (tags.isNotEmpty)
                      TagFilter(
                        tags: tags,
                        selectedTag: selectedTag,
                        onTagSelected: (tag) {
                          setState(() => selectedTag = tag);
                          filterItems(searchController.text, allTemplates);
                        },
                        context: context,
                      ),
                    Expanded(
                      child: OptimizedListView<QuestionnaireTemplate>(
                        items: templatesToShow,
                        itemBuilder: (context, template, index) => 
                            buildItemCard(template, index),
                        onReorder: reorderItems,
                        scrollController: scrollController,
                        enableReorder: false,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: isFabVisible 
          ? CommonListFloatingButtons(
              onImport: importItem,
              onAdd: navigateToCreate,
              importTooltip: S.of(context).import_template_tooltip,
              addTooltip: S.of(context).create_template_tooltip,
              heroTag: "templates_list",
            )
          : null,
    );
  }
}
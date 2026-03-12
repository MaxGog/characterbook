import 'dart:async';
import 'package:characterbook/generated/l10n.dart';
import 'package:characterbook/models/character_model.dart';
import 'package:characterbook/models/race_model.dart';
import 'package:characterbook/services/date_formatter.dart';
import 'package:characterbook/ui/cards/character_modal_card.dart';
import 'package:characterbook/ui/cards/race_modal_card.dart';
import 'package:characterbook/ui/controllers/home_controller.dart';
import 'package:characterbook/ui/pages/calendar_page.dart';
import 'package:characterbook/ui/pages/character_management_page.dart';
import 'package:characterbook/ui/pages/export_pdf_settings_page.dart';
import 'package:characterbook/ui/pages/race_management_page.dart';
import 'package:characterbook/ui/pages/random_number_page.dart';
import 'package:characterbook/ui/pages/templates_page.dart';
import 'package:characterbook/ui/widgets/appbar/common_main_app_bar.dart';
import 'package:characterbook/ui/widgets/buttons/common_list_floating_buttons.dart';
import 'package:characterbook/ui/widgets/cards/character_keep_card.dart';
import 'package:characterbook/ui/widgets/cards/race_keep_card.dart';
import 'package:characterbook/ui/widgets/cards/tool_keep_card.dart';
import 'package:characterbook/ui/widgets/home_item.dart';
import 'package:characterbook/ui/widgets/tools_context_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomeController _controller;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  HomeContentType _selectedContentType = HomeContentType.charactersAndRaces;

  @override
  void initState() {
    super.initState();
    _controller = HomeController();
    _loadData();

    _searchController.addListener(() {
      _controller.setSearchQuery(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      await _controller.loadData();
      if (mounted) setState(() {});
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${S.of(context).error}: $e'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _changeContentType(HomeContentType type) {
    setState(() {
      _selectedContentType = type;
      if (_isSearching) {
        _isSearching = false;
        _searchController.clear();
      }
    });
  }

  void _onSearchToggle() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
      }
    });
  }

  Future<void> _createNewContent() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CharacterManagementPage()),
    );
    if (result == true && mounted) {
      await _loadData();
    }
  }

  void _importContent() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(S.of(context).import_cancelled)),
    );
  }

  void _createFromTemplate() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${S.of(context).templates_not_found} - ${S.of(context).import_cancelled}',
        ),
      ),
    );
  }

  void _navigateToTool(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return ChangeNotifierProvider.value(
      value: _controller,
      child: Scaffold(
        appBar: CommonMainAppBar(
          title: s.app_name,
          isSearching: _isSearching,
          searchController: _searchController,
          onSearchToggle: _onSearchToggle,
          searchHint: s.search,
          onSearchChanged: (value) => _controller.setSearchQuery(value),
          showViewModeToggle: false,
          showTemplatesToggle: false,
        ),
        floatingActionButton:
            _selectedContentType == HomeContentType.charactersAndRaces
                ? CommonListFloatingButtons(
                    onAdd: _createNewContent,
                    onImport: _importContent,
                    onTemplate: _createFromTemplate,
                    showImportButton: true,
                    addTooltip: s.new_character,
                    importTooltip: s.import,
                    templateTooltip: s.create_from_template_tooltip,
                    createFromScratchTooltip: s.new_character,
                    heroTag: "home_list",
                  )
                : null,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SegmentedButton<HomeContentType>(
                  segments: [
                    ButtonSegment(
                      value: HomeContentType.charactersAndRaces,
                      label: Text(s.characters_and_races),
                    ),
                    ButtonSegment(
                      value: HomeContentType.tools,
                      label: Text(s.tool_management),
                    ),
                  ],
                  selected: {_selectedContentType},
                  onSelectionChanged: (Set<HomeContentType> newSelection) {
                    _changeContentType(newSelection.first);
                  },
                ),
              ),
              const SizedBox(height: 4),
              Expanded(
                child: _selectedContentType == HomeContentType.tools
                    ? _ToolsGrid(onNavigate: _navigateToTool)
                    : Consumer<HomeController>(
                        builder: (context, controller, _) {
                          if (!controller.hasItems) {
                            return _EmptyState(
                              isSearching: _searchController.text.isNotEmpty,
                              onCreateNew: _createNewContent,
                            );
                          }
                          return _ContentGrid(
                            controller: controller,
                            onCharacterTap: _showCharacterDetail,
                            onCharacterContextMenu: _showCharacterContextMenu,
                            onRaceTap: _showRaceDetail,
                            onRaceContextMenu: _showRaceContextMenu,
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCharacterDetail(CharacterHomeItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CharacterModalCard(character: item.character),
    );
  }

  void _showCharacterContextMenu(CharacterHomeItem item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => ContextMenu.character(
        character: item.character,
        onEdit: () {
          Navigator.pop(context);
          _editCharacter(item.character);
        },
        onDelete: () => _showDeleteDialog(item),
      ),
    );
  }

  void _showRaceDetail(RaceHomeItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => RaceModalCard(race: item.race),
    );
  }

  void _showRaceContextMenu(RaceHomeItem item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => ContextMenu.race(
        race: item.race,
        onEdit: () {
          Navigator.pop(context);
          _editRace(item.race);
        },
        onDelete: () => _showDeleteDialog(item),
      ),
    );
  }

  Future<void> _editCharacter(Character character) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CharacterManagementPage(character: character),
      ),
    );
    if (result == true && mounted) await _loadData();
  }

  Future<void> _editRace(Race race) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RaceManagementPage(race: race),
      ),
    );
    if (result == true && mounted) await _loadData();
  }

  Future<void> _showDeleteDialog(HomeItem item) async {
    final s = S.of(context);
    final isCharacter = item is CharacterHomeItem;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title:
            Text(isCharacter ? s.character_delete_title : s.race_delete_title),
        content: Text(
            isCharacter ? s.character_delete_confirm : s.race_delete_confirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(s.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              s.delete,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await _controller.deleteItem(item);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isCharacter ? s.character_deleted : s.race_deleted,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${s.delete_error}: $e'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }
}

class _ToolsGrid extends StatelessWidget {
  const _ToolsGrid({required this.onNavigate});

  final void Function(Widget) onNavigate;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    final tools = [
      _ToolItem(
        title: s.randomNumberGenerator,
        icon: Icons.casino_rounded,
        iconColor: colorScheme.primary,
        page: const RandomNumberPage(),
      ),
      _ToolItem(
        title: s.export_pdf_settings,
        icon: Icons.picture_as_pdf_rounded,
        iconColor: colorScheme.primary,
        page: const ExportPdfSettingsPage(),
      ),
      _ToolItem(
        title: s.templates,
        icon: Icons.library_books_rounded,
        iconColor: colorScheme.primary,
        page: const TemplatesPage(),
      ),
      _ToolItem(
        title: s.calendar,
        subtitle: s.event_calendar,
        icon: Icons.calendar_today_rounded,
        iconColor: colorScheme.primary,
        page: const CalendarPage(),
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = (constraints.maxWidth / 180).floor().clamp(2, 5);
        return GridView.builder(
          padding: const EdgeInsets.all(4),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
            childAspectRatio: 1,
          ),
          itemCount: tools.length,
          itemBuilder: (context, index) {
            final tool = tools[index];
            return ToolKeepCard(
              title: tool.title,
              subtitle: tool.subtitle,
              icon: tool.icon,
              iconColor: tool.iconColor,
              onTap: () => onNavigate(tool.page),
            );
          },
        );
      },
    );
  }
}

class _ContentGrid extends StatelessWidget {
  const _ContentGrid({
    required this.controller,
    required this.onCharacterTap,
    required this.onCharacterContextMenu,
    required this.onRaceTap,
    required this.onRaceContextMenu,
  });

  final HomeController controller;
  final void Function(CharacterHomeItem) onCharacterTap;
  final void Function(CharacterHomeItem) onCharacterContextMenu;
  final void Function(RaceHomeItem) onRaceTap;
  final void Function(RaceHomeItem) onRaceContextMenu;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => controller.loadData(),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final crossAxisCount =
              (constraints.maxWidth / 180).floor().clamp(2, 5);
          return GridView.builder(
            padding: const EdgeInsets.all(4),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
              childAspectRatio: 1,
            ),
            itemCount: controller.filteredItems.length,
            itemBuilder: (context, index) {
              final item = controller.filteredItems[index];
              return switch (item) {
                CharacterHomeItem(:final character) => CharacterKeepCard(
                    character: character,
                    onTap: () => onCharacterTap(item),
                    onContextMenuTap: () => onCharacterContextMenu(item),
                    formattedDate:
                        character.lastEdited.toRelativeString(context),
                  ),
                RaceHomeItem(:final race) => RaceKeepCard(
                    race: race,
                    characterCount: controller.characterCountForRace(race),
                    onTap: () => onRaceTap(item),
                    onContextMenuTap: () => onRaceContextMenu(item),
                  ),
              };
            },
          );
        },
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.isSearching,
    required this.onCreateNew,
  });

  final bool isSearching;
  final VoidCallback onCreateNew;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_outline_rounded,
              size: 64,
              color: colorScheme.onSurface.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              isSearching ? s.nothing_found : s.no_content_home,
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
            if (!isSearching) ...[
              const SizedBox(height: 8),
              Text(
                s.create_first_content,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: onCreateNew,
                child: Text(s.create),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ToolItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Widget page;

  _ToolItem({
    required this.title,
    this.subtitle = '',
    required this.icon,
    required this.iconColor,
    required this.page,
  });
}

enum HomeContentType { charactersAndRaces, tools }

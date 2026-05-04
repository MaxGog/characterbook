import 'dart:async';
import 'package:characterbook/generated/l10n.dart';
import 'package:characterbook/data/models/character_model.dart';
import 'package:characterbook/data/models/race_model.dart';
import 'package:characterbook/data/services/character_service.dart';
import 'package:characterbook/services/date_formatter.dart';
import 'package:characterbook/data/services/race_service.dart';
import 'package:characterbook/ui/controllers/home_controller.dart';
import 'package:characterbook/ui/widgets/modals/character_modal_card.dart';
import 'package:characterbook/ui/widgets/modals/race_modal_card.dart';
import 'package:characterbook/ui/navigation/menu_content.dart';
import 'package:characterbook/ui/screens/characters/character_management_screen.dart';
import 'package:characterbook/ui/screens/notes/note_management_screen.dart';
import 'package:characterbook/ui/screens/races/race_management_screen.dart';
import 'package:characterbook/ui/widgets/buttons/home_fab_menu.dart';
import 'package:characterbook/ui/widgets/items/character_keep_card_item.dart';
import 'package:characterbook/ui/widgets/items/home_item.dart';
import 'package:characterbook/ui/widgets/items/race_keep_card_item.dart';
import 'package:characterbook/ui/widgets/items/tool_keep_card_item.dart';
import 'package:characterbook/ui/widgets/tools_context_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeController _controller;
  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    final characterService = context.read<CharacterService>();
    final raceService = context.read<RaceService>();
    _controller = HomeController(
      characterService: characterService,
      raceService: raceService,
    );
    _loadData();
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      await _controller.loadData();
      if (mounted) setState(() {});
    } catch (e, stackTrace) {
      debugPrint('Error loading home data: $e\n$stackTrace');
    }
  }

  void _onSearchChanged(String query) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        _controller.setSearchQuery(query);
      }
    });
  }

  void _onSearchSubmitted(String query) {
    _searchDebounce?.cancel();
    _controller.setSearchQuery(query);
  }

  Future<void> _createNewContent() async {
    
  }

  void _navigateToTool(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  void _showAccountMenu() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(32),
              ),
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 4),
                  width: 32,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () => Navigator.pop(context),
                        tooltip: S.of(context).close,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: MenuContent(
                    scrollController: scrollController,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return ChangeNotifierProvider.value(
      value: _controller,
      child: Scaffold(
        appBar: AppBar(
          title: _buildSearchBar(context),
          centerTitle: true,
          elevation: 0,
          scrolledUnderElevation: 3,
          backgroundColor: colorScheme.surface,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/iconapp.png',
              height: 24,
              errorBuilder: (_, __, ___) => const Icon(Icons.book_rounded, size: 32),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.account_circle_rounded),
              iconSize: 32,
              onPressed: _showAccountMenu,
              tooltip: s.more_options,
            ),
          ],
        ),
        floatingActionButton: HomeFloatingMenu(
          onCreateCharacter: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CharacterManagementScreen()),
            ).then((result) {
              if (result == true && mounted) _loadData();
            });
          },
          onCreateRace: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RaceManagementScreen()),
            ).then((result) {
              if (result == true && mounted) _loadData();
            });
          },
          onCreateNote: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NoteManagementScreen()),
            ).then((result) {
              if (result == true && mounted) _loadData();
            });
          },
        ),
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 4),
              Expanded(
                child: Consumer<HomeController>(
                  builder: (context, controller, _) {
                    if (!controller.hasItems &&
                        controller.searchQuery.isEmpty) {
                      return _EmptyState(
                        isSearching: false,
                        onCreateNew: _createNewContent,
                      );
                    }
                    return _ContentGrid(
                      controller: controller,
                      onCharacterTap: _showCharacterDetail,
                      onCharacterContextMenu: _showCharacterContextMenu,
                      onRaceTap: _showRaceDetail,
                      onRaceContextMenu: _showRaceContextMenu,
                      onToolTap: (tool) => _navigateToTool(tool.page),
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

  Widget _buildSearchBar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final s = S.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SearchBar(
        controller: _searchController,
        hintText: s.app_name,
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 16),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        ),
        backgroundColor:
            WidgetStatePropertyAll(colorScheme.surfaceContainerHigh),
        surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
        elevation: const WidgetStatePropertyAll(0),
        onChanged: _onSearchChanged,
        onSubmitted: _onSearchSubmitted,
        textStyle: WidgetStatePropertyAll(
          TextStyle(
            color: colorScheme.onSurface,
          ),
        ),
        hintStyle: WidgetStatePropertyAll(
          TextStyle(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.bold,
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
        builder: (_) => CharacterManagementScreen(character: character),
      ),
    );
    if (result == true && mounted) await _loadData();
  }

  Future<void> _editRace(Race race) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RaceManagementScreen(race: race),
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
          isCharacter ? s.character_delete_confirm : s.race_delete_confirm,
        ),
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
    } catch (e, stackTrace) {
      debugPrint('Error deleting item: $e\n$stackTrace');
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

class _ContentGrid extends StatelessWidget {
  const _ContentGrid({
    required this.controller,
    required this.onCharacterTap,
    required this.onCharacterContextMenu,
    required this.onRaceTap,
    required this.onRaceContextMenu,
    required this.onToolTap,
  });

  final HomeController controller;
  final void Function(CharacterHomeItem) onCharacterTap;
  final void Function(CharacterHomeItem) onCharacterContextMenu;
  final void Function(RaceHomeItem) onRaceTap;
  final void Function(RaceHomeItem) onRaceContextMenu;
  final void Function(ToolHomeItem) onToolTap;

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
                CharacterHomeItem(:final character) => CharacterKeepCardItem(
                    character: character,
                    onTap: () => onCharacterTap(item),
                    onContextMenuTap: () => onCharacterContextMenu(item),
                    formattedDate:
                        character.lastEdited.toRelativeString(context),
                  ),
                RaceHomeItem(:final race) => RaceKeepCardItem(
                    race: race,
                    characterCount: controller.characterCountForRace(race),
                    onTap: () => onRaceTap(item),
                    onContextMenuTap: () => onRaceContextMenu(item),
                  ),
                ToolHomeItem() => ToolKeepCardItem(
                    title: item.getTitle(context),
                    subtitle: item.getSubtitle(context),
                    icon: item.getIcon(),
                    iconColor: Theme.of(context).colorScheme.primary,
                    onTap: () => onToolTap(item),
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
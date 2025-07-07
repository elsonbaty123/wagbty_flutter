import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/locale_provider.dart';

// Provider for theme mode
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.system) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDark');
    if (isDark != null) {
      state = isDark ? ThemeMode.dark : ThemeMode.light;
    } else {
      state = ThemeMode.system;
    }
  }

  Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    if (state == ThemeMode.dark) {
      state = ThemeMode.light;
      await prefs.setBool('isDark', false);
    } else {
      state = ThemeMode.dark;
      await prefs.setBool('isDark', true);
    }
  }
}

class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isRTL = ref.watch(localeProvider.notifier).isRTL;
    
    return AppBar(
      title: const SizedBox.shrink(),
      centerTitle: true,
      actions: [
        // Language switcher
        IconButton(
          icon: Text(
            isRTL ? 'EN' : 'عربي',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          onPressed: () {
            ref.read(localeProvider.notifier).toggleLocale();
          },
        ),
        const SizedBox(width: 8),
        // Search button
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            showSearch(
              context: context,
              delegate: CustomSearchDelegate(),
            );
          },
        ),
        // Menu button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'theme') {
                ref.read(themeProvider.notifier).toggleTheme();
              } else if (value == 'language') {
                ref.read(localeProvider.notifier).toggleLocale();
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'theme',
                  child: Row(
                    children: [
                      Icon(
                        isDark ? Icons.light_mode : Icons.dark_mode,
                      ),
                      const SizedBox(width: 12),
                      Text(isDark ? "Light Theme" : "Dark Theme"),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'language',
                  child: Row(
                    children: [
                      const Icon(Icons.language),
                      const SizedBox(width: 12),
                      Text(
                        isRTL 
                          ? 'English' 
                          : 'العربية',
                      ),
                    ],
                  ),
                ),
              ];
            },
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class CustomSearchDelegate extends SearchDelegate<String> {
  // List of search items (replace with your actual data source)
  final List<String> _searchItems = [
    'Pizza',
    'Burger',
    'Pasta',
    'Salad',
    'Sushi',
    'Steak',
    'Desserts',
    'Beverages',
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // This is called when the user selects a search result
    return Center(
      child: Text('Search result for: $query'),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<String> suggestionList = query.isEmpty
        ? []
        : _searchItems
            .where((item) => item.toLowerCase().contains(query.toLowerCase()))
            .toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestionList[index]),
          onTap: () {
            query = suggestionList[index];
            showResults(context);
          },
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'theme_toggle_button.dart';

/// A reusable scaffold that provides a bottom navigation bar shared across
/// the main sections of the app.
class MainScaffold extends StatelessWidget {
  const MainScaffold({
    super.key,
    required this.body,
    required this.currentIndex,
    this.appBar,
  });

  final Widget body;
  final int currentIndex;
  final PreferredSizeWidget? appBar;

  static const _destinations = [
    _NavDestination(label: 'الرئيسية', icon: Icons.home, path: '/'),
    _NavDestination(label: 'الطهاة', icon: Icons.people, path: '/chefs'),
    _NavDestination(label: 'الأطباق', icon: Icons.restaurant, path: '/dishes'),
    _NavDestination(label: 'المفضلة', icon: Icons.favorite, path: '/favorites'),
    _NavDestination(label: 'حسابي', icon: Icons.person, path: '/profile'),
  ];

  void _onTap(BuildContext context, int index) {
    if (index == currentIndex) return; // already on that tab
    context.go(_destinations[index].path);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Scaffold(
      appBar: appBar ?? AppBar(
        title: const Text('وجبتي', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: ThemeToggleButton(),
          ),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: body,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(26), // 0.1 * 255 = 25.5
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: colorScheme.primary,
            unselectedItemColor: colorScheme.onSurface.withAlpha(153), // 0.6 * 255 = 153
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            unselectedLabelStyle: const TextStyle(fontSize: 11),
            showUnselectedLabels: true,
            elevation: 8,
            backgroundColor: theme.bottomNavigationBarTheme.backgroundColor ?? colorScheme.surface,
            onTap: (i) => _onTap(context, i),
            items: _destinations
                .map((d) => BottomNavigationBarItem(
                      icon: Container(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Icon(d.icon, size: 24),
                      ),
                      label: d.label,
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}

class _NavDestination {
  const _NavDestination({required this.label, required this.icon, required this.path});
  final String label;
  final IconData icon;
  final String path;
}

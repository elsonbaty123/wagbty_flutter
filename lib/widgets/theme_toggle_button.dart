import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/theme_provider.dart';

class ThemeToggleButton extends ConsumerWidget {
  const ThemeToggleButton({super.key, this.size = 24.0});

  final double size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark || 
                  (themeMode == ThemeMode.system && 
                   MediaQuery.of(context).platformBrightness == Brightness.dark);

    return IconButton(
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(scale: animation, child: child),
          );
        },
        child: isDark
            ? const Icon(Icons.light_mode, key: ValueKey('light'))
            : const Icon(Icons.dark_mode, key: ValueKey('dark')),
      ),
      onPressed: () {
        ref.read(themeProvider.notifier).toggle();
      },
      iconSize: size,
      tooltip: isDark ? 'الوضع النهاري' : 'الوضع الليلي',
    );
  }
}

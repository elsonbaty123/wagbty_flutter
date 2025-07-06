import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Stores IDs of favorite dishes.
class FavoritesNotifier extends StateNotifier<Set<String>> {
  FavoritesNotifier() : super({}) {
    _load();
  }

  static const _kKey = 'favorites';

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList(_kKey) ?? [];
    state = ids.toSet();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_kKey, state.toList());
  }

  bool isFavorite(String dishId) => state.contains(dishId);

  void toggle(String dishId) {
    if (state.contains(dishId)) {
      state = {...state}..remove(dishId);
    } else {
      state = {...state, dishId};
    }
    _save();
  }
}

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, Set<String>>(
  (ref) => FavoritesNotifier(),
);

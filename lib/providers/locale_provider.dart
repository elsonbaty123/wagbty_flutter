import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('ar')) {
    _load();
  }

  static const _kKey = 'locale';
  bool get isRTL => state.languageCode == 'ar';

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_kKey);
    if (languageCode != null) {
      state = Locale(languageCode);
    }
  }

  Future<void> toggleLocale() async {
    final newLocale = state.languageCode == 'ar' 
        ? const Locale('en', 'US') 
        : const Locale('ar', 'SA');
    await setLocale(newLocale);
  }

  Future<void> setLocale(Locale locale) async {
    state = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kKey, locale.languageCode);
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) => LocaleNotifier());

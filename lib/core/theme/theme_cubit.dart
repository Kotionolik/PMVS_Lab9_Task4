import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system) { _load(); }
  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final m = prefs.getString('theme_mode') ?? 'system';
      emit(_fromString(m));
    } catch (e, s) { print('ThemeCubit load: $e\n$s'); }
  }
  Future<void> setTheme(ThemeMode m) async {
    emit(m);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme_mode', m.name);
  }
  ThemeMode _fromString(String s) {
    switch (s) {
      case 'light': return ThemeMode.light;
      case 'dark': return ThemeMode.dark;
      default: return ThemeMode.system;
    }
  }
}
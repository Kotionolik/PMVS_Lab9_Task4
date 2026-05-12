import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system);

  Future<void> loadTheme() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String savedMode =
          prefs.getString(AppConstants.prefThemeMode) ??
              AppConstants.themeSystem;

      emit(_themeModeFromString(savedMode));
    } catch (e, stackTrace) {
      print('Ошибка загрузки темы: $e');
      print(stackTrace);
      emit(ThemeMode.system);
    }
  }

  Future<void> setTheme(ThemeMode mode) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        AppConstants.prefThemeMode,
        _themeModeToString(mode),
      );

      emit(mode);
    } catch (e, stackTrace) {
      print('Ошибка сохранения темы: $e');
      print(stackTrace);
    }
  }

  Future<void> cycleThemeMode() async {
    switch (state) {
      case ThemeMode.system:
        await setTheme(ThemeMode.light);
        break;
      case ThemeMode.light:
        await setTheme(ThemeMode.dark);
        break;
      case ThemeMode.dark:
        await setTheme(ThemeMode.system);
        break;
    }
  }

  Future<void> resetTheme() async {
    await setTheme(ThemeMode.system);
  }

  ThemeMode _themeModeFromString(String value) {
    switch (value) {
      case AppConstants.themeLight:
        return ThemeMode.light;
      case AppConstants.themeDark:
        return ThemeMode.dark;
      case AppConstants.themeSystem:
      default:
        return ThemeMode.system;
    }
  }

  String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return AppConstants.themeLight;
      case ThemeMode.dark:
        return AppConstants.themeDark;
      case ThemeMode.system:
        return AppConstants.themeSystem;
    }
  }
}
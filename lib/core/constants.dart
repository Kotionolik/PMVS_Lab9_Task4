import 'package:flutter/material.dart';

abstract final class AppConstants {
  static const String appName = 'City Parking';
  static const String packageVersion = '1.0.0';

  static const String prefThemeMode = 'pref_theme_mode';
  static const String prefLocaleCode = 'pref_locale_code';
  static const String prefIsAuthorized = 'pref_is_authorized';
  static const String prefUserEmail = 'pref_user_email';
  static const String prefRememberSession = 'pref_remember_session';

  static const String parkingCacheBox = 'parking_cache_box';
  static const String settingsBox = 'settings_box';
  static const String authBox = 'auth_box';

  static const String routeLogin = '/login';
  static const String routeHome = '/home';
  static const String routeHistory = '/history';
  static const String routeSettings = '/settings';
  static const String routeFavorites = '/favorites';
  static const String routeStatistics = '/statistics';
  static const String routeParkingDetails = '/parking-details';
  static const String routeBooking = '/booking';
  static const String routePayment = '/payment';

  static const double minMobileWidth = 360;
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 840;
  static const double desktopBreakpoint = 1200;
  static const double largeDesktopBreakpoint = 1600;
  static const double maxContentWidth = 1440;

  static const double paddingXs = 4;
  static const double paddingSm = 8;
  static const double paddingMd = 16;
  static const double paddingLg = 24;
  static const double paddingXl = 32;

  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 20;

  static const double toolbarHeight = 64;
  static const double bottomBarHeight = 68;
  static const double navigationRailWidth = 88;
  static const double extendedNavigationRailWidth = 240;

  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  static const Color seedColor = Color(0xFF1565C0);

  static const String notificationChannelId = 'city_parking_channel';
  static const String notificationChannelName = 'City Parking Notifications';
  static const String notificationChannelDescription =
      'Уведомления о бронированиях и оплате';

  static const List<String> supportedLanguageCodes = <String>[
    'ru',
    'en',
    'be',
  ];

  static const String defaultLanguageCode = 'ru';

  static const String themeSystem = 'system';
  static const String themeLight = 'light';
  static const String themeDark = 'dark';
}

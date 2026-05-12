import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_be.dart';
import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    final AppLocalizations? instance =
        Localizations.of<AppLocalizations>(context, AppLocalizations);
    assert(instance != null, 'AppLocalizations не найдены в дереве виджетов.');
    return instance!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  static const List<Locale> supportedLocales = <Locale>[
    Locale('ru'),
    Locale('en'),
    Locale('be'),
  ];

  String get appTitle;
  String get appDescription;
  String get home;
  String get history;
  String get settings;
  String get favorites;
  String get statistics;
  String get bookings;
  String get login;
  String get loginSubtitle;
  String get logout;
  String get logoutConfirmation;
  String get email;
  String get password;
  String get signIn;
  String get signOut;
  String get invalidCredentials;
  String get sessionSaved;
  String get sessionExpired;
  String get theme;
  String get systemTheme;
  String get lightTheme;
  String get darkTheme;
  String get themeChanged;
  String get language;
  String get languageChanged;
  String get clearCache;
  String get clearCacheConfirmation;
  String get cacheCleared;
  String get version;
  String get versionInfo;
  String get offline;
  String get offlineMode;
  String get onlineMode;
  String get offlineDataLoaded;
  String get notifications;
  String get parkingLots;
  String get parkingLot;
  String get freeSpots;
  String get occupiedSpots;
  String get pricePerHour;
  String get details;
  String get mapView;
  String get listView;
  String get bookNow;
  String get selectDateTime;
  String get durationHours;
  String get confirmBooking;
  String get payment;
  String get cardNumber;
  String get expiryDate;
  String get cvv;
  String get invalidCard;
  String get amount;
  String get pay;
  String get bookingSuccessful;
  String get paymentSuccessful;
  String get cancel;
  String get noBookings;
  String get noFavorites;
  String get addFavorite;
  String get removeFavorite;
  String get favoritesUpdated;
  String get startTime;
  String get endTime;
  String get status;
  String get active;
  String get cancelled;
  String get completed;
  String get refresh;
  String get retry;
  String get error;
  String get ok;
  String get loading;
  String get noData;
  String get parkingStatistics;
  String get availability;
  String get occupied;
  String get available;
  String get detailView;
  String get addToFavorites;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(
      lookupAppLocalizations(locale),
    );
  }

  @override
  bool isSupported(Locale locale) {
    return <String>['ru', 'en', 'be'].contains(locale.languageCode);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  switch (locale.languageCode) {
    case 'ru':
      return AppLocalizationsRu();
    case 'en':
      return AppLocalizationsEn();
    case 'be':
      return AppLocalizationsBe();
  }

  throw FlutterError(
    'AppLocalizations.delegate не поддерживает locale "$locale".',
  );
}

import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

extension ContextExtensions on BuildContext {
  Size get screenSize => MediaQuery.sizeOf(this);
  double get width => screenSize.width;
  double get height => screenSize.height;
  bool get isMobile => width < 600;
  bool get isTablet => width >= 600 && width < 1024;
  bool get isDesktop => width >= 1024;
  double wp(double p) => width * (p / 100);
  double hp(double p) => height * (p / 100);
  AppLocalizations get l10n => AppLocalizations.of(this);
}
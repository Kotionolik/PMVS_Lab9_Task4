import 'package:flutter/material.dart';

import '../core/constants.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double width = constraints.maxWidth;

        if (width >= AppConstants.tabletBreakpoint) {
          return desktop ?? tablet ?? mobile;
        }

        if (width >= AppConstants.mobileBreakpoint) {
          return tablet ?? mobile;
        }

        return mobile;
      },
    );
  }
}

class ResponsiveConstrainedBox extends StatelessWidget {
  final Widget child;
  final double? maxWidth;
  final EdgeInsetsGeometry? padding;
  final Alignment alignment;

  const ResponsiveConstrainedBox({
    super.key,
    required this.child,
    this.maxWidth,
    this.padding,
    this.alignment = Alignment.topCenter,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Padding(
        padding: padding ?? context.pagePadding,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: maxWidth ?? context.contentMaxWidth,
          ),
          child: child,
        ),
      ),
    );
  }
}

extension ResponsiveContext on BuildContext {
  Size get screenSize => MediaQuery.sizeOf(this);

  double get screenWidth => screenSize.width;

  double get screenHeight => screenSize.height;

  bool get isMobile => screenWidth < AppConstants.mobileBreakpoint;

  bool get isTablet =>
      screenWidth >= AppConstants.mobileBreakpoint &&
      screenWidth < AppConstants.tabletBreakpoint;

  bool get isDesktop => screenWidth >= AppConstants.tabletBreakpoint;

  bool get isLargeDesktop =>
      screenWidth >= AppConstants.largeDesktopBreakpoint;

  double get contentMaxWidth {
    if (isLargeDesktop) {
      return AppConstants.maxContentWidth;
    }
    if (isDesktop) {
      return 1200;
    }
    if (isTablet) {
      return 900;
    }
    return screenWidth;
  }

  EdgeInsets get pagePadding {
    if (isLargeDesktop) {
      return const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingXl,
        vertical: AppConstants.paddingLg,
      );
    }
    if (isDesktop) {
      return const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingLg,
        vertical: AppConstants.paddingMd,
      );
    }
    if (isTablet) {
      return const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingMd,
        vertical: AppConstants.paddingMd,
      );
    }
    return const EdgeInsets.all(AppConstants.paddingMd);
  }

  double responsiveValue({
    required double mobile,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    if (isLargeDesktop) {
      return largeDesktop ?? desktop ?? tablet ?? mobile;
    }
    if (isDesktop) {
      return desktop ?? tablet ?? mobile;
    }
    if (isTablet) {
      return tablet ?? mobile;
    }
    return mobile;
  }

  int adaptiveGridCount({
    int mobile = 1,
    int tablet = 2,
    int desktop = 3,
    int largeDesktop = 4,
  }) {
    if (isLargeDesktop) return largeDesktop;
    if (isDesktop) return desktop;
    if (isTablet) return tablet;
    return mobile;
  }

  double adaptiveSpacing({
    double mobile = 12,
    double tablet = 16,
    double desktop = 20,
  }) {
    if (isDesktop) return desktop;
    if (isTablet) return tablet;
    return mobile;
  }
}

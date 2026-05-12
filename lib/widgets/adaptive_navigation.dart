import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/constants.dart';
import '../core/extensions/context_extensions.dart';
import 'responsive_layout.dart';

class AdaptiveNavigationItem {
  final String label;
  final IconData icon;
  final IconData? selectedIcon;

  const AdaptiveNavigationItem({
    required this.label,
    required this.icon,
    this.selectedIcon,
  });
}

class AdaptiveNavigation extends StatelessWidget {
  final String title;
  final int currentIndex;
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final Widget? drawerHeader;
  final Widget? endDrawer;
  final Color? backgroundColor;
  final bool extendRail;

  const AdaptiveNavigation({
    super.key,
    required this.title,
    required this.currentIndex,
    required this.body,
    this.appBar,
    this.floatingActionButton,
    this.drawerHeader,
    this.endDrawer,
    this.backgroundColor,
    this.extendRail = true,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final destinations = <AdaptiveNavigationItem>[
      AdaptiveNavigationItem(label: l10n.home, icon: Icons.home),
      AdaptiveNavigationItem(label: l10n.favorites, icon: Icons.favorite),
      AdaptiveNavigationItem(label: l10n.history, icon: Icons.history),
      AdaptiveNavigationItem(label: l10n.statistics, icon: Icons.bar_chart),
      AdaptiveNavigationItem(label: l10n.settings, icon: Icons.settings),
    ];

    void onDestinationSelected(int index) {
      switch (index) {
        case 0:
          context.go('/home');
          break;
        case 1:
          context.go('/favorites');
          break;
        case 2:
          context.go('/history');
          break;
        case 3:
          context.go('/statistics');
          break;
        case 4:
          context.go('/settings');
          break;
      }
    }

    final effectiveAppBar = appBar ?? AppBar(title: Text(title));

    if (ContextExtensions(context).isDesktop) {
      return _DesktopNavigation(
        destinations: destinations,
        currentIndex: currentIndex,
        onDestinationSelected: onDestinationSelected,
        appBar: effectiveAppBar,
        floatingActionButton: floatingActionButton,
        endDrawer: endDrawer,
        backgroundColor: backgroundColor,
        extendRail: extendRail,
        body: body,
      );
    }

    return _MobileNavigation(
      destinations: destinations,
      currentIndex: currentIndex,
      onDestinationSelected: onDestinationSelected,
      appBar: effectiveAppBar,
      floatingActionButton: floatingActionButton,
      drawerHeader: drawerHeader,
      endDrawer: endDrawer,
      backgroundColor: backgroundColor,
      body: body,
    );
  }
}

class _DesktopNavigation extends StatelessWidget {
  final List<AdaptiveNavigationItem> destinations;
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final Widget? endDrawer;
  final Color? backgroundColor;
  final bool extendRail;

  const _DesktopNavigation({
    required this.destinations,
    required this.currentIndex,
    required this.onDestinationSelected,
    required this.body,
    this.appBar,
    this.floatingActionButton,
    this.endDrawer,
    this.backgroundColor,
    this.extendRail = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: appBar,
      endDrawer: endDrawer,
      floatingActionButton: floatingActionButton,
      body: Row(
        children: <Widget>[
          NavigationRail(
            selectedIndex: currentIndex,
            onDestinationSelected: onDestinationSelected,
            extended: extendRail && context.screenWidth >= 1100,
            minWidth: AppConstants.navigationRailWidth,
            minExtendedWidth: AppConstants.extendedNavigationRailWidth,
            labelType: extendRail && context.screenWidth >= 1100
                ? NavigationRailLabelType.none
                : NavigationRailLabelType.all,
            destinations: destinations
                .map(
                  (AdaptiveNavigationItem item) => NavigationRailDestination(
                    icon: Icon(item.icon),
                    selectedIcon: item.selectedIcon != null
                        ? Icon(item.selectedIcon)
                        : Icon(item.icon),
                    label: Text(item.label),
                  ),
                )
                .toList(),
          ),
          const VerticalDivider(width: 1),
          Expanded(
            child: ResponsiveConstrainedBox(
              child: body,
            ),
          ),
        ],
      ),
    );
  }
}

class _MobileNavigation extends StatelessWidget {
  final List<AdaptiveNavigationItem> destinations;
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final Widget? drawerHeader;
  final Widget? endDrawer;
  final Color? backgroundColor;

  const _MobileNavigation({
    required this.destinations,
    required this.currentIndex,
    required this.onDestinationSelected,
    required this.body,
    this.appBar,
    this.floatingActionButton,
    this.drawerHeader,
    this.endDrawer,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: appBar,
      endDrawer: endDrawer,
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              if (drawerHeader != null) drawerHeader!,
              Expanded(
                child: ListView.builder(
                  itemCount: destinations.length,
                  itemBuilder: (BuildContext context, int index) {
                    final AdaptiveNavigationItem item = destinations[index];
                    final bool selected = currentIndex == index;

                    return ListTile(
                      leading: Icon(
                        selected && item.selectedIcon != null
                            ? item.selectedIcon
                            : item.icon,
                      ),
                      title: Text(item.label),
                      selected: selected,
                      onTap: () {
                        Navigator.of(context).pop();
                        onDestinationSelected(index);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: floatingActionButton,
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onDestinationSelected,
        type: BottomNavigationBarType.fixed,
        items: destinations
            .map(
              (AdaptiveNavigationItem item) => BottomNavigationBarItem(
                icon: Icon(item.icon),
                activeIcon: Icon(item.selectedIcon ?? item.icon),
                label: item.label,
              ),
            )
            .toList(),
      ),
    );
  }
}
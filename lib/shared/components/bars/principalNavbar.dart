import 'package:acolherconsultas/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class CustomNavbar extends StatelessWidget {
  final List<IconData> icons;
  final List<String> titles;
  final List<Widget> screens;
  final List<Color> activeIconColors;
  final List<Color> inactiveIconColors;

  const CustomNavbar({
    super.key,
    required this.icons,
    required this.titles,
    required this.screens,
    required this.activeIconColors,
    required this.inactiveIconColors,
  });

  @override
  Widget build(BuildContext context) {
    assert(
      icons.length == titles.length &&
          titles.length == screens.length &&
          screens.length == activeIconColors.length &&
          activeIconColors.length == inactiveIconColors.length,
    );

    List<PersistentTabConfig> tabs = [];
    for (int i = 0; i < icons.length; i++) {
      tabs.add(
        PersistentTabConfig(
          screen: screens[i],
          item: ItemConfig(
            inactiveIcon: Icon(icons[i], color: inactiveIconColors[i]),
            icon: Icon(icons[i], color: activeIconColors[i]),
            title: titles[i],
            textStyle: const TextStyle(
                fontFamily: "Roboto", fontWeight: FontWeight.bold),
            inactiveForegroundColor: inactiveIconColors[i],
            activeForegroundColor: activeIconColors[i],
          ),
        ),
      );
    }

    return PersistentTabView(
      gestureNavigationEnabled: true,
      controller: PersistentTabController(initialIndex: 2),
      tabs: tabs,
      navBarBuilder: (navBarConfig) => Style15BottomNavBar(
        navBarDecoration: const NavBarDecoration(color: amareloNavbar),
        navBarConfig: navBarConfig,
      ),
    );
  }
}

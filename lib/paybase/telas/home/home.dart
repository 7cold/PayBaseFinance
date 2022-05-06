import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:ionicons/ionicons.dart';
import 'package:layouts/paybase/telas/home/home_dash.dart';
import 'package:layouts/paybase/telas/home/home_home.dart';
import 'package:layouts/paybase/telas/home/home_profile.dart';

import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class HomePB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      backgroundColor: Get.isDarkMode
          ? Colors.grey[850]
          : CupertinoColors.systemGroupedBackground,
      items: [
        PersistentBottomNavBarItem(
          icon: Icon(Ionicons.home_outline),
          activeColorPrimary: Colors.deepPurple.shade400,
          inactiveColorPrimary: CupertinoColors.systemGrey,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(Ionicons.layers_outline),
          activeColorPrimary: Colors.deepPurple.shade400,
          inactiveColorPrimary: CupertinoColors.systemGrey,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(Ionicons.person_outline),
          activeColorPrimary: Colors.deepPurple.shade400,
          inactiveColorPrimary: CupertinoColors.systemGrey,
        ),
      ],
      screens: [
        HomeHome(),
        HomeDash(),
        HomeProfile(),
      ],
      navBarStyle: NavBarStyle.style12,
    );
  }
}

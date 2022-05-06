import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:layouts/paybase/const/colors.dart';
import 'package:layouts/paybase/const/widgets.dart';
import 'package:layouts/paybase/controller/controller.dart';
import 'package:layouts/paybase/telas/home/home.dart';
import 'package:layouts/paybase/telas/login.dart';

class Root extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Controller c = Get.put(Controller());

    return Obx(() {
      if (c.loading.value == true)
        return Scaffold(
            backgroundColor: Color(corBack), body: WidgetsPB.loading);
      if (c.userData['name'] == null) {
        return LoginPB();
      } else {
        return HomePB();
      }
    });
  }
}

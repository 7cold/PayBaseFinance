import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:layouts/paybase/const/buttons.dart';
import 'package:layouts/paybase/const/colors.dart';
import 'package:layouts/paybase/const/text.dart';
import 'package:layouts/paybase/controller/controller.dart';
import 'package:layouts/paybase/telas/accountBank.dart';

class HomeProfile extends StatelessWidget {
  final Controller c = Get.put(Controller());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text("Perfil", style: TextPB.h4),
                    ButtonsPB().textButton(
                      "Editar Perfil",
                      () {},
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 35),
                child: Center(
                  child: CircleAvatar(
                    maxRadius: 45,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  "Léo Coldibelli",
                  style: TextPB.h3,
                ),
              ),
              Divider(),
              _Item(
                func: () {
                  Get.to(() => AccoutBankPB());
                },
                icon: Ionicons.cash_outline,
                title: "Contas",
              ),
              Spacer(),
              Align(
                alignment: Alignment.bottomCenter,
                child: ButtonsPB().button(
                  "Sair",
                  () {
                    c.logout();
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function func;

  _Item({this.title, this.icon, this.func});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: func,
        child: Container(
          padding: EdgeInsets.all(10),
          width: double.infinity,
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Color(corPri).withAlpha(180)),
                    child: Icon(icon),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: Text(title),
                  ),
                ],
              ),
              Icon(Icons.arrow_forward_ios_rounded)
            ],
          ),
        ),
      ),
    );
  }
}

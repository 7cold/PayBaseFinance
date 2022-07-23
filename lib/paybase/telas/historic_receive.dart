import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:layouts/paybase/const/cards.dart';
import 'package:layouts/paybase/const/widgets.dart';
import 'package:layouts/paybase/controller/controller.dart';

final Controller c = Get.put(Controller());

class HistoricReceivePB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: WidgetsPB().appBarPB("Histórico", null),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: c.purchases.map((pData) {
                      if (!pData.amount.isNegative) {
                        return CardPB().card(pData);
                      } else {
                        return SizedBox();
                      }
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

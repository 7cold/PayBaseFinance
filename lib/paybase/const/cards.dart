import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:layouts/paybase/const/buttons.dart';
import 'package:layouts/paybase/const/colors.dart';
import 'package:layouts/paybase/const/text.dart';
import 'package:layouts/paybase/const/widgets.dart';
import 'package:layouts/paybase/controller/controller.dart';
import 'package:layouts/paybase/data/purchases_data.dart';
import 'package:layouts/paybase/telas/transaction_detail.dart';
import 'package:intl/intl.dart';

final formatter = new NumberFormat("#,##0.00", "pt_BR");
final Controller c = Get.put(Controller());

class CardPB {
  Widget card(PurchaseData pData) => TextButton(
        style: ButtonStyle(
            elevation: MaterialStateProperty.all(0),
            backgroundColor: MaterialStateProperty.all(Colors.transparent),
            shadowColor: MaterialStateProperty.all(Colors.black),
            overlayColor: MaterialStateProperty.all(Color(corPri).withOpacity(0.3)),
            splashFactory: InkSplash.splashFactory,
            foregroundColor: Get.isDarkMode ? MaterialStateProperty.all(Color(corPri)) : MaterialStateProperty.all(Colors.black87)),
        onPressed: () => Get.to(() => TransactionDetailPB(
              pData: pData,
            )),
        onLongPress: () {
          showCupertinoModalPopup(
              context: Get.context,
              builder: (_) => CupertinoTheme(
                    data: CupertinoThemeData(primaryColor: Color(corPri)),
                    child: CupertinoActionSheet(
                      actions: [
                        CupertinoActionSheetAction(
                            onPressed: () {
                              Get.back();
                              Get.defaultDialog(middleText: "Confirmar Exclusão?", title: "Atenção", actions: [
                                SizedBox(
                                  width: Get.width / 1.8,
                                  child: ButtonsPB().button(pData.isParcela == 0 ? "Sim" : "Somente este", () {
                                    c.deletePurchase(pData);
                                    Get.back();
                                  }),
                                ),
                                pData.isParcela == 0
                                    ? SizedBox()
                                    : SizedBox(
                                        width: Get.width / 1.8,
                                        child: ButtonsPB().button("Este e os próximos", () async {
                                          Get.back();
                                          for (var x in pData.repeatId) {
                                            PurchaseData p = PurchaseData();
                                            p.id = x['repeatId'];
                                            if (pData.isParcela <= x['parcela']) await c.deletePurchase(p);
                                          }
                                        }),
                                      ),
                                Center(
                                  child: SizedBox(
                                    height: 45,
                                    width: Get.width / 1.8,
                                    child: ButtonsPB().textButton(
                                      "Cancelar",
                                      () => Get.back(),
                                    ),
                                  ),
                                ),
                              ]);
                            },
                            child: Text('Apagar')),
                        CupertinoActionSheetAction(
                            onPressed: () {
                              WidgetsPB().editPurchase(pData);
                            },
                            child: Text('Editar')),
                        CupertinoActionSheetAction(
                          onPressed: () {
                            c.changePay(pData);
                            Get.back();
                          },
                          child: Text(pData.pay == true ? "Não Pago" : "Pago"),
                        ),
                      ],
                      cancelButton: CupertinoActionSheetAction(
                        onPressed: () => Get.back(),
                        child: Text('Fechar'),
                      ),
                    ),
                  ));
        },
        child: Container(
          height: 80,
          width: double.infinity,
          child: Flex(
            direction: Axis.horizontal,
            children: [
              Flexible(
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      child: CircleAvatar(
                        backgroundColor: WidgetsPB().getColor(pData.category).shade300,
                        maxRadius: 24,
                      ),
                    ),
                    pData.pay == false
                        ? CircleAvatar(
                            maxRadius: 10,
                            backgroundColor: Colors.amber,
                            child: Center(
                              child: Icon(
                                Icons.watch_later_outlined,
                                size: 14,
                                color: Colors.black54,
                              ),
                            ),
                          )
                        : CircleAvatar(
                            maxRadius: 10,
                            backgroundColor: Colors.green,
                            child: Center(
                              child: Icon(
                                Icons.done_rounded,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                  ],
                ),
              ),
              Flexible(
                flex: 4,
                child: Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            pData.name == "" && !pData.amount.isNegative ? "Recebido" : pData.name,
                            style: TextPB.h4,
                          ),
                          Text(
                            DateFormat('dd/MM/yy')
                                .format(DateTime.fromMicrosecondsSinceEpoch(pData.date.microsecondsSinceEpoch))
                                .capitalize
                                .toString(),
                            style: TextPB.display6.copyWith(color: Colors.grey),
                          ),
                        ],
                      ),
                      Text(
                        "R\$ " + formatter.format(pData.amount),
                        style: TextPB.h4.copyWith(color: pData.amount.isNegative ? Colors.red.shade800 : CupertinoColors.activeGreen),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}

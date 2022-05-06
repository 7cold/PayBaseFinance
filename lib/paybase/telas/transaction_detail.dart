import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:layouts/paybase/const/text.dart';
import 'package:layouts/paybase/const/widgets.dart';
import 'package:layouts/paybase/controller/controller.dart';
import 'package:layouts/paybase/data/purchases_data.dart';
import 'package:intl/intl.dart';

final Controller c = Get.put(Controller());

class TransactionDetailPB extends StatelessWidget {
  final PurchaseData pData;

  TransactionDetailPB({Key key, this.pData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color = Get.isDarkMode ? Colors.grey.shade800 : Colors.grey.shade100;
    Color colorFont = Get.isDarkMode ? CupertinoColors.white : Colors.black87;

    num valorTotalPago = 0.0;
    num restaPagar = 0.0;

    c.purchases.forEach((element) {
      pData.repeatId.forEach((e) {
        if (element.id == e['repeatId']) {
          if (element.pay == true) {
            valorTotalPago = element.amount + valorTotalPago;
          } else if (element.pay == false) {
            restaPagar = element.amount + restaPagar;
          }
        }
      });
    });

    return Scaffold(
      appBar: WidgetsPB().appBarPB(pData.name, null),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 35),
                child: Center(
                  child: CircleAvatar(
                    backgroundColor: WidgetsPB().getColor(pData.category).shade400,
                    maxRadius: 45,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  pData.name,
                  style: TextPB.h3,
                ),
              ),
              Container(
                margin: EdgeInsets.all(15),
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(15)),
                child: Column(
                  children: [
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Status", style: TextPB.h5.copyWith(color: Colors.grey)),
                        pData.pay == true
                            ? Text("Completo", style: TextPB.h5.copyWith(color: Colors.green))
                            : Text("Pendente", style: TextPB.h5.copyWith(color: Colors.amber))
                      ],
                    ),
                    SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Categoria", style: TextPB.h5.copyWith(color: Colors.grey)),
                        Text(pData.category, style: TextPB.h5.copyWith(color: colorFont))
                      ],
                    ),
                    pData.isParcela == 0 ? SizedBox() : SizedBox(height: 25),
                    pData.isParcela == 0
                        ? SizedBox()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Parcela", style: TextPB.h5.copyWith(color: Colors.grey)),
                              Text(pData.isParcela.toString() + "/" + pData.repeatId[1]['totalParcela'].toString(),
                                  style: TextPB.h5.copyWith(color: colorFont))
                            ],
                          ),
                    pData.isParcela == 0 ? SizedBox() : SizedBox(height: 25),
                    pData.isParcela == 0
                        ? SizedBox()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Valor já pago", style: TextPB.h5.copyWith(color: Colors.grey)),
                              Text("R\$ " + c.real.format(valorTotalPago.abs()), style: TextPB.h5.copyWith(color: colorFont))
                            ],
                          ),
                    pData.isParcela == 0 ? SizedBox() : SizedBox(height: 25),
                    pData.isParcela == 0
                        ? SizedBox()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Resta pagar", style: TextPB.h5.copyWith(color: Colors.grey)),
                              Text("R\$ " + c.real.format(restaPagar), style: TextPB.h5.copyWith(color: colorFont))
                            ],
                          ),
                    SizedBox(height: 12),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(15),
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(15)),
                child: Column(
                  children: [
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Conta", style: TextPB.h5.copyWith(color: Colors.grey)),
                        Text(pData.account, style: TextPB.h5.copyWith(color: colorFont))
                      ],
                    ),
                    SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Valor", style: TextPB.h5.copyWith(color: Colors.grey)),
                        Text("R\$ " + c.real.format(pData.amount), style: TextPB.h5.copyWith(color: colorFont))
                      ],
                    ),
                    SizedBox(height: 12),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(15),
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(15)),
                child: Column(
                  children: [
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Data", style: TextPB.h5.copyWith(color: Colors.grey)),
                        Text(
                            DateFormat('dd/MM/yyyy')
                                .format(DateTime.fromMicrosecondsSinceEpoch(pData.date.microsecondsSinceEpoch))
                                .capitalize
                                .toString(),
                            style: TextPB.h5.copyWith(color: colorFont))
                      ],
                    ),
                    SizedBox(height: 12),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(15),
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(15)),
                child: Column(
                  children: [
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Observação", style: TextPB.h5.copyWith(color: Colors.grey)),
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            pData.obs,
                            style: TextPB.h5.copyWith(color: colorFont),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:layouts/paybase/const/text.dart';
import 'package:layouts/paybase/const/colors.dart';
import 'package:get/get.dart';
import 'package:layouts/paybase/const/widgets.dart';
import 'package:layouts/paybase/controller/controller.dart';
import 'package:layouts/paybase/telas/createPurchase.dart';

final Controller c = Get.put(Controller());

class HomeHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return c.userData == {}
            ? WidgetsPB.loading
            : Scaffold(
                body: SafeArea(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _cardTotalHome(),
                              Text(
                                "Lista de Pagamentos",
                                style: TextPB.display4,
                              ),
                              Center(
                                child: Container(
                                  margin: EdgeInsets.only(top: 15, bottom: 20),
                                  width: double.infinity,
                                  child: Wrap(
                                    alignment: WrapAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    runAlignment: WrapAlignment.spaceEvenly,
                                    children: c.category.map((value) {
                                      return _icon(value['name'], value['icon'],
                                          value['color']);
                                    }).toList(),
                                  ),
                                ),
                              ),
                              Text(
                                "Promoção e Descontos",
                                style: TextPB.display4,
                              ),
                            ],
                          ),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _cardPromo(
                                  Colors.deepPurple.shade800,
                                  "30%",
                                  "Estacionamento",
                                  "Consiga descontos exclusivos em seu estacionamento"),
                              _cardPromo(Colors.green.shade600, "15%", "Cinema",
                                  "Consiga descontos exclusivos em seu cinema"),
                              _cardPromo(Colors.indigo.shade400, "50%", "Museu",
                                  "Consiga descontos exclusivos em seu museu"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
      },
    );
  }
}

Widget _icon(String text, IconData icon, MaterialColor cor) {
  return Container(
    width: 90,
    height: 120,
    child: Flex(
      direction: Axis.vertical,
      children: [
        Flexible(
          flex: 2,
          child: CircleAvatar(
            maxRadius: 32,
            backgroundColor: cor.shade100,
            child: IconButton(
              icon: Icon(icon),
              color: cor.shade700,
              onPressed: () {
                Get.to(() => CreatePurchasePB(
                      category: text,
                    ));
                // WidgetsPB().createPurchase(text);
              },
            ),
          ),
        ),
        Flexible(
            child: Padding(
          padding: EdgeInsets.only(top: 2),
          child: Center(
            child: Text(
              text,
              style: TextPB.display6,
              textAlign: TextAlign.center,
            ),
          ),
        ))
      ],
    ),
  );
}

Widget _cardTotalHome() => Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 20, top: 20),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Color(corPri),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Saldo Disponível",
            style: TextStyle(fontFamily: "lato"),
          ),
          c.loading.value == false
              ? RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'R\$',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: "lato",
                            fontSize: 25),
                      ),
                      TextSpan(
                          text: c.real.format(c.getTotalAmount()),
                          style: TextStyle(fontFamily: "lato", fontSize: 26))
                    ],
                  ),
                )
              : CupertinoActivityIndicator(),
          SizedBox(height: 12),
          Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text("R\$" + c.real.format(c.getAmountLastMonth()),
                    style: TextStyle(
                        fontFamily: "lato",
                        color: Colors.deepPurple.shade800,
                        fontSize: 18)),
                SizedBox(
                  width: 12,
                ),
                Tooltip(
                  message: "Variação Mensal",
                  child: Chip(
                    padding: EdgeInsets.all(0),
                    label: Wrap(
                      children: [
                        c.variationLastMonth().isInfinite ||
                                c.variationLastMonth().isNaN
                            ? Text("")
                            : Text(c
                                    .variationLastMonth()
                                    .toStringAsFixed(0)
                                    .toString() +
                                "%"),
                        c.variationLastMonth().isNegative
                            ? Icon(
                                Icons.trending_down_rounded,
                                size: 18,
                              )
                            : Icon(
                                Icons.trending_up_rounded,
                                size: 18,
                              )
                      ],
                    ),
                  ),
                )
              ]),
          SizedBox(height: 12),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.spaceAround,
              children: [
                _iconTotalHome("Transferir", Icons.attach_money_outlined, () {
                  WidgetsPB().createTransference();
                }),
                _iconTotalHome("Arquivar", Icons.archive, () {}),
                _iconTotalHome("Histórico", Icons.history, () {}),
              ],
            ),
          )
        ],
      ),
    );

Widget _iconTotalHome(String label, IconData icon, Function func) => Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: func,
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Icon(
                icon,
                color: Color(corPri),
              ),
              Text(
                label,
                style: TextStyle(color: Colors.grey.shade800),
              )
            ],
          ),
        ),
      ),
    );

Widget _cardPromo(
  Color cor,
  String desconto,
  String label,
  String descricao,
) =>
    Container(
      margin: EdgeInsets.only(top: 15, bottom: 15, left: 10),
      height: 170,
      width: Get.width / 1.2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: cor,
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("$desconto OFF",
                    style: TextPB.h4.copyWith(color: Colors.white60)),
                Text(label, style: TextPB.h4.copyWith(color: Colors.white)),
                Text(descricao,
                    style: TextPB.display5.copyWith(color: Colors.white60)),
              ],
            ),
          ),
          Positioned(
            right: 0,
            top: 20,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.greenAccent.shade700,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      topLeft: Radius.circular(50))),
              height: 50,
              width: 110,
              child: Center(
                child: Text(
                  desconto,
                  style: TextPB.h2.copyWith(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );

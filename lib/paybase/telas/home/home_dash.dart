import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:layouts/paybase/const/buttons.dart';
import 'package:layouts/paybase/const/cards.dart';
import 'package:layouts/paybase/const/colors.dart';
import 'package:layouts/paybase/const/text.dart';
import 'package:layouts/paybase/const/widgets.dart';
import 'package:layouts/paybase/controller/controller.dart';
import 'package:layouts/paybase/telas/all_trasactions.dart';
import 'package:layouts/paybase/telas/createPurchase.dart';
import 'package:layouts/paybase/telas/historic_receive.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

final Controller c = Get.put(Controller());

class HomeDash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => c.loading.value == true
          ? WidgetsPB.loading
          : Scaffold(
              body: SafeArea(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 12),
                        Text("Dashboard", style: TextPB.h3),
                        SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          child: Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text("Seu Balanço", style: TextPB.display4.copyWith(color: Colors.grey)),
                              ButtonsPB().textButton(
                                "Histórico",
                                () {
                                  Get.to(() => HistoricReceivePB());
                                },
                              ),
                            ],
                          ),
                        ),
                        Text("R\$" + c.real.format(c.getTotalAmount()), style: TextPB.h1),
                        SizedBox(height: 12),
                        Flex(
                          direction: Axis.horizontal,
                          children: [
                            Flexible(
                              flex: 1,
                              child: ButtonsPB().iconButton1(() {
                                Get.to(() => CreatePurchasePB(
                                      category: "Recebimento",
                                    ));
                              }, "Transferir", Icons.attach_money_outlined),
                            ),
                            Flexible(
                              flex: 1,
                              child: ButtonsPB().iconButton1(() {}, "Arquivar", Ionicons.archive_outline),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          child: Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text("Estatísticas", style: TextPB.h4),
                              ButtonsPB().textButton(
                                "Ver mais",
                                () {},
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 12),
                        Container(
                          height: 250,
                          child: _Chart(),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ButtonsPB().radioSelect(() {
                                c.changeChart.value = "dia";
                                c.getListChart();
                              }, "dia", c.changeChart.value),
                              ButtonsPB().radioSelect(() {
                                c.changeChart.value = "mês";
                                c.getListChart();
                              }, "mês", c.changeChart.value),
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          child: Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text("Transações do Mês", style: TextPB.h4),
                              ButtonsPB().textButton(
                                "Ver mais",
                                () {
                                  Get.to(() => AllTransactionsPB());
                                },
                              ),
                            ],
                          ),
                        ),
                        Obx(
                          () => Column(
                            children: c.purchases.map((pData) {
                              return pData.accountId == c.aBankFav.value.id && pData.date.toDate().month == DateTime.now().month
                                  ? CardPB().card(pData)
                                  : SizedBox();
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}

class _Chart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
        primaryYAxis: NumericAxis(
          labelStyle: TextPB.display6,
          maximum: 1000,
          minimum: -1000,
          interval: 250,
        ),
        primaryXAxis: DateTimeAxis(
          labelStyle: TextPB.display6,
          interval: 1,
          minimum: c.changeChart.value != "dia" ? DateTime.now().subtract(Duration(days: 31)) : DateTime.now().subtract(Duration(days: 5)),
          maximum: DateTime.now(),
        ),
        tooltipBehavior: TooltipBehavior(
            enable: true,
            textStyle: TextPB.display6,
            borderColor: Color(corPri),
            header: "",
            color: Colors.white,
            format: 'R\$point.y',
            tooltipPosition: TooltipPosition.pointer),
        series: [
          ColumnSeries(
            borderRadius: BorderRadius.circular(4),
            color: Color(corPri),
            dataSource: c.listChart,
            xValueMapper: (ItemChart sales, _) => sales.data,
            yValueMapper: (ItemChart sales, _) => sales.valor,
            dataLabelSettings: DataLabelSettings(isVisible: true),
          )
        ]);
  }
}

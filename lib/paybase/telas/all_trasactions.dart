import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:layouts/paybase/const/buttons.dart';
import 'package:layouts/paybase/const/cards.dart';
import 'package:layouts/paybase/const/colors.dart';
import 'package:layouts/paybase/const/text.dart';
import 'package:layouts/paybase/const/widgets.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:layouts/paybase/controller/controller.dart';

final Controller c = Get.put(Controller());

class AllTransactionsPB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    c.cleanAmountAllTrans();
    RxString categoria = "Todas".obs;
    RxString periodo = "Mês Atual".obs;
    Rx<DateTime> dtInicial = DateTime(DateTime.now().year, DateTime.now().month, 1).obs;
    Rx<DateTime> dtFinal = DateTime(DateTime.now().year, DateTime.now().month + 1, 1).obs;

    return Obx(
      () => SafeArea(
        child: Scaffold(
          appBar: WidgetsPB().appBarPB("Transações", null),
          bottomNavigationBar: BottomAppBar(
            child: Container(
              height: 120,
              width: Get.width,
              color: Color(corPri),
              child: Obx(
                () => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(text: 'Entradas(+): R\$', style: TextPB.display5),
                              TextSpan(text: c.real.format(c.vEntradas.value), style: TextPB.h5),
                            ],
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(text: 'Saídas(-): R\$', style: TextPB.display5),
                              TextSpan(text: c.real.format(c.vSaidas.value), style: TextPB.h5),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(text: 'Previsto(+): R\$', style: TextPB.display5),
                              TextSpan(text: c.real.format(c.vEntradasPrev.value + c.vEntradas.value), style: TextPB.h5),
                            ],
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(text: 'Prevista(-): R\$', style: TextPB.display5),
                              TextSpan(text: c.real.format(c.vSaidasPrev.value + c.vSaidas.value), style: TextPB.h5),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Previsto: R\$" + c.real.format(c.vSaidasPrev.value + c.vSaidas.value + c.vEntradas.value + c.vEntradasPrev.value),
                          style: TextPB.h4,
                        ),
                        Text(
                          "Total: R\$" + c.real.format(c.vSaidas.value + c.vEntradas.value),
                          style: TextPB.h4,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                Flex(
                  direction: Axis.horizontal,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Color(corPri).withAlpha(120),
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(6), bottomRight: Radius.circular(6)),
                        ),
                        height: 45,
                        width: Get.width,
                        child: DropdownButton(
                            underline: SizedBox(),
                            isExpanded: true,
                            hint: Text(categoria.value),
                            items: c.category.map((value) {
                              return DropdownMenuItem<String>(value: value['name'], child: Text(value['name']));
                            }).toList()
                              ..add(DropdownMenuItem<String>(
                                value: "Todas",
                                child: Text("Todas"),
                              )),
                            onChanged: (_) {
                              c.cleanAmountAllTrans();
                              categoria.value = _;
                            }),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Color(corPri).withAlpha(120),
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(6), bottomRight: Radius.circular(6)),
                        ),
                        height: 45,
                        width: Get.width,
                        child: DropdownButton(
                            underline: SizedBox(),
                            isExpanded: true,
                            hint: Text(periodo.value),
                            items: [
                              DropdownMenuItem<String>(value: "Mês Atual", child: Text("Mês Atual")),
                              DropdownMenuItem<String>(value: "Mês Anterior", child: Text("Mês Anterior")),
                              DropdownMenuItem<String>(value: "Próximo Mês", child: Text("Próximo Mês")),
                              DropdownMenuItem<String>(value: "Últimos 90d", child: Text("Últimos 90d")),
                              DropdownMenuItem<String>(
                                  value: "Outro",
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Color(corPri).withAlpha(120),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    height: 40,
                                    width: Get.width,
                                    child: ButtonsPB().textButton("Outro", () {
                                      Get.dialog(
                                        Center(
                                          child: Container(
                                            color: Colors.black,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                SfDateRangePicker(
                                                  rangeTextStyle: TextPB.display6,
                                                  monthCellStyle: DateRangePickerMonthCellStyle(
                                                      textStyle: TextPB.display6, todayTextStyle: TextStyle(color: Color(corPri))),
                                                  yearCellStyle: DateRangePickerYearCellStyle(
                                                      todayCellDecoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(14),
                                                        color: Color(corPri),
                                                      ),
                                                      todayTextStyle: TextPB.display3,
                                                      textStyle: TextPB.display3),
                                                  headerStyle: DateRangePickerHeaderStyle(textStyle: TextPB.display3),
                                                  initialSelectedRange: PickerDateRange(dtInicial.value, dtFinal.value),
                                                  initialSelectedRanges: [PickerDateRange(dtInicial.value, dtFinal.value)],
                                                  selectionMode: DateRangePickerSelectionMode.range,
                                                  minDate: DateTime(2000, 01, 01),
                                                  maxDate: DateTime(2100, 01, 01),
                                                  extendableRangeSelectionDirection: ExtendableRangeSelectionDirection.backward,
                                                  startRangeSelectionColor: Color(corPri),
                                                  selectionColor: Color(corPri),
                                                  rangeSelectionColor: Color(corPri).withAlpha(150),
                                                  todayHighlightColor: Color(corPri),
                                                  endRangeSelectionColor: Color(corPri),
                                                  onSelectionChanged: (_) {
                                                    c.cleanAmountAllTrans();
                                                    periodo.value = "Outro";
                                                    PickerDateRange a = _.value;
                                                    dtInicial.value = a.startDate;
                                                    dtFinal.value = a.endDate;
                                                  },
                                                ),
                                                ButtonsPB().button("Selecionar", () {
                                                  Get.back();
                                                }),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                                  )),
                            ],
                            onChanged: (_) {
                              c.cleanAmountAllTrans();
                              periodo.value = _;
                              if (_ == "Mês Atual") {
                                dtInicial.value = DateTime(DateTime.now().year, DateTime.now().month, 1);
                                dtFinal.value =
                                    DateTime(DateTime.now().year, DateTime.now().month, DateTime(DateTime.now().year, DateTime.now().month, 0).day);
                              } else if (_ == "Mês Anterior") {
                                dtInicial.value = DateTime(DateTime.now().year, DateTime.now().month - 1, 1);
                                dtFinal.value = DateTime(
                                    DateTime.now().year, DateTime.now().month - 1, DateTime(DateTime.now().year, DateTime.now().month, 0).day);
                              } else if (_ == "Próximo Mês") {
                                dtInicial.value = DateTime(DateTime.now().year, DateTime.now().month + 1, 1);
                                dtFinal.value = DateTime(
                                    DateTime.now().year, DateTime.now().month + 1, DateTime(DateTime.now().year, DateTime.now().month, 0).day);
                              } else if (_ == "Últimos 90d") {
                                dtFinal.value = DateTime.now();
                                dtInicial.value = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day - 90);
                              }
                            }),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: c.purchases.map((pData) {
                      dtInicial.value == null ? dtInicial.value = dtFinal.value : dtInicial.value;
                      dtFinal.value == null ? dtFinal.value = dtInicial.value : dtFinal.value = dtFinal.value;

                      if (pData.date.toDate().isBefore(dtFinal.value) && pData.date.toDate().isAfter(dtInicial.value) ||
                          pData.date.toDate() == dtInicial.value) {
                        if (pData.accountId == c.aBankFav.value.id && categoria.value == "Todas") {
                          if (pData.pay == true && pData.amount.isNegative) {
                            c.vSaidas.value = pData.amount + c.vSaidas.value;
                          } else if (pData.pay == false && pData.amount.isNegative) {
                            c.vSaidasPrev.value = pData.amount + c.vSaidasPrev.value;
                          } else if (pData.pay == true && !pData.amount.isNegative) {
                            c.vEntradas.value = pData.amount + c.vEntradas.value;
                          } else if (pData.pay == false && !pData.amount.isNegative) {
                            c.vEntradasPrev.value = pData.amount + c.vEntradasPrev.value;
                          }
                          return CardPB().card(pData);
                        } else if (pData.accountId == c.aBankFav.value.id && categoria.value == pData.category) {
                          if (pData.pay == true && pData.amount.isNegative) {
                            c.vSaidas.value = pData.amount + c.vSaidas.value;
                          } else if (pData.pay == false && pData.amount.isNegative) {
                            c.vSaidasPrev.value = pData.amount + c.vSaidasPrev.value;
                          } else if (pData.pay == true && !pData.amount.isNegative) {
                            c.vEntradas.value = pData.amount + c.vEntradas.value;
                          } else if (pData.pay == false && !pData.amount.isNegative) {
                            c.vEntradasPrev.value = pData.amount + c.vEntradasPrev.value;
                          }
                          return CardPB().card(pData);
                        } else {
                          return SizedBox();
                        }
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

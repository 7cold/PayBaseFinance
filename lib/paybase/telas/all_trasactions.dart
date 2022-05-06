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
    RxString categoria = "Todas".obs;
    Rx<DateTime> dtInicial = DateTime(DateTime.now().year, DateTime.now().month, 1).obs;
    Rx<DateTime> dtFinal = DateTime(DateTime.now().year, DateTime.now().month + 1, 1).obs;
    RxDouble valorEntradas = 0.0.obs;
    RxDouble valorSaidas = 0.0.obs;

    return Obx(
      () => Scaffold(
        appBar: WidgetsPB().appBarPB("Transações", null),
        bottomNavigationBar: BottomAppBar(
          child: Container(
            height: 90,
            width: Get.width,
            color: Color(corPri),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Entradas: R\$" + c.real.format(valorEntradas.value)),
                Obx(() => Text("Saídas: R\$" + c.real.format(valorSaidas.value))),
              ],
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
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
                              categoria.value = _;
                            }),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(corPri).withAlpha(120),
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(6), bottomRight: Radius.circular(6)),
                        ),
                        height: 45,
                        width: Get.width,
                        child: ButtonsPB().textButton("Período", () {
                          Get.dialog(
                            Center(
                              child: Container(
                                color: Colors.black,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SfDateRangePicker(
                                      rangeTextStyle: TextPB.display6,
                                      monthCellStyle:
                                          DateRangePickerMonthCellStyle(textStyle: TextPB.display6, todayTextStyle: TextStyle(color: Color(corPri))),
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
                            valorSaidas.value = pData.amount - valorSaidas.value;
                            print(valorSaidas);
                          } else if (pData.pay == true && !pData.amount.isNegative) {
                            // valorEntradas.value = pData.amount.abs() + valorEntradas.value;
                          }
                          return CardPB().card(pData);
                        } else if (pData.accountId == c.aBankFav.value.id && categoria.value == pData.category) {
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

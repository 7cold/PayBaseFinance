import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:get/get.dart';
import 'package:layouts/paybase/const/text.dart';
import '../const/buttons.dart';
import '../const/colors.dart';
import '../const/inputs.dart';
import '../const/widgets.dart';
import '../controller/controller.dart';
import 'package:intl/intl.dart';

class CreatePurchasePB extends StatelessWidget {
  final String category;
  final bool isReceiver;

  CreatePurchasePB({this.category, this.isReceiver});

  final Controller c = Get.put(Controller());
  final Rx<MoneyMaskedTextController> amount = MoneyMaskedTextController(decimalSeparator: ',', thousandSeparator: '.').obs;
  final Rx<DateTime> dtPicked = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).obs;
  final TextEditingController name = TextEditingController();
  final TextEditingController obs = TextEditingController();
  final TextEditingController parcelas = TextEditingController(text: "1");
  final RxBool pay = false.obs;
  final RxBool parcelada = false.obs;
  final RxInt qtdParcelas = 1.obs;
  final RxString tipoParcela = "Dias".obs;

  Future<void> _selectDate() async {
    DateTime picked = await showDatePicker(
        context: Get.context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2017, 9, 7, 17, 30),
        lastDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 7));
    if (picked != null && picked != dtPicked.value) dtPicked.value = picked;
  }

  double getValorParcela() {
    double total = 0.0;
    if (parcelada.value == false) qtdParcelas.value = 1;
    total = amount.value.numberValue / qtdParcelas.value;
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final RxString categorySelect = category.obs;

    return Obx(
      () => c.loading.value == true
          ? WidgetsPB.loading
          : Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                toolbarHeight: 80,
                leading: Container(
                  child: IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(color: Color(corPri), borderRadius: BorderRadius.circular(80)),
                        child: Icon(Icons.close)),
                  ),
                ),
              ),
              body: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: ListView(
                    physics: BouncingScrollPhysics(),
                    children: [
                      InputPB.search(name, "Descrição", Icons.notes_rounded, c.suggestion),
                      SizedBox(height: 5),
                      InputPB.numbers(amount.value, "", Icons.attach_money_rounded, (_) {
                        amount.update((val) {});
                        getValorParcela();
                      }),
                      SizedBox(height: 5),
                      InputPB.disable(null, DateFormat('dd/MM/yy').format(dtPicked.value), Icons.date_range_rounded, () {
                        _selectDate();
                      }),
                      CheckboxListTile(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        title: Text(
                          isReceiver == true ? "Recebido" : "Despesa Paga",
                          style: TextPB.display5,
                        ),
                        value: pay.value,
                        onChanged: (newValue) {
                          pay.value = newValue;
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 5, bottom: 5),
                        child: Container(
                          padding: EdgeInsets.only(right: 10, left: 10),
                          width: Get.context.width,
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: DropdownButton(
                              underline: SizedBox(),
                              isExpanded: true,
                              hint: Text(categorySelect.value),
                              items: isReceiver == true
                                  ? c.receivement.map((value) {
                                      return DropdownMenuItem<String>(
                                          value: value['name'],
                                          child: Text(
                                            value['name'],
                                          ));
                                    }).toList()
                                  : c.category.map((value) {
                                      return DropdownMenuItem<String>(
                                          value: value['name'],
                                          child: Text(
                                            value['name'],
                                          ));
                                    }).toList(),
                              onChanged: (_) {
                                categorySelect.value = _;
                              }),
                        ),
                      ),
                      InputPB.field(obs, "Observação", Icons.emoji_objects_outlined),
                      SizedBox(height: 5),
                      CheckboxListTile(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        title: Text(
                          isReceiver == true ? "Receita parcelada" : "Despesa parcelada",
                          style: TextPB.display5,
                        ),
                        value: parcelada.value,
                        onChanged: (newValue) {
                          parcelada.value = newValue;
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                      parcelada.value == true
                          ? Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: Color(corPri),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Flex(
                                    direction: Axis.horizontal,
                                    children: [
                                      Flexible(
                                        flex: 2,
                                        child: parcelada.value == false
                                            ? SizedBox()
                                            : Padding(
                                                padding: const EdgeInsets.only(right: 4),
                                                child: InputPB.numbers(parcelas, "Parcelas", Icons.format_list_numbered_rounded, (_) {
                                                  if (_ == null || _ == "") {
                                                    qtdParcelas.value = 1;
                                                  } else {
                                                    qtdParcelas.value = int.parse(_);
                                                  }
                                                }),
                                              ),
                                      ),
                                      Flexible(
                                        flex: 3,
                                        child: parcelada.value == false
                                            ? SizedBox()
                                            : Padding(
                                                padding: EdgeInsets.only(
                                                  top: 5,
                                                  bottom: 5,
                                                ),
                                                child: Container(
                                                  padding: EdgeInsets.only(right: 10, left: 10),
                                                  width: Get.context.width,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[800],
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                  child: DropdownButton(
                                                      underline: SizedBox(),
                                                      isExpanded: true,
                                                      hint: Text(tipoParcela.value),
                                                      items: [
                                                        DropdownMenuItem(value: "Dias", child: Text("Dias")),
                                                        DropdownMenuItem(value: "Semanas", child: Text("Semanas")),
                                                        DropdownMenuItem(value: "Meses", child: Text("Meses")),
                                                      ],
                                                      onChanged: (_) {
                                                        tipoParcela.value = _;
                                                      }),
                                                ),
                                              ),
                                      ),
                                    ],
                                  ),
                                  parcelada.value == false
                                      ? SizedBox()
                                      : Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "Valor da parcela: R\$" + c.real.format(getValorParcela()),
                                            style: TextPB.display5,
                                          ),
                                        ),
                                ],
                              ),
                            )
                          : SizedBox(),
                      Padding(
                        padding: EdgeInsets.only(top: 40),
                        child: SizedBox(
                          width: Get.width,
                          child: ButtonsPB().button(
                              "Salvar",
                              parcelada.value == true && qtdParcelas.value == 1 || amount.value.numberValue == 0.00
                                  ? null
                                  : () {
                                      if (parcelada.value == false) {
                                        c.createPurchase({
                                          "name": name.text == "" ? categorySelect.value : name.text,
                                          "amount": isReceiver == true ? getValorParcela() : getValorParcela() * -1,
                                          "date": Timestamp.fromDate(dtPicked.value),
                                          "pay": pay.value,
                                          "accountId": c.aBankFav.value.id,
                                          "account": c.aBankFav.value.name,
                                          "category": categorySelect.value,
                                          "obs": obs.text,
                                          "file": "",
                                          "tag": [],
                                          "isParcela": 0,
                                          "id": c.getRandomString(20),
                                          "repeatId": []
                                        }).whenComplete(() {
                                          c.loading.value = false;
                                          Get.back();
                                        });
                                      } else {
                                        List repeatId = [];

                                        for (var i = 0; i < qtdParcelas.value; i++) {
                                          String id = c.getRandomString(20);
                                          repeatId.add({
                                            "parcela": i + 1,
                                            "totalParcela": qtdParcelas.value,
                                            "repeatId": id,
                                          });
                                        }

                                        for (var i = 0; i < qtdParcelas.value; i++) {
                                          if (tipoParcela.value == "Dias") {
                                            c.loading.value = true;
                                            c.createPurchase({
                                              "name": name.text == "" ? categorySelect.value : name.text,
                                              "amount": isReceiver == true ? getValorParcela() : getValorParcela() * -1,
                                              "date": Timestamp.fromDate(dtPicked.value.add(Duration(days: i))),
                                              "pay": i == 0 ? pay.value : false,
                                              "accountId": c.aBankFav.value.id,
                                              "account": c.aBankFav.value.name,
                                              "category": categorySelect.value,
                                              "obs": obs.text,
                                              "file": "",
                                              "tag": [],
                                              "id": repeatId[i]['repeatId'],
                                              "isParcela": repeatId[i]['parcela'],
                                              "repeatId": repeatId
                                            }).whenComplete(() {
                                              c.loading.value = false;
                                              Get.back();
                                            });
                                          } else if (tipoParcela.value == "Semanas") {
                                            c.loading.value = true;
                                            c.createPurchase({
                                              "name": name.text == "" ? categorySelect.value : name.text,
                                              "amount": isReceiver == true ? getValorParcela() : getValorParcela() * -1,
                                              "date": Timestamp.fromDate(
                                                dtPicked.value.add(
                                                  Duration(days: 7 * i),
                                                ),
                                              ),
                                              "pay": i == 0 ? pay.value : false,
                                              "accountId": c.aBankFav.value.id,
                                              "account": c.aBankFav.value.name,
                                              "category": categorySelect.value,
                                              "obs": obs.text,
                                              "file": "",
                                              "tag": [],
                                              "id": repeatId[i]['repeatId'],
                                              "isParcela": repeatId[i]['parcela'],
                                              "repeatId": repeatId
                                            }).whenComplete(() {
                                              c.loading.value = false;
                                              Get.back();
                                            });
                                            print(
                                              dtPicked.value.add(Duration(days: 7 * i)),
                                            );
                                          } else {
                                            c.loading.value = true;
                                            c.createPurchase({
                                              "name": name.text == "" ? categorySelect.value : name.text,
                                              "amount": isReceiver == true ? getValorParcela() : getValorParcela() * -1,
                                              "date": Timestamp.fromDate(DateTime(dtPicked.value.year, dtPicked.value.month + i, dtPicked.value.day)),
                                              "pay": i == 0 ? pay.value : false,
                                              "accountId": c.aBankFav.value.id,
                                              "account": c.aBankFav.value.name,
                                              "category": categorySelect.value,
                                              "obs": obs.text,
                                              "file": "",
                                              "tag": [],
                                              "id": repeatId[i]['repeatId'],
                                              "isParcela": repeatId[i]['parcela'],
                                              "repeatId": repeatId
                                            }).whenComplete(() {
                                              c.loading.value = false;
                                              Get.back();
                                            });
                                          }
                                        }
                                      }
                                    }),
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

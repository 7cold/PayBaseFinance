import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:ionicons/ionicons.dart';
import 'package:layouts/paybase/const/buttons.dart';
import 'package:layouts/paybase/const/inputs.dart';
import 'package:layouts/paybase/const/text.dart';
import 'package:get/get.dart';
import 'package:layouts/paybase/controller/controller.dart';
import 'package:intl/intl.dart';
import 'package:layouts/paybase/data/purchases_data.dart';

final Controller c = Get.put(Controller());

class WidgetsPB {
  static final loading = Scaffold(
    body: Center(
      child: CupertinoActivityIndicator(),
    ),
  );

  AppBar appBarPB(String title, Function func) => AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          title,
          style: TextPB.display4,
        ),
        actions: func == null
            ? []
            : [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: IconButton(
                    onPressed: func,
                    icon: Icon(Ionicons.add),
                  ),
                ),
              ],
      );

  Future createTransference() {
    final TextEditingController name = TextEditingController();
    final TextEditingController obs = TextEditingController();
    final _formatterReal = MoneyMaskedTextController(decimalSeparator: ',', thousandSeparator: '.');
    Rx<DateTime> dtPicked = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).obs;
    RxBool pay = false.obs;

    Future<void> _selectDate() async {
      DateTime picked = await showDatePicker(
          context: Get.context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2017, 9, 7, 17, 30),
          lastDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 7));
      if (picked != null && picked != dtPicked.value) dtPicked.value = picked;
    }

    return Get.defaultDialog(
      confirm: Padding(
        padding: EdgeInsets.all(8.0),
        child: ButtonsPB().button("Salvar", () {
          c.createPurchase({
            "id": "",
            "name": name.text,
            "amount": _formatterReal.numberValue,
            "date": Timestamp.fromDate(dtPicked.value),
            "pay": pay.value,
            "accountId": c.aBankFav.value.id,
            "account": c.aBankFav.value.name,
            "category": "transference",
            "obs": obs.text,
            "file": "",
            "tag": [],
          });
          c.getTotalAmount();
          Get.back();
        }),
      ),
      title: "Novo Recebimento",
      content: Obx(
        () => Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              InputPB.search(name, "Descrição", Icons.notes_rounded, c.suggestion),
              SizedBox(height: 5),
              InputPB.numbers(_formatterReal, "Valor", Icons.attach_money_rounded, null),
              SizedBox(height: 5),
              InputPB.disable(null, DateFormat('dd/MM/yy').format(dtPicked.value), Icons.date_range_rounded, () {
                _selectDate();
              }),
              CheckboxListTile(
                title: Text(
                  "Recebido",
                  style: TextPB.display5,
                ),
                value: pay.value,
                onChanged: (newValue) {
                  pay.value = newValue;
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
              InputPB.field(obs, "Observação", Icons.emoji_objects_outlined),
            ],
          ),
        ),
      ),
    ).whenComplete(() {
      name.clear();
      obs.clear();
      _formatterReal.updateValue(0);
      dtPicked = DateTime.now().obs;
      pay.value = false;
    });
  }

  Future createPurchase(String text) {
    Rx<MoneyMaskedTextController> _formatterReal = MoneyMaskedTextController(decimalSeparator: ',', thousandSeparator: '.').obs;
    Rx<DateTime> dtPicked = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).obs;
    final name = TextEditingController();
    final obs = TextEditingController();
    final parcelas = TextEditingController();

    RxBool pay = false.obs;
    RxBool parcelada = false.obs;
    RxString categorySelect = text.obs;

    Future<void> _selectDate() async {
      DateTime picked = await showDatePicker(
          context: Get.context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2017, 9, 7, 17, 30),
          lastDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 7));
      if (picked != null && picked != dtPicked.value) dtPicked.value = picked;
    }

    return Get.defaultDialog(
      confirm: Padding(
        padding: EdgeInsets.all(8.0),
        child: ButtonsPB().button("Salvar", () {
          c.createPurchase({
            "name": name.text == "" ? categorySelect.value : name.text,
            "amount": -_formatterReal.value.numberValue,
            "date": Timestamp.fromDate(dtPicked.value),
            "pay": pay.value,
            "accountId": c.aBankFav.value.id,
            "account": c.aBankFav.value.name,
            "category": categorySelect.value,
            "obs": obs.text,
            "file": "",
            "tag": [],
          });
          Get.back();
        }),
      ),
      title: "Nova Despesa",
      content: Obx(
        () => Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              InputPB.search(name, "Descrição", Icons.notes_rounded, c.suggestion),
              SizedBox(height: 5),
              InputPB.numbers(_formatterReal.value, "Valor", Icons.attach_money_rounded, null),
              SizedBox(height: 5),
              InputPB.disable(null, DateFormat('dd/MM/yy').format(dtPicked.value), Icons.date_range_rounded, () {
                _selectDate();
              }),
              CheckboxListTile(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                title: Text(
                  "Despesa Paga",
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
                    color: Colors.grey[700],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButton(
                      underline: SizedBox(),
                      isExpanded: true,
                      hint: Text(categorySelect.value),
                      items: c.category.map((value) {
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
              Flex(
                direction: Axis.horizontal,
                children: [
                  Flexible(
                    flex: 2,
                    child: CheckboxListTile(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      title: Text(
                        "Despesa parcelada",
                        style: TextPB.display5,
                      ),
                      value: parcelada.value,
                      onChanged: (newValue) {
                        parcelada.value = newValue;
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: parcelada.value == false ? SizedBox() : InputPB.numbers(parcelas, "Parcelas", Icons.format_list_numbered_rounded, null),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ).whenComplete(() {
      name.clear();
      parcelas.clear();
      obs.clear();
      _formatterReal.value.updateValue(0);
      dtPicked = DateTime.now().obs;
      pay.value = false;
      categorySelect = text.obs;
    });
  }

  Future editPurchase(PurchaseData pData) {
    final name = TextEditingController(text: pData.name);
    final obs = TextEditingController(text: pData.obs);
    final _formatterReal = MoneyMaskedTextController(decimalSeparator: ',', thousandSeparator: '.', initialValue: pData.amount.toDouble());
    Rx<DateTime> dtPicked = pData.date.toDate().obs;
    RxBool pay = pData.pay.obs;
    RxString categorySelect = pData.category.obs;

    Future<void> _selectDate() async {
      DateTime picked = await showDatePicker(
          context: Get.context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2017, 9, 7, 17, 30),
          lastDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 7));
      if (picked != null && picked != dtPicked.value) dtPicked.value = picked;
    }

    return Get.defaultDialog(
      confirm: Padding(
        padding: EdgeInsets.all(8.0),
        child: ButtonsPB().button("Salvar", () {
          pData.name = name.text;
          pData.amount = -_formatterReal.numberValue;
          pData.date = Timestamp.fromDate(dtPicked.value);
          pData.pay = pay.value;
          pData.category = categorySelect.value;
          pData.obs = obs.text;
          c.updatePurchase(pData);

          Get.back();
          Get.back();
        }),
      ),
      title: "Editar",
      content: Obx(
        () => Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              InputPB.search(name, "Descrição", Icons.notes_rounded, c.suggestion),
              SizedBox(height: 5),
              InputPB.numbers(_formatterReal, "Valor", Icons.attach_money_rounded, null),
              SizedBox(height: 5),
              InputPB.disable(null, DateFormat('dd/MM/yy').format(dtPicked.value), Icons.date_range_rounded, () {
                _selectDate();
              }),
              CheckboxListTile(
                title: Text(
                  "Despesa Paga",
                  style: TextPB.display5,
                ),
                value: pay.value,
                onChanged: (newValue) {
                  pay.value = newValue;
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
              Obx(
                () => Padding(
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  child: Container(
                    padding: EdgeInsets.only(right: 10, left: 10),
                    width: Get.context.width,
                    decoration: BoxDecoration(
                      color: Colors.grey[700],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButton(
                        underline: SizedBox(),
                        isExpanded: true,
                        hint: Text(categorySelect.value),
                        items: c.category.map((value) {
                          return DropdownMenuItem<String>(value: value['name'], child: Text(value['name']));
                        }).toList(),
                        onChanged: (_) {
                          categorySelect.value = _;
                        }),
                  ),
                ),
              ),
              InputPB.field(obs, "Observação", Icons.emoji_objects_outlined),
            ],
          ),
        ),
      ),
    ).whenComplete(() {
      name.clear();
      obs.clear();
      _formatterReal.updateValue(0);
      dtPicked = DateTime.now().obs;
      pay.value = false;
      // categorySelect = text.obs;
    });
  }

  MaterialColor getColor(String category) {
    switch (category) {
      case "Alimentação":
        return Colors.red;
        break;
      case "Assinatura e Serviços":
        return Colors.pink;
        break;
      case "Bares e Restaurantes":
        return Colors.purple;
        break;
      case "Casa":
        return Colors.deepPurple;
        break;
      case "Compras":
        return Colors.indigo;
        break;
      case "Cuidados Pessoais":
        return Colors.blue;
        break;
      case "Dívidas e Emprestimos":
        return Colors.lightBlue;
        break;
      case "Educação":
        return Colors.cyan;
        break;
      case "Impostos e Taxas":
        return Colors.teal;
        break;
      case "Lazer e Hobbie":
        return Colors.green;
        break;
      case "Mercado":
        return Colors.lightGreen;
        break;
      case "Outros":
        return Colors.grey;
        break;
      case "Pets":
        return Colors.yellow;
        break;
      case "Presentes e Doações":
        return Colors.amber;
        break;
      case "Roupas":
        return Colors.orange;
        break;
      case "Saúde":
        return Colors.deepOrange;
        break;
      case "Serviços Gerais":
        return Colors.orange;
        break;
      case "Trabalho":
        return Colors.blue;
        break;
      case "Transporte":
        return Colors.lightBlue;
        break;
      case "Viagem":
        return Colors.lime;
        break;
      case "transference":
        return Colors.green;
        break;
      case "Recebimento":
        return Colors.green;
        break;
      case "Salários":
        return Colors.green;
        break;
      case "Investimentos":
        return Colors.green;
        break;
      case "Outros":
        return Colors.green;
        break;
      case "Depósitos":
        return Colors.green;
        break;

      default:
        return Colors.green;
    }
  }

  ItemChart barItem(DateTime value) {
    double soma = 0;
    c.maxChartVal.value = 0.0;

    for (PurchaseData i in c.purchases) {
      c.maxChartVal.value = i.amount + c.maxChartVal.value;
      if (i.date.toDate() == DateTime(value.year, value.month, value.day) && i.accountId == c.aBankFav.value.id && i.pay == true) {
        soma = soma + i.amount;
      }
    }

    return ItemChart(soma, value);
  }
}

class ItemChart {
  ItemChart(
    this.valor,
    this.data,
  );

  final double valor;
  final DateTime data;
}

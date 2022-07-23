import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:layouts/paybase/const/buttons.dart';
import 'package:layouts/paybase/const/inputs.dart';
import 'package:layouts/paybase/data/accountBank_data.dart';
import 'package:layouts/paybase/data/purchases_data.dart';
import 'package:layouts/paybase/data/user_data.dart';
import 'package:layouts/paybase/telas/home/home.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:intl/intl.dart';
import 'package:layouts/paybase/telas/login.dart';
import '../const/widgets.dart';

class Controller extends GetxController {
  @override
  onInit() async {
    await _loadUser();

    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  NumberFormat real = new NumberFormat("#,##0.00", "pt_BR");
  RxMap userData = {}.obs;
  Rx<FirebaseAuth> _auth = FirebaseAuth.instance.obs;
  Rx<AccountsBank> aBankFav = Rxn<AccountsBank>();
  Rx<User> firebaseUser = Rxn<User>();
  RxList<PurchaseData> purchases = <PurchaseData>[].obs;
  RxList<String> suggestion = <String>[].obs;
  RxList<ItemChart> listChart = <ItemChart>[].obs;
  RxString forgot = "email".obs;
  RxString changeChart = "dia".obs;
  RxBool loading = false.obs;
  RxBool therms = false.obs;
  RxDouble maxChartVal = 0.0.obs;
  String _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();
  RxDouble vEntradas = 0.0.obs;
  RxDouble vSaidas = 0.0.obs;
  RxDouble vEntradasPrev = 0.0.obs;
  RxDouble vSaidasPrev = 0.0.obs;
  RxDouble vTotal = 0.0.obs;
  RxDouble vTotalPrev = 0.0.obs;

  String createId() {
    return DateTime.now().year.toString() +
        DateTime.now().month.toString() +
        DateTime.now().day.toString() +
        DateTime.now().hour.toString() +
        DateTime.now().minute.toString() +
        DateTime.now().second.toString() +
        DateTime.now().microsecond.toString();
  }

  num getTotalAmount() {
    num totalAccount = aBankFav.value.amount;

    purchases.forEach((x) {
      if (x.accountId == aBankFav.value.id && x.pay == true) {
        totalAccount = totalAccount + x.amount;
      }
    });

    return totalAccount;
  }

  num getAmountLastMonth() {
    var date = new DateTime.now();
    var lastMonth = DateTime(date.year, date.month - 1);
    num totalAccount = 0;

    purchases.forEach((x) {
      if (x.accountId == aBankFav.value.id && x.pay == true && x.date.toDate().month == lastMonth.month) {
        totalAccount = totalAccount + x.amount;
      }
    });

    return totalAccount;
  }

  num getAmountThisMonth() {
    var date = new DateTime.now();
    var lastMonth = DateTime(date.year, date.month);
    num totalAccount = 0;

    purchases.forEach((x) {
      if (x.accountId == aBankFav.value.id && x.pay == true && x.date.toDate().month == lastMonth.month) {
        totalAccount = totalAccount + x.amount;
      }
    });

    return totalAccount;
  }

  num variationLastMonth() {
    var x = ((getAmountThisMonth().abs() / getAmountLastMonth().abs()) - 1) * 100;
    return x;
  }

  getListChart() {
    int daysInMonth =
        DateTimeRange(start: DateTime(DateTime.now().year, DateTime.now().month), end: DateTime(DateTime.now().year, DateTime.now().month + 1))
            .duration
            .inDays;

    listChart.clear();
    if (changeChart.value == "dia") {
      for (int i = 0; i <= 5; i++) {
        listChart.add(WidgetsPB().barItem(DateTime.now().subtract(Duration(days: i))));
      }
    }
    if (changeChart.value == "mês") {
      for (int i = 0; i <= daysInMonth; i++) {
        listChart.add(WidgetsPB().barItem(DateTime.now().subtract(Duration(days: i))));
      }
    }
  }

  _createSuggestion() {
    purchases.forEach((element) {
      suggestion.add(element.name);
    });

    suggestion.value = suggestion.toSet().toList();
  }

  changeForgot(String status) {
    forgot.value = status;
  }

  changeFav(AccountsBank accountsBank) {
    loading.value = true;
    aBankFav.value = accountsBank;
    userData['accountsBank'].forEach((x) {
      AccountsBank ab = AccountsBank.fromJson(x);
      x['favorite'] = false;
      ab.id == accountsBank.id ? x['favorite'] = true : x['favorite'] = false;
    });
    FirebaseFirestore.instance.collection("users").doc(firebaseUser.value.uid).update({"accountsBank": userData['accountsBank']});
    getTotalAmount();
    getListChart();
    loading.value = false;
  }

  changePay(PurchaseData pData) {
    loading.value = true;

    FirebaseFirestore.instance.collection("users").doc(firebaseUser.value.uid).collection("purchases").doc(pData.id).update({"pay": !pData.pay});

    int index = purchases.indexOf(pData);
    purchases[index].pay = !pData.pay;

    purchases.refresh();
    getListChart();
    cleanAmountAllTrans();

    loading.value = false;
  }

  createAccountBank(Map add) {
    loading.value = true;
    var list = userData['accountsBank'] as List;
    list.add(add);
    FirebaseFirestore.instance.collection("users").doc(firebaseUser.value.uid).update({"accountsBank": userData['accountsBank']});
    loading.value = false;
  }

  deleteAccountBank(AccountsBank accountsBank) async {
    loading.value = true;

    userData['accountsBank'].removeWhere((element) => element["id"] == accountsBank.id);

    userData.refresh();

    FirebaseFirestore.instance.collection("users").doc(firebaseUser.value.uid).update({"accountsBank": userData['accountsBank']});

    QuerySnapshot query = await FirebaseFirestore.instance.collection("users").doc(firebaseUser.value.uid).collection("purchases").get();

    for (DocumentSnapshot doc in query.docs) {
      PurchaseData pd = PurchaseData.fromJson(doc.data());
      if (pd.accountId == accountsBank.id) {
        doc.reference.delete();
      } else {}
    }
    loading.value = false;
  }

  updateAccountBank(AccountsBank accountsBank, double value) {
    loading.value = true;

    userData['accountsBank'].forEach((element) {
      if (element['id'] == accountsBank.id) {
        element['amount'] = value;
        userData.refresh();
        if (aBankFav.value.id == accountsBank.id) {
          AccountsBank ab2 = AccountsBank.fromJson(element);
          aBankFav.value = ab2;
          getTotalAmount();
        }
      }
    });

    FirebaseFirestore.instance.collection("users").doc(firebaseUser.value.uid).update({"accountsBank": userData['accountsBank']});

    loading.value = false;
  }

  getPurchases() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser.value.uid)
        .collection('purchases')
        .orderBy('date', descending: true)
        .get();

    final allData = querySnapshot.docs.map((doc) {
      PurchaseData purchaseData = PurchaseData.fromJson(doc.data());

      return purchaseData;
    }).toList();
    purchases.value = allData;
  }

  Future<dynamic> createPurchase(Map<String, dynamic> purchase) async {
    // print(DateTime.fromMillisecondsSinceEpoch(purchase['date'].seconds * 1000));

    // DocumentReference ref = await FirebaseFirestore.instance
    //     .collection("users")
    //     .doc(firebaseUser.value.uid)
    //     .collection("purchases")
    //     .add(purchase);
    // ref.update({
    //   "id": ref.id,
    // });

    await FirebaseFirestore.instance.collection("users").doc(firebaseUser.value.uid).collection("purchases").doc(purchase['id']).set(purchase);

    _createSuggestion();

    PurchaseData purchaseData = PurchaseData.fromJson(purchase);
    purchases.add(purchaseData);
    purchases.sort(((a, b) => b.date.compareTo(a.date)));
    getListChart();
  }

  Future<dynamic> deletePurchase(PurchaseData pData) async {
    FirebaseFirestore.instance.collection("users").doc(firebaseUser.value.uid).collection("purchases").doc(pData.id).delete();

    purchases.removeWhere((element) => element.id == pData.id);
    // purchases.remove(pData);

    purchases.sort(((a, b) => b.date.compareTo(a.date)));
    getListChart();
  }

  updatePurchase(PurchaseData pData) {
    loading.value = true;
    FirebaseFirestore.instance.collection("users").doc(firebaseUser.value.uid).collection("purchases").doc(pData.id).update({
      "name": pData.name,
      "amount": pData.amount,
      "date": pData.date,
      "pay": pData.pay,
      "category": pData.category,
      "obs": pData.obs,
    });
    suggestion.clear();
    _createSuggestion();
    getListChart();

    int index = purchases.indexOf(pData);
    purchases[index] = pData;

    purchases.sort((a, b) => b.date.compareTo(a.date));

    purchases.refresh();
    vEntradas.value = 0.0;
    vSaidas.value = 0.0;

    loading.value = false;
  }

  checkOneAccess() {
    if (userData.isNotEmpty && aBankFav.value.name == "primeiro acesso") {
      final _formatterReal = MoneyMaskedTextController(decimalSeparator: ',', thousandSeparator: '.');
      TextEditingController _name = TextEditingController();

      Get.defaultDialog(
        barrierDismissible: false,
        title: "Primeiro Acesso",
        confirm: ButtonsPB().button("Salvar", () {
          createAccountBank({
            "amount": _formatterReal.text == "" ? 0 : _formatterReal.numberValue,
            "name": _name.text == "" ? "Nova Conta" : _name.text,
            "id": int.parse(createId()),
            "favorite": true
          });

          AccountsBank accountsBank = AccountsBank();
          accountsBank.amount = _formatterReal.text == "" ? 0.0 : _formatterReal.numberValue;
          accountsBank.name = _name.text == "" ? "Nova Conta" : _name.text;
          accountsBank.id = int.parse(createId());
          accountsBank.favorite = true;
          aBankFav.value = accountsBank;

          Get.back();
        }),
        content: Column(
          children: [
            InputPB.field(_name, "Nome da Conta", Icons.account_balance),
            SizedBox(
              height: 8,
            ),
            InputPB.numbers(_formatterReal, "Saldo", Icons.monetization_on_outlined, null),
          ],
        ),
      );
    }
  }

  signup({
    Map<String, dynamic> userData,
    String email,
    String pass,
    VoidCallback onSuccess,
    VoidCallback onFail,
  }) async {
    loading.value = true;
    try {
      final UserCredential result = await _auth.value.createUserWithEmailAndPassword(email: userData['email'], password: pass);

      await FirebaseFirestore.instance.collection("users").doc(result.user.uid).set(userData);

      loading.value = false;
      onSuccess();
    } catch (e) {
      loading.value = false;
      onFail();
    }
  }

  logout() async {
    loading.value = true;
    await _auth.value.signOut();
    userData.value = Map();
    firebaseUser.value = null;
    loading.value = false;

    Get.offAll(() => LoginPB());
  }

  void login({
    @required String email,
    @required String pass,
  }) async {
    loading.value = true;

    _auth.value.signInWithEmailAndPassword(email: email, password: pass).then((result) async {
      firebaseUser.value = result.user;
      await _loadUser();

      Get.offAll(() => HomePB());
    }).catchError((e) {
      loading.value = false;
      Get.snackbar("Email ou Senha Incorretos 😕", "Verifique seus dados e tente novamente!",
          backgroundColor: CupertinoColors.systemRed, borderRadius: 10, margin: EdgeInsets.all(20), colorText: Colors.white);
    });
  }

  cleanAmountAllTrans() {
    vEntradas.value = 0.0;
    vSaidas.value = 0.0;
    vEntradasPrev.value = 0.0;
    vSaidasPrev.value = 0.0;
    vTotal.value = 0.0;
    vTotalPrev.value = 0.0;
  }

  RxBool verifLogado() {
    if (firebaseUser.value == null || userData['name'] == null) {
      return false.obs;
    } else {
      return true.obs;
    }
  }

  Future<Null> _loadUser() async {
    loading.value = true;
    if (firebaseUser.value == null) firebaseUser.value = _auth.value.currentUser;
    if (firebaseUser.value != null) {
      if (userData['name'] == null) {
        DocumentSnapshot docUser = await FirebaseFirestore.instance.collection('users').doc(firebaseUser.value.uid).get();
        userData.value = docUser.data();
        UserData user = UserData.fromMap(userData);
        if (user.aBank.isEmpty) {
          AccountsBank accountsBank = AccountsBank();
          accountsBank.amount = 0.0;
          accountsBank.favorite = true;
          accountsBank.id = 1;
          accountsBank.name = "primeiro acesso";
          aBankFav.value = accountsBank;
        } else {
          user.aBank.forEach((element) {
            if (element['favorite'] == true) {
              AccountsBank fav = AccountsBank.fromJson(element);
              aBankFav.value = fav;
            }
          });
        }
        await getPurchases();
        await _createSuggestion();
        await checkOneAccess();
        await getListChart();
        loading.value = false;
      }
    }
    loading.value = false;
  }

  RxList<Map<dynamic, dynamic>> category = [
    {
      "name": "Alimentação",
      "icon": Icons.fastfood_rounded,
      "color": Colors.red,
    },
    {
      "name": "Assinatura e Serviços",
      "icon": Icons.video_label_rounded,
      "color": Colors.pink,
    },
    {
      "name": "Bares e Restaurantes",
      "icon": Icons.liquor_rounded,
      "color": Colors.purple,
    },
    {
      "name": "Casa",
      "icon": Icons.maps_home_work_rounded,
      "color": Colors.deepPurple,
    },
    {
      "name": "Compras",
      "icon": Icons.shopping_bag_rounded,
      "color": Colors.indigo,
    },
    {
      "name": "Cuidados Pessoais",
      "icon": Icons.bathtub_rounded,
      "color": Colors.blue,
    },
    {
      "name": "Dívidas e Emprestimos",
      "icon": Icons.paid_rounded,
      "color": Colors.lightBlue,
    },
    {
      "name": "Educação",
      "icon": Icons.school_rounded,
      "color": Colors.cyan,
    },
    {
      "name": "Impostos e Taxas",
      "icon": Icons.fact_check_rounded,
      "color": Colors.teal,
    },
    {
      "name": "Lazer e Hobbie",
      "icon": Icons.sports_handball_rounded,
      "color": Colors.green,
    },
    {
      "name": "Mercado",
      "icon": Icons.store_rounded,
      "color": Colors.lightGreen,
    },
    {
      "name": "Outros",
      "icon": Icons.format_list_bulleted_rounded,
      "color": Colors.grey,
    },
    {
      "name": "Pets",
      "icon": Icons.pets_rounded,
      "color": Colors.yellow,
    },
    {
      "name": "Presentes e Doações",
      "icon": Icons.redeem_rounded,
      "color": Colors.amber,
    },
    {
      "name": "Roupas",
      "icon": Icons.checkroom_rounded,
      "color": Colors.orange,
    },
    {
      "name": "Saúde",
      "icon": Icons.local_hospital_rounded,
      "color": Colors.deepOrange,
    },
    {
      "name": "Serviços Gerais",
      "icon": Icons.engineering_rounded,
      "color": Colors.orange,
    },
    {
      "name": "Trabalho",
      "icon": Icons.work_outline_rounded,
      "color": Colors.blue,
    },
    {
      "name": "Transporte",
      "icon": Icons.directions_car_rounded,
      "color": Colors.lightBlue,
    },
    {
      "name": "Viagem",
      "icon": Icons.airplanemode_active_rounded,
      "color": Colors.lime,
    }
  ].obs;

  RxList<Map<dynamic, dynamic>> receivement = [
    {
      "name": "Salários",
      "icon": Icons.monetization_on_outlined,
      "color": Colors.green,
    },
    {
      "name": "Investimentos",
      "icon": Icons.bar_chart_rounded,
      "color": Colors.green,
    },
    {
      "name": "Depósitos",
      "icon": Icons.money,
      "color": Colors.green,
    },
    {
      "name": "Outros",
      "icon": Icons.pie_chart_outline_sharp,
      "color": Colors.green,
    },
  ].obs;

  RxBool isDark() {
    return SchedulerBinding.instance.window.platformBrightness == Brightness.dark ? true.obs : false.obs;
  }

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
}

import 'package:cloud_firestore/cloud_firestore.dart';

class PurchaseData {
  String id;
  String name;
  num amount;
  Timestamp date;
  bool pay;
  int accountId;
  String account;
  String category;
  String obs;
  String file;
  num isParcela;
  List tag;
  List repeatId;

  PurchaseData(
      {this.id,
      this.name,
      this.amount,
      this.date,
      this.pay,
      this.accountId,
      this.account,
      this.category,
      this.obs,
      this.file,
      this.isParcela,
      this.tag,
      this.repeatId});

  PurchaseData.fromMap(Map<dynamic, dynamic> map) {
    id = this.id;
    name = this.name;
    amount = this.amount;
    date = this.date;
    pay = this.pay;
    accountId = this.accountId;
    account = this.account;
    category = this.category;
    obs = this.obs;
    file = this.file;
    isParcela = this.isParcela;
    tag = this.tag;
    repeatId = this.repeatId;
  }

  PurchaseData.fromJson(Map<dynamic, dynamic> json) {
    id = json["id"];
    name = json["name"];
    amount = json["amount"];
    date = json["date"];
    pay = json["pay"];
    accountId = json["accountId"];
    account = json["account"];
    category = json["category"];
    obs = json["obs"];
    file = json["file"];
    isParcela = json["isParcela"];
    tag = json["tag"];
    repeatId = json["repeatId"];
  }
}

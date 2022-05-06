class AccountsBank {
  String name;
  num amount;
  int id;
  bool favorite;

  AccountsBank({this.id, this.name, this.amount, this.favorite});

  AccountsBank.fromMap(Map<dynamic, dynamic> map) {
    id = this.id;
    name = this.name;
    amount = this.amount;
    favorite = this.favorite;
  }

  AccountsBank.fromJson(Map<dynamic, dynamic> json) {
    id = json["id"];
    name = json["name"];
    amount = json["amount"];
    favorite = json["favorite"];
  }
}

class UserData {
  String id;
  String name;
  String phone;
  String email;
  List aBank;

  UserData({
    this.id,
    this.name,
    this.phone,
    this.email,
    this.aBank,
  });

  UserData.fromMap(Map<dynamic, dynamic> map) {
    name = map["name"];
    phone = map["phone"];
    email = map["email"];
    aBank = map["accountsBank"];
  }
}

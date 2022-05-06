class SuggestionData {
  String name;
  String category;

  SuggestionData({
    this.name,
    this.category,
  });

  SuggestionData.fromMap(Map<dynamic, dynamic> map) {
    name = this.name;
    category = this.category;
  }

  SuggestionData.fromJson(Map<dynamic, dynamic> json) {
    name = json['name'];
    category = json['category'];
  }
}

class Category {
  final String? id;
  final String? title;

  Category({this.id, this.title});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(id: json['id']?.toString(), title: json['title']);
  }
}

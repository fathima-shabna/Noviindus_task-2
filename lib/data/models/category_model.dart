class Category {
  final String? id;
  final String? title;

  Category({this.id, this.title});

  factory Category.fromJson(Map<String, dynamic> json) {
    String? imageUrl = json['image'];
    if (imageUrl != null && imageUrl.startsWith('/')) {
      imageUrl = 'https://frijo.noviindus.in$imageUrl';
    }
    return Category(id: json['id']?.toString(), title: json['title']);
  }
}

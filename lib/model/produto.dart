class Produto {
  final int id;
  final String title;
  final String description;
  final num price;

  Produto({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
  });

  factory Produto.fromJson(Map<String, dynamic> json) {
    return Produto(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: json['price'],
    );
  }
}

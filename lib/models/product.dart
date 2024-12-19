class Product {
  final int? id;
  final String? documentId;
  final String name;
  final String description;
  final double price;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? publishedAt;

  Product({
    this.id,
    this.documentId,
    required this.name,
    required this.description,
    required this.price,
    this.createdAt,
    this.updatedAt,
    this.publishedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    if (json['attributes'] != null) {
      final attributes = json['attributes'];
      return Product(
        id: json['id'],
        documentId: attributes['documentId'],
        name: attributes['name'],
        description: attributes['description'],
        price: double.parse(attributes['price'].toString()),
        createdAt: DateTime.parse(attributes['createdAt']),
        updatedAt: DateTime.parse(attributes['updatedAt']),
        publishedAt: DateTime.parse(attributes['publishedAt']),
      );
    }

    return Product(
      id: int.parse(json['id'].toString()),
      documentId: json['documentId'],
      name: json['name'],
      description: json['description'],
      price: double.parse(json['price'].toString()),
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      publishedAt: json['publishedAt'] != null
          ? DateTime.parse(json['publishedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'price': price,
    };
  }
}

class Item {
  final int id;
  final String name;
  final String? description;
  final int boxId;
  final int? categoryId;
  final int quantity;
  final DateTime createdAt;
  final DateTime updatedAt;

  Item({
    required this.id,
    required this.name,
    this.description,
    required this.boxId,
    this.categoryId,
    required this.quantity,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      boxId: json['box_id'],
      categoryId: json['category_id'],
      quantity: json['quantity'] ?? 0,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'box_id': boxId,
      'category_id': categoryId,
      'quantity': quantity,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

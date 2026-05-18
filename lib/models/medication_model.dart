class Medication {
  final String? id;
  final String name;
  final String dosage;
  final double price;
  final int stock;
  final String? description;

  Medication({
    this.id,
    required this.name,
    required this.dosage,
    required this.price,
    required this.stock,
    this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'dosage': dosage,
      'price': price,
      'stock': stock,
      'description': description,
    };
  }

  factory Medication.fromJson(Map<String, dynamic> json) {
    return Medication(
      id: json['id'],
      name: json['name'] ?? '',
      dosage: json['dosage'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      stock: json['stock'] ?? 0,
      description: json['description'],
    );
  }
}

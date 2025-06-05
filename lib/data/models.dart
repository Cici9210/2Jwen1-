// 商品模型
class Product {
  final String name;
  final String location;
  final String description;

  Product({
    required this.name,
    required this.location,
    required this.description,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'] as String,
      location: json['location'] as String,
      description: json['description'] as String,
    );
  }
}

// 區域模型
class Area {
  final String code;
  final String name;
  final String description;
  final List<Product> products;

  Area({
    required this.code,
    required this.name,
    required this.description,
    required this.products,
  });

  factory Area.fromJson(Map<String, dynamic> json) {
    return Area(
      code: json['code'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      products: (json['products'] as List)
          .map((p) => Product.fromJson(p as Map<String, dynamic>))
          .toList(),
    );
  }
}

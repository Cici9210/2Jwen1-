// 商品模型
class Product {
  final String name;
  final double price;

  Product({
    required this.name,
    required this.price,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
    );
  }
}

// 區域模型
class Area {
  final String category;
  final List<Product> products;

  Area({
    required this.category,
    required this.products,
  });

  factory Area.fromJson(Map<String, dynamic> json) {
    return Area(
      category: json['category'] as String,
      products: (json['products'] as List)
          .map((p) => Product.fromJson(p as Map<String, dynamic>))
          .toList(),
    );
  }
}

class DishVariant {
  final String title;
  final int price;

  const DishVariant({required this.title, required this.price});

  factory DishVariant.fromJson(Map<String, dynamic> json) =>
      DishVariant(title: json['title'] ?? json['weight'] ?? '', price: json['price']);
}

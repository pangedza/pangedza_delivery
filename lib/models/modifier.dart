class Modifier {
  final String name;
  final int price;
  final String? groupName;

  const Modifier({required this.name, required this.price, this.groupName});

  factory Modifier.fromJson(Map<String, dynamic> json) => Modifier(
        name: json['name'] as String? ?? '',
        price: (json['price'] as num?)?.toInt() ?? 0,
        groupName: json['group_name'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'name': name,
        'price': price,
        'group_name': groupName,
      };
}

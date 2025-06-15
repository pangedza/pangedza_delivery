class MenuItem {
  final String name;
  final String description;
  final int price;
  final String photoUrl;
  bool available;

  MenuItem({
    required this.name,
    required this.description,
    required this.price,
    required this.photoUrl,
    this.available = true,
  });
}

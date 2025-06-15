class AppUser {
  final String id;
  final String name;
  final String phone;
  bool blocked;

  AppUser({
    required this.id,
    required this.name,
    required this.phone,
    this.blocked = false,
  });
}

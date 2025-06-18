class AboutInfo {
  final String phone;
  final String address;
  final List<String> workHours;

  AboutInfo({
    required this.phone,
    required this.address,
    required this.workHours,
  });

  factory AboutInfo.fromMap(Map<String, dynamic> map) => AboutInfo(
        phone: map['phone'] as String? ?? '',
        address: map['address'] as String? ?? '',
        workHours: List<String>.from(map['work_hours'] ?? const []),
      );
}

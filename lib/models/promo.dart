class Promo {
  final String code;
  final int discount;
  final DateTime validFrom;
  final DateTime validTo;
  bool active;

  Promo({
    required this.code,
    required this.discount,
    required this.validFrom,
    required this.validTo,
    this.active = true,
  });
}

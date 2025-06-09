import 'cart_item.dart';

class Order {
  final DateTime date;
  final List<CartItem> items;
  final int total;
  final String city;
  final String district;
  final String street;
  final String house;
  final String flat;
  final String intercom;
  final String comment;
  final String payment;
  final bool leaveAtDoor;
  final bool pickup;

  Order({
    required this.date,
    required this.items,
    required this.total,
    required this.city,
    required this.district,
    required this.street,
    required this.house,
    required this.flat,
    required this.intercom,
    required this.comment,
    required this.payment,
    required this.leaveAtDoor,
    required this.pickup,
  });
}

import 'cart_item.dart';

class Order {
  final DateTime date;
  final List<CartItem> items;
  final int total;
  final String name;
  final String phone;
  final String city;
  final String district;
  final String street;
  final String house;
  final String flat;
  final String floor;
  final String intercom;
  final String comment;
  final String payment;
  final bool leaveAtDoor;
  final bool pickup;

  Order({
    required this.date,
    required this.items,
    required this.total,
    required this.name,
    required this.phone,
    required this.city,
    required this.district,
    required this.street,
    required this.house,
    required this.flat,
    required this.floor,
    required this.intercom,
    required this.comment,
    required this.payment,
    required this.leaveAtDoor,
    required this.pickup,
  });

  Map<String, dynamic> toMap() => {
        'date': date.toIso8601String(),
        'items': items
            .map((e) => {
                  'dish': e.dish.name,
                  'variant': e.variant.title,
                  'price': e.variant.price,
                  'quantity': e.quantity,
                })
            .toList(),
        'total': total,
        'name': name,
        'phone': phone,
        'city': city,
        'district': district,
        'street': street,
        'house': house,
        'flat': flat,
        'floor': floor,
        'intercom': intercom,
        'comment': comment,
        'payment': payment,
        'leaveAtDoor': leaveAtDoor,
        'pickup': pickup,
      };
}

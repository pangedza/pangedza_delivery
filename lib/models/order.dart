import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'cart_item.dart';
import 'promo.dart';

class Order {
  final String id;
  final int orderNumber;
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
  final String deliveryType;
  String status;
  Promo? promo;
  int discount;

  Order({
    required this.id,
    required this.orderNumber,
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
    this.deliveryType = 'delivery',
    this.status = 'Новый',
    this.promo,
    this.discount = 0,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    List<CartItem> parsedItems = [];
    try {
      final raw = json['items'];
      if (raw is String) {
        final decoded = jsonDecode(raw) as List<dynamic>;
        parsedItems = decoded
            .map((e) => CartItem.fromJson(e as Map<String, dynamic>))
            .toList();
      } else if (raw is List) {
        parsedItems = raw.map((e) {
          if (e is String) {
            return CartItem.fromJson(
                jsonDecode(e) as Map<String, dynamic>);
          } else {
            return CartItem.fromJson(e as Map<String, dynamic>);
          }
        }).toList();
      }
    } catch (e) {
      debugPrint('Order.fromJson: failed to parse items: $e');
    }

    final createdAtRaw = json['created_at'] ?? json['date'];
    final createdAtStr = createdAtRaw?.toString();
    final createdAt =
        DateTime.tryParse(createdAtStr ?? '') ?? DateTime.now();

    final idRaw = json['id'];
    final numericId = idRaw is int ? idRaw : int.tryParse(idRaw?.toString() ?? '') ?? 0;

    return Order(
      id: idRaw?.toString() ?? '',
      orderNumber: json['order_number'] as int? ?? numericId,
      date: createdAt,
      items: parsedItems,
      total: json['total'] as int? ?? 0,
      name: json['name']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      city: json['city'] as String? ?? '',
      district: json['district'] as String? ?? '',
      street: json['street'] as String? ?? '',
      house: json['house'] as String? ?? '',
      flat: json['flat'] as String? ?? '',
      floor: json['floor'] as String? ?? '',
      intercom: json['intercom'] as String? ?? '',
      comment: json['comment'] as String? ?? '',
      payment: json['payment'] as String? ?? '',
      leaveAtDoor: json['leaveAtDoor'] as bool? ?? false,
      pickup: json['pickup'] as bool? ?? (json['delivery_type'] == 'pickup'),
      deliveryType: json['delivery_type']?.toString() ??
          ((json['pickup'] as bool? ?? false) ? 'pickup' : 'delivery'),
      status: json['status'] as String? ?? 'Новый',
      promo: null,
      discount: json['discount'] as int? ?? 0,
    );
  }

  /// Price with discount and promo applied.
  int get discountedTotal {
    var amount = total;
    if (discount > 0) {
      amount = amount * (100 - discount) ~/ 100;
    }
    if (promo != null) {
      amount = amount * (100 - promo!.discount) ~/ 100;
    }
    return amount;
  }

  String get statusDisplay {
    switch (status) {
      case 'cancelled':
        return 'Отменён';
      case 'active':
        return 'Активный';
      default:
        return status;
    }
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'order_number': orderNumber,
        'created_at': date.toIso8601String(),
        'items': items.map((e) => e.toMap()).toList(),
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
        'delivery_type': deliveryType,
        'status': status,
        'promo': promo?.code,
        'discount': discount,
      };
}

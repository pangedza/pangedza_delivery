import 'package:flutter/foundation.dart';

import '../models/order.dart';

/// Simple in-memory order repository used in local mode.
class OrderService extends ChangeNotifier {
  OrderService._();

  /// Singleton instance.
  static final OrderService instance = OrderService._();

  final List<Order> _orders = [];

  /// List of all orders sorted with the newest first.
  List<Order> get orders => List.unmodifiable(_orders);

  /// Adds a new [order] and notifies listeners.
  void addOrder(Order order) {
    _orders.insert(0, order);
    notifyListeners();
  }

  /// Returns all orders. In this mock implementation it simply
  /// returns the in-memory list.
  Future<List<Order>> getOrders() async => orders;
}

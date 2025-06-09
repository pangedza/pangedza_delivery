import 'package:flutter/foundation.dart';

import 'order.dart';

class OrderHistoryModel extends ChangeNotifier {
  OrderHistoryModel._();
  static final OrderHistoryModel instance = OrderHistoryModel._();

  final List<Order> orders = [];

  void addOrder(Order order) {
    orders.insert(0, order);
    notifyListeners();
  }
}

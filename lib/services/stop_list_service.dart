import 'package:flutter/foundation.dart';

/// Service that keeps stop list state and leftovers for dishes.
class StopListService extends ChangeNotifier {
  StopListService._();
  static final StopListService instance = StopListService._();

  final Map<String, int> _leftovers = {};
  final Set<String> _stopped = <String>{};

  /// Returns current leftover count for [dishName] or null if unlimited.
  int? leftover(String dishName) => _leftovers[dishName];

  /// Whether the dish is marked as stopped.
  bool isStopped(String dishName) => _stopped.contains(dishName);

  /// Sets leftover count. If [count] <= 0 dish goes to stop list.
  void setLeftover(String dishName, int count) {
    if (count <= 0) {
      _leftovers.remove(dishName);
      _stopped.add(dishName);
    } else {
      _leftovers[dishName] = count;
      _stopped.remove(dishName);
    }
    notifyListeners();
  }

  /// Puts dish to stop list and clears leftover.
  void stopDish(String dishName) {
    _leftovers.remove(dishName);
    _stopped.add(dishName);
    notifyListeners();
  }

  /// Removes dish from stop list and clears leftover restrictions.
  void removeStop(String dishName) {
    _stopped.remove(dishName);
    _leftovers.remove(dishName);
    notifyListeners();
  }

  /// Consumes one item of [dishName] if leftover is specified.
  void consume(String dishName) {
    if (_leftovers.containsKey(dishName)) {
      final left = _leftovers[dishName]! - 1;
      if (left <= 0) {
        _leftovers.remove(dishName);
        _stopped.add(dishName);
      } else {
        _leftovers[dishName] = left;
      }
      notifyListeners();
    }
  }
}

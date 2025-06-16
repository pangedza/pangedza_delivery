import 'package:flutter/foundation.dart';
import '../di.dart';

class ProfileModel extends ChangeNotifier {
  ProfileModel._();
  static final ProfileModel instance = ProfileModel._();

  String _id = '';
  String _name = '';
  String _phone = '';
  /// Role of the current user. Defaults to `user`.
  String role = 'user';
  DateTime? birthDate;
  String gender = 'не выбрано';
  String address = '';
  double? lat;
  double? lng;

  String get id => _id.isNotEmpty ? _id : '00000000-0000-0000-0000-000000000000';
  String get name => _name;
  String get phone => _phone;
  // удалено временно отладочное поведение

  Future<void> load() async {
    _id = authService.getCurrentUserId();
    notifyListeners();
  }

  void setUserId(String id) {
    _id = id;
    notifyListeners();
  }

  void setUser(Map<String, dynamic> user) {
    _id = user['id'] as String? ?? '';
    _name = user['name'] as String? ?? '';
    _phone = user['phone'] as String? ?? '';
    notifyListeners();
  }

  void updateName(String newName) {
    _name = newName;
    notifyListeners();
  }

  void updateBirthDate(DateTime? date) {
    birthDate = date;
    notifyListeners();
  }

  void updateGender(String newGender) {
    gender = newGender;
    notifyListeners();
  }

  void updateAddress(String newAddress, {double? latitude, double? longitude}) {
    address = newAddress;
    lat = latitude;
    lng = longitude;
    notifyListeners();
  }
}

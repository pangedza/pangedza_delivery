import 'package:flutter/foundation.dart';
import '../di.dart';

class ProfileModel extends ChangeNotifier {
  ProfileModel._();
  static final ProfileModel instance = ProfileModel._();

  String? _id;
  String phone = '+7(900)000-00-00';
  String name = 'Гость';
  /// Role of the current user. Defaults to `user`.
  String role = 'user';
  DateTime? birthDate;
  String gender = 'не выбрано';
  String address = '';
  double? lat;
  double? lng;

  String get id => _id ?? '00000000-0000-0000-0000-000000000000';
  // удалено временно отладочное поведение

  Future<void> load() async {
    _id = authService.getCurrentUserId();
    notifyListeners();
  }

  void setUserId(String id) {
    _id = id;
    notifyListeners();
  }

  void updateName(String newName) {
    name = newName;
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

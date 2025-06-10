import 'package:flutter/foundation.dart';

class ProfileModel extends ChangeNotifier {
  ProfileModel._();
  static final ProfileModel instance = ProfileModel._();

  String id = 'user123';
  String phone = '+7(900)000-00-00';
  String name = 'Гость';
  DateTime? birthDate;
  String gender = 'не выбрано';
  String address = '';
  double? lat;
  double? lng;

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

import 'package:flutter/foundation.dart';
import 'address_model.dart';

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

  String? get id => _id.isNotEmpty ? _id : null;
  String get name => _name;
  String get phone => _phone;
  // удалено временно отладочное поведение

  Future<void> load() async {
    // session persistence disabled
    notifyListeners();
  }

  void setUserId(String id) {
    _id = id;
    notifyListeners();
  }

  void setUser(Map<String, dynamic> data) {
    _id = data['id'] ?? '';
    _name = data['name'] ?? '';
    _phone = data['phone'] ?? '';
    final bd = data['birthdate'];
    birthDate = bd != null ? DateTime.tryParse(bd.toString()) : null;
    gender = data['gender'] ?? 'не выбрано';
    if (_id.isNotEmpty) AddressBookModel.instance.load(_id);
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

  Future<void> signOut() async {
    _id = '';
    _name = '';
    _phone = '';
    birthDate = null;
    gender = 'не выбрано';
    AddressBookModel.instance.addresses.clear();
    notifyListeners();
  }
}

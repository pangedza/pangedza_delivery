import 'package:flutter/foundation.dart';
import '../services/users_service.dart';
import '../utils/shared_prefs.dart';

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
    final storedId = await SharedPrefs.instance.getUserId() ?? '';
    if (storedId.isNotEmpty) {
      _id = storedId;
      final profile = await UsersService().getProfile(storedId);
      if (profile != null) {
        _name = profile['name'] ?? '';
        _phone = profile['phone'] ?? '';
      }
    }
    notifyListeners();
  }

  void setUserId(String id) {
    _id = id;
    SharedPrefs.instance.setUserId(id);
    notifyListeners();
  }

  void setUser(Map<String, dynamic> data) {
    _id = data['id'] ?? '';
    _name = data['name'] ?? '';
    _phone = data['phone'] ?? '';
    if (_id.isNotEmpty) SharedPrefs.instance.setUserId(_id);
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
    await SharedPrefs.instance.clearUserId();
    notifyListeners();
  }
}

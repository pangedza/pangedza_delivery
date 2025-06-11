import 'package:flutter/foundation.dart';
import '../services/firebase_service.dart';

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

  Future<void> load() async {
    final user = FirebaseService.instance.auth.currentUser;
    if (user == null) return;
    final doc = await FirebaseService.instance.firestore
        .collection('users')
        .doc(user.uid)
        .get();
    id = user.uid;
    phone = user.phoneNumber ?? '';
    if (doc.exists) {
      final data = doc.data()!;
      name = data['name'] ?? name;
    }
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

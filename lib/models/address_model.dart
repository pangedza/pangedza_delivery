import 'package:flutter/foundation.dart';

class AddressModel {
  final String id;
  String? title;
  String type;
  String street;
  String house;
  String? corpus;
  String? entrance;
  String? code;
  String? floor;
  String? flat;
  double? lat;
  double? lng;

  AddressModel({
    required this.id,
    this.title,
    required this.type,
    required this.street,
    required this.house,
    this.corpus,
    this.entrance,
    this.code,
    this.floor,
    this.flat,
    this.lat,
    this.lng,
  });
}

class AddressBookModel extends ChangeNotifier {
  AddressBookModel._();
  static final AddressBookModel instance = AddressBookModel._();

  final List<AddressModel> addresses = [];

  void add(AddressModel address) {
    addresses.add(address);
    notifyListeners();
  }

  void update(AddressModel address) {
    final index = addresses.indexWhere((a) => a.id == address.id);
    if (index != -1) {
      addresses[index] = address;
      notifyListeners();
    }
  }

  void remove(AddressModel address) {
    addresses.removeWhere((a) => a.id == address.id);
    notifyListeners();
  }
}

import 'package:flutter/foundation.dart';
import '../services/addresses_service.dart';
import 'profile_model.dart';

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

  factory AddressModel.fromMap(Map<String, dynamic> map) => AddressModel(
        id: map['id'].toString(),
        title: map['title'] as String?,
        type: map['type'] as String? ?? '',
        street: map['street'] as String? ?? '',
        house: map['house'] as String? ?? '',
        corpus: map['corpus'] as String?,
        entrance: map['entrance'] as String?,
        code: map['code'] as String?,
        floor: map['floor'] as String?,
        flat: map['flat'] as String?,
        lat: (map['lat'] as num?)?.toDouble(),
        lng: (map['lng'] as num?)?.toDouble(),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'type': type,
        'street': street,
        'house': house,
        'corpus': corpus,
        'entrance': entrance,
        'code': code,
        'floor': floor,
        'flat': flat,
        'lat': lat,
        'lng': lng,
      };
}

class AddressBookModel extends ChangeNotifier {
  AddressBookModel._();
  static final AddressBookModel instance = AddressBookModel._();

  final List<AddressModel> addresses = [];

  Future<void> load(String userId) async {
    final list = await AddressesService().getAddresses(userId);
    addresses
      ..clear()
      ..addAll(list);
    notifyListeners();
  }

  Future<void> add(AddressModel address) async {
    final userId = ProfileModel.instance.id;
    if (userId == null) return;
    final saved = await AddressesService().add(address, userId);
    addresses.add(saved);
    notifyListeners();
  }

  Future<void> update(AddressModel address) async {
    await AddressesService().update(address);
    final index = addresses.indexWhere((a) => a.id == address.id);
    if (index != -1) {
      addresses[index] = address;
      notifyListeners();
    }
  }

  Future<void> remove(AddressModel address) async {
    await AddressesService().delete(address.id);
    addresses.removeWhere((a) => a.id == address.id);
    notifyListeners();
  }
}

import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

import '../models/profile_model.dart';

class AddressInputScreen extends StatefulWidget {
  const AddressInputScreen({super.key});

  @override
  State<AddressInputScreen> createState() => _AddressInputScreenState();
}

class _AddressInputScreenState extends State<AddressInputScreen> {
  final profile = ProfileModel.instance;
  late final TextEditingController _cityCtrl;
  late final TextEditingController _streetCtrl;
  late final TextEditingController _houseCtrl;
  LatLng? _latLng;
  GoogleMapController? _mapCtrl;

  @override
  void initState() {
    super.initState();
    final parts = profile.address.split(',');
    _cityCtrl = TextEditingController(
      text: parts.isNotEmpty && parts.first.isNotEmpty
          ? parts.first.trim()
          : 'Новороссийск',
    );
    _streetCtrl = TextEditingController(
      text: parts.length > 1 ? parts[1].trim() : '',
    );
    _houseCtrl = TextEditingController(
      text: parts.length > 2 ? parts[2].trim() : '',
    );
    if (profile.lat != null && profile.lng != null) {
      _latLng = LatLng(profile.lat!, profile.lng!);
    }
  }

  @override
  void dispose() {
    _cityCtrl.dispose();
    _streetCtrl.dispose();
    _houseCtrl.dispose();
    _mapCtrl?.dispose();
    super.dispose();
  }

  Future<void> _showOnMap() async {
    final address = '${_cityCtrl.text}, ${_streetCtrl.text} ${_houseCtrl.text}'
        .trim();
    try {
      final list = await locationFromAddress(address);
      if (list.isNotEmpty) {
        setState(() {
          _latLng = LatLng(list.first.latitude, list.first.longitude);
        });
        if (_mapCtrl != null) {
          _mapCtrl!.animateCamera(CameraUpdate.newLatLng(_latLng!));
        }
      }
    } catch (e) {
      // ignore errors
    }
  }

  void _save() {
    final addr = '${_cityCtrl.text}, ${_streetCtrl.text}, ${_houseCtrl.text}'
        .trim();
    profile.updateAddress(
      addr,
      latitude: _latLng?.latitude,
      longitude: _latLng?.longitude,
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Адрес')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _cityCtrl,
              decoration: const InputDecoration(labelText: 'Город'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _streetCtrl,
              decoration: const InputDecoration(labelText: 'Улица'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _houseCtrl,
              decoration: const InputDecoration(labelText: 'Дом'),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _showOnMap,
                child: const Text('Показать на карте'),
              ),
            ),
            const SizedBox(height: 8),
            if (Platform.isAndroid || Platform.isIOS)
              Expanded(
                child: _latLng == null
                    ? const Center(
                        child: Text('Введите адрес и нажмите кнопку'),
                      )
                    : GoogleMap(
                        onMapCreated: (c) => _mapCtrl = c,
                        initialCameraPosition: CameraPosition(
                          target: _latLng!,
                          zoom: 16,
                        ),
                        markers: {
                          Marker(
                            markerId: const MarkerId('addr'),
                            position: _latLng!,
                            draggable: true,
                            onDragEnd: (p) => setState(() => _latLng = p),
                          ),
                        },
                      ),
              )
            else
              const SizedBox.shrink(),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _save,
                child: const Text('Сохранить адрес'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';


class AddressMapScreen extends StatefulWidget {
  final String address;
  final LatLng? initial;
  const AddressMapScreen({super.key, required this.address, this.initial});

  @override
  State<AddressMapScreen> createState() => _AddressMapScreenState();
}

class _AddressMapScreenState extends State<AddressMapScreen> {
  LatLng? _latLng;
  GoogleMapController? _mapCtrl;
  late final TextEditingController _searchCtrl;

  @override
  void initState() {
    super.initState();
    _latLng = widget.initial;
    _searchCtrl = TextEditingController(text: widget.address);
    if (_latLng == null && widget.address.isNotEmpty) {
      _search();
    }
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _mapCtrl?.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    final addr = _searchCtrl.text.trim();
    if (addr.isEmpty) return;
    try {
      final list = await locationFromAddress(addr);
      if (list.isNotEmpty) {
        setState(() {
          _latLng = LatLng(list.first.latitude, list.first.longitude);
        });
        if (_mapCtrl != null) {
          _mapCtrl!.animateCamera(CameraUpdate.newLatLng(_latLng!));
        }
      }
    } catch (_) {}
  }

  void _select() {
    Navigator.pop(context, _latLng);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Выбор на карте')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchCtrl,
                    decoration: const InputDecoration(hintText: 'Поиск адреса'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _search,
                ),
              ],
            ),
          ),
          if (Platform.isAndroid || Platform.isIOS)
            Expanded(
              child: _latLng == null
                  ? const Center(child: Text('Введите адрес и нажмите поиск'))
                  : GoogleMap(
                      onMapCreated: (c) => _mapCtrl = c,
                      initialCameraPosition:
                          CameraPosition(target: _latLng!, zoom: 16),
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
            const Expanded(child: SizedBox.shrink()),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _latLng == null ? null : _select,
                child: const Text('Выбрать'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

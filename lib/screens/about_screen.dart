import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

import '../services/info_service.dart';
import '../models/about_info.dart';
import '../widgets/app_drawer.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  AboutInfo? _info;
  LatLng? _latLng;
  GoogleMapController? _mapCtrl;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final info = await InfoService().fetchAbout();
    LatLng? coords;
    if (info != null) {
      try {
        final res = await locationFromAddress(info.address);
        if (res.isNotEmpty) {
          coords = LatLng(res.first.latitude, res.first.longitude);
        }
      } catch (_) {}
    }
    if (mounted) {
      setState(() {
        _info = info;
        _latLng = coords;
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _mapCtrl?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyAppDrawer(),
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text('О нас'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _info == null
              ? const Center(child: Text('Нет данных'))
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    if (Platform.isAndroid && _latLng != null)
                      SizedBox(
                        height: 200,
                        child: GoogleMap(
                          onMapCreated: (c) => _mapCtrl = c,
                          initialCameraPosition:
                              CameraPosition(target: _latLng!, zoom: 16),
                          markers: {
                            Marker(
                              markerId: const MarkerId('pickup'),
                              position: _latLng!,
                            ),
                          },
                        ),
                      ),
                    const SizedBox(height: 16),
                    ListTile(
                      leading: const Icon(Icons.location_on),
                      title: Text(_info!.address),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.phone),
                      title: Text(_info!.phone),
                    ),
                    const Divider(),
                    if (_info!.workHours.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Text('Режим работы',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          for (final h in _info!.workHours)
                            Text(h, style: const TextStyle(fontSize: 14)),
                        ],
                      ),
                  ],
                ),
    );
  }
}

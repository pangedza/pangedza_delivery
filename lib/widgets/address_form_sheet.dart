import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/address_model.dart';
import '../screens/address_map_screen.dart';

class AddressFormSheet extends StatefulWidget {
  final AddressModel? address;
  const AddressFormSheet({super.key, this.address});

  @override
  State<AddressFormSheet> createState() => _AddressFormSheetState();
}

class _AddressFormSheetState extends State<AddressFormSheet> {
  late final TextEditingController _titleCtrl;
  late final TextEditingController _streetCtrl;
  late final TextEditingController _houseCtrl;
  late final TextEditingController _corpusCtrl;
  late final TextEditingController _entranceCtrl;
  late final TextEditingController _codeCtrl;
  late final TextEditingController _floorCtrl;
  late final TextEditingController _flatCtrl;
  String _type = 'Дом';
  LatLng? _latLng;

  @override
  void initState() {
    super.initState();
    final a = widget.address;
    _titleCtrl = TextEditingController(text: a?.title ?? '');
    _streetCtrl = TextEditingController(text: a?.street ?? '');
    _houseCtrl = TextEditingController(text: a?.house ?? '');
    _corpusCtrl = TextEditingController(text: a?.corpus ?? '');
    _entranceCtrl = TextEditingController(text: a?.entrance ?? '');
    _codeCtrl = TextEditingController(text: a?.code ?? '');
    _floorCtrl = TextEditingController(text: a?.floor ?? '');
    _flatCtrl = TextEditingController(text: a?.flat ?? '');
    _type = a?.type ?? 'Дом';
    if (a?.lat != null && a?.lng != null) {
      _latLng = LatLng(a!.lat!, a.lng!);
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _streetCtrl.dispose();
    _houseCtrl.dispose();
    _corpusCtrl.dispose();
    _entranceCtrl.dispose();
    _codeCtrl.dispose();
    _floorCtrl.dispose();
    _flatCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickType() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Дом'),
              onTap: () => Navigator.pop(context, 'Дом'),
            ),
            ListTile(
              leading: const Icon(Icons.work),
              title: const Text('Работа'),
              onTap: () => Navigator.pop(context, 'Работа'),
            ),
            ListTile(
              leading: const Icon(Icons.place),
              title: const Text('Другое'),
              onTap: () => Navigator.pop(context, 'Другое'),
            ),
          ],
        ),
      ),
    );
    if (result != null) {
      setState(() => _type = result);
    }
  }

  Future<void> _showOnMap() async {
    final addr = '${_streetCtrl.text} ${_houseCtrl.text}'.trim();
    final result = await Navigator.push<LatLng?>(
      context,
      MaterialPageRoute(
        builder: (_) => AddressMapScreen(address: addr, initial: _latLng),
      ),
    );
    if (result != null) {
      setState(() => _latLng = result);
    }
  }

  void _save() {
    final model = AddressBookModel.instance;
    final address = AddressModel(
      id: widget.address?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleCtrl.text.isEmpty ? null : _titleCtrl.text,
      type: _type,
      street: _streetCtrl.text,
      house: _houseCtrl.text,
      corpus: _corpusCtrl.text.isEmpty ? null : _corpusCtrl.text,
      entrance: _entranceCtrl.text.isEmpty ? null : _entranceCtrl.text,
      code: _codeCtrl.text.isEmpty ? null : _codeCtrl.text,
      floor: _floorCtrl.text.isEmpty ? null : _floorCtrl.text,
      flat: _flatCtrl.text.isEmpty ? null : _flatCtrl.text,
      lat: _latLng?.latitude,
      lng: _latLng?.longitude,
    );
    if (widget.address == null) {
      model.add(address);
    } else {
      model.update(address);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
        ),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 16),
              TextField(
                controller: _titleCtrl,
                decoration: const InputDecoration(labelText: 'Название адреса'),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickType,
                child: AbsorbPointer(
                  child: TextField(
                    decoration: InputDecoration(labelText: 'Тип адреса', hintText: _type),
                  ),
                ),
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
              TextField(
                controller: _corpusCtrl,
                decoration: const InputDecoration(labelText: 'Корпус'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _entranceCtrl,
                decoration: const InputDecoration(labelText: 'Подъезд'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _codeCtrl,
                decoration: const InputDecoration(labelText: 'Код двери'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _floorCtrl,
                decoration: const InputDecoration(labelText: 'Этаж'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _flatCtrl,
                decoration: const InputDecoration(labelText: 'Квартира'),
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
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _save,
                  child: const Text('Сохранить'),
                ),
              ),
            ],
          ),
          Positioned(
            top: 16,
            right: 16,
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}

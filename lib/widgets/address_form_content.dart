import 'package:flutter/material.dart';
import '../models/address_model.dart';

class AddressFormContent extends StatefulWidget {
  final AddressModel? address;
  const AddressFormContent({super.key, this.address});

  @override
  State<AddressFormContent> createState() => _AddressFormContentState();
}

class _AddressFormContentState extends State<AddressFormContent> {
  late final TextEditingController _titleCtrl;
  late final TextEditingController _streetCtrl;
  late final TextEditingController _houseCtrl;
  late final TextEditingController _corpusCtrl;
  late final TextEditingController _entranceCtrl;
  late final TextEditingController _codeCtrl;
  late final TextEditingController _floorCtrl;
  late final TextEditingController _flatCtrl;

  String _type = '';

  final _errors = <String, String?>{};

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
    _type = a?.type ?? '';
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
    if (!context.mounted) return;
    if (result != null) {
      setState(() => _type = result);
    }
  }


  void _validate() {
    _errors.clear();
    if (_type.trim().isEmpty) _errors['type'] = 'Обязательное поле';
    if (_streetCtrl.text.trim().isEmpty) _errors['street'] = 'Обязательное поле';
    if (_houseCtrl.text.trim().isEmpty) _errors['house'] = 'Обязательное поле';
  }

  Future<void> _save() async {
    _validate();
    if (_errors.isNotEmpty) {
      setState(() {});
      return;
    }

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
    );
    if (widget.address == null) {
      await model.add(address);
    } else {
      await model.update(address);
    }
    if (context.mounted) Navigator.pop(context, address);
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String label,
    String? errorKey,
    bool requiredField = false,
    TextInputType? keyboardType,
  }) {
    final error = errorKey != null ? _errors[errorKey] : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: const Color(0xFF777777)),
            labelText: requiredField ? '$label *' : label,
            labelStyle: const TextStyle(color: Colors.grey, fontSize: 16),
            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            border: InputBorder.none,
          ),
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(left: 48, bottom: 4),
            child: Text(
              error,
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        const Divider(height: 1),
      ],
    );
  }

  Widget _buildTypeField() {
    final error = _errors['type'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          onTap: _pickType,
          contentPadding: const EdgeInsets.symmetric(horizontal: 0),
          leading: const Icon(Icons.help_outline, color: Color(0xFF777777)),
          title: Text(
            _type.isEmpty ? 'Тип адреса *' : _type,
            style: TextStyle(
              color: _type.isEmpty ? Colors.grey : Colors.black,
              fontSize: 16,
            ),
          ),
          trailing: const Icon(Icons.arrow_right, color: Color(0xFF777777)),
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(left: 48, bottom: 4),
            child: Text(
              error,
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        const Divider(height: 1),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: MediaQuery.of(context).viewInsets,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _buildTextField(
                    controller: _titleCtrl,
                    icon: Icons.text_fields,
                    label: 'Название адреса',
                  ),
                  _buildTypeField(),
                  _buildTextField(
                    controller: _streetCtrl,
                    icon: Icons.location_on,
                    label: 'Улица',
                    errorKey: 'street',
                    requiredField: true,
                  ),
                  _buildTextField(
                    controller: _houseCtrl,
                    icon: Icons.location_on,
                    label: 'Дом',
                    errorKey: 'house',
                    requiredField: true,
                  ),
                  _buildTextField(
                    controller: _corpusCtrl,
                    icon: Icons.location_on,
                    label: 'Корпус',
                  ),
                  _buildTextField(
                    controller: _entranceCtrl,
                    icon: Icons.location_on,
                    label: 'Подъезд',
                  ),
                  _buildTextField(
                    controller: _codeCtrl,
                    icon: Icons.door_front_door,
                    label: 'Код двери',
                  ),
                  _buildTextField(
                    controller: _floorCtrl,
                    icon: Icons.stairs,
                    label: 'Этаж',
                  ),
                  _buildTextField(
                    controller: _flatCtrl,
                    icon: Icons.apartment,
                    label: 'Квартира/Офис',
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () => _save(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE30613),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                elevation: 4,
              ),
              child: const Text('ДОБАВИТЬ'),
            ),
          ),
        ),
      ],
    );
  }
}

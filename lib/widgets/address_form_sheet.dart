import 'package:flutter/material.dart';

import '../models/address_model.dart';
import 'address_form_content.dart';

class AddressFormSheet extends StatelessWidget {
  final AddressModel? address;
  const AddressFormSheet({super.key, this.address});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
        body: AddressFormContent(address: address),
      ),
    );
  }
}

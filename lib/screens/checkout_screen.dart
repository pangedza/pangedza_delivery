import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';

import '../models/cart_model.dart';
import '../models/cart_item.dart';
import '../models/order.dart';
import '../models/address_model.dart';
import '../models/profile_model.dart';
import '../widgets/address_form_sheet.dart';
import '../widgets/app_drawer.dart';
import '../services/telegram_service.dart';
import '../services/orders_service.dart';
import '../services/admin_panel_service.dart';
import '../di.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

enum PaymentMethod { cash, terminal, online }

enum CheckoutMode { delivery, pickup }

class _CheckoutScreenState extends State<CheckoutScreen> {
  final cart = CartModel.instance;
  final addressBook = AddressBookModel.instance;
  final profile = ProfileModel.instance;
  bool isSubmitting = false;

  Future<void> submitOrder() async {
    final profile = Provider.of<ProfileModel>(context, listen: false);
    if (profile.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text("Пожалуйста, войдите в аккаунт перед оформлением заказа")),
      );
      return;
    }

    try {
      setState(() => isSubmitting = true);
      debugPrint('🟢 submitOrder for user ${profile.id}');

      final deliveryType =
          _mode == CheckoutMode.pickup ? 'pickup' : 'delivery';
      final success = await OrdersService().createOrder(
        cart,
        profile,
        deliveryType,
        address: _selectedAddress,
        payment: _payment?.name ?? '',
      );
      if (success) {
        Provider.of<CartModel>(context, listen: false).clear();
        if (context.mounted) {
          // Return user to the main screen while keeping them logged in.
          Navigator.of(context).pushNamedAndRemoveUntil('/main', (route) => false);
        }
      } else {
        debugPrint('Не удалось создать заказ');
        showError("Не удалось создать заказ");
      }
    } catch (e) {
      debugPrint('Ошибка при создании заказа: $e');
      showError("Ошибка при создании заказа");
    } finally {
      if (mounted) setState(() => isSubmitting = false);
    }
  }

  void showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  late final TextEditingController nameCtrl;
  late final TextEditingController phoneCtrl;
  final TextEditingController personsCtrl = TextEditingController();
  final TextEditingController commentCtrl = TextEditingController();
  final TextEditingController timeCtrl = TextEditingController();

  CheckoutMode _mode = CheckoutMode.delivery;
  PaymentMethod? _payment;
  AddressModel? _selectedAddress;

  @override
  void initState() {
    super.initState();
    // print('DEBUG: profile.id = ${profile.id}'); // [removed for production]
    nameCtrl = TextEditingController(text: profile.name);
    phoneCtrl = TextEditingController(text: profile.phone);
    nameCtrl.addListener(_update);
    phoneCtrl.addListener(_update);
    personsCtrl.addListener(_update);
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    phoneCtrl.dispose();
    personsCtrl.dispose();
    commentCtrl.dispose();
    timeCtrl.dispose();
    super.dispose();
  }

  void _update() => setState(() {});


  Future<void> _pickDateTime() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      firstDate: now,
      lastDate: now.add(const Duration(days: 30)),
      initialDate: now,
      locale: const Locale('ru'),
    );
    if (date == null) return;
    if (!context.mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) => Localizations.override(
        context: context,
        locale: const Locale('ru'),
        child: child,
      ),
    );
    if (time == null) return;
    if (!context.mounted) return;
    setState(() {
      timeCtrl.text =
          '${DateFormat('dd/MM/yyyy', 'ru').format(date)} ${time.format(context)}';
    });
  }

  Future<void> _selectPayment() async {
    final result = await showModalBottomSheet<PaymentMethod>(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Наличные'),
              onTap: () => Navigator.pop(context, PaymentMethod.cash),
            ),
            ListTile(
              title: Text(
                _mode == CheckoutMode.delivery ? 'Карта курьеру' : 'Карта',
              ),
              onTap: () => Navigator.pop(context, PaymentMethod.terminal),
            ),
            if (_mode == CheckoutMode.delivery)
              ListTile(
                title: const Text('Онлайн-оплата'),
                onTap: () => Navigator.pop(context, PaymentMethod.online),
              ),
          ],
        ),
      ),
    );
    if (!context.mounted) return;
    if (result != null) {
      setState(() => _payment = result);
    }
  }

  Future<void> _chooseAddress() async {
    while (true) {
      final addr = await showModalBottomSheet<AddressModel?>(
        context: context,
        builder: (_) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final a in addressBook.addresses)
                ListTile(
                  leading: const Icon(Icons.place),
                  title: Text(a.title ?? '${a.street}, ${a.house}'),
                  subtitle: Text(
                    [
                      a.street,
                      a.house,
                      if (a.flat != null && a.flat!.isNotEmpty) 'кв. ${a.flat}',
                    ].join(', '),
                  ),
                  onTap: () => Navigator.pop(context, a),
                ),
              ListTile(
                leading: const Icon(Icons.add),
                title: const Text('Добавить адрес'),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      );
      if (!context.mounted) return;
      if (addr != null) {
        setState(() => _selectedAddress = addr);
        break;
      } else {
        await showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          isDismissible: true,
          enableDrag: true,
          backgroundColor: Colors.white,
          builder: (_) => GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Navigator.pop(context),
            child: GestureDetector(
              onTap: () {},
              child: const AddressFormSheet(),
            ),
          ),
        );
        if (!context.mounted) return;
      }
    }
  }


  Widget _buildContactFields() {
    return Column(
      children: [
        TextField(
          controller: nameCtrl,
          decoration: AppTheme.input('Имя *', '').copyWith(
            prefixIcon: const Icon(Icons.text_fields, color: Colors.red),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: phoneCtrl,
          keyboardType: TextInputType.phone,
          decoration: AppTheme.input('Телефон *', '').copyWith(
            prefixIcon: const Icon(Icons.phone, color: Colors.red),
          ),
        ),
      ],
    );
  }

  Widget _buildAdditionalFields() {
    return Column(
      children: [
        TextField(
          controller: personsCtrl,
          keyboardType: TextInputType.number,
          decoration: AppTheme.input('Количество персон *', '').copyWith(
            prefixIcon: const Icon(Icons.people, color: Colors.red),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: commentCtrl,
          decoration: AppTheme.input('Комментарий', '').copyWith(
            prefixIcon: const Icon(Icons.chat_bubble_outline),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeAndPayment({required String timeLabel}) {
    return Column(
      children: [
        GestureDetector(
          onTap: _pickDateTime,
          child: AbsorbPointer(
            child: TextField(
              controller: timeCtrl,
              decoration: AppTheme.input(timeLabel, '').copyWith(
                prefixIcon: const Icon(Icons.schedule),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        ListTile(
          leading: const Icon(Icons.payment, color: Colors.red),
          title: Text(
            _payment == null
                ? 'Способ оплаты *'
                : _payment == PaymentMethod.cash
                ? 'Наличные'
                : _payment == PaymentMethod.terminal
                ? (_mode == CheckoutMode.delivery ? 'Карта курьеру' : 'Карта')
                : 'Онлайн-оплата',
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: _selectPayment,
        ),
      ],
    );
  }

  Widget _buildDeliveryForm() {
    final addressText = _selectedAddress == null
        ? 'Выбрать / Добавить адрес'
        : '${_selectedAddress!.street}, ${_selectedAddress!.house}${_selectedAddress!.flat != null && _selectedAddress!.flat!.isNotEmpty ? ', кв. ${_selectedAddress!.flat}' : ''}';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildContactFields(),
        const SizedBox(height: 16),
        ListTile(
          leading: const Icon(Icons.place, color: Colors.red),
          title: Text(addressText),
          trailing: const Icon(Icons.chevron_right),
          onTap: _chooseAddress,
        ),
        const SizedBox(height: 16),
        _buildAdditionalFields(),
        const SizedBox(height: 16),
        _buildTimeAndPayment(timeLabel: 'Доставить к'),
      ],
    );
  }

  Widget _buildPickupForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildContactFields(),
        const SizedBox(height: 16),
        _buildAdditionalFields(),
        const SizedBox(height: 16),
        _buildTimeAndPayment(timeLabel: 'Приготовить к'),
      ],
    );
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
        title: const Text('Оформление заказа'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() {
                      _mode = CheckoutMode.delivery;
                    }),
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: _mode == CheckoutMode.delivery
                            ? const Color(0xFFD80027)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0xFFD80027)),
                      ),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Доставка',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: _mode == CheckoutMode.delivery
                              ? Colors.white
                              : const Color(0xFFD80027),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() {
                      _mode = CheckoutMode.pickup;
                      if (_payment == PaymentMethod.online) {
                        _payment = null;
                      }
                    }),
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: _mode == CheckoutMode.pickup
                            ? const Color(0xFFD80027)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0xFFD80027)),
                      ),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Самовывоз',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: _mode == CheckoutMode.pickup
                              ? Colors.white
                              : const Color(0xFFD80027),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _mode == CheckoutMode.delivery
                  ? _buildDeliveryForm()
                  : _buildPickupForm(),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  debugPrint("🔴 submitOrder запускается");
                  await submitOrder();
                },
                style: AppTheme.redButton,
                child: const Text('ОТПРАВИТЬ ЗАКАЗ'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

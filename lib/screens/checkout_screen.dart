import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/cart_model.dart';
import '../models/cart_item.dart';
import '../models/order.dart';
import '../models/order_history_model.dart';
import '../models/address_model.dart';
import '../models/profile_model.dart';
import '../widgets/address_form_sheet.dart';
import '../widgets/app_drawer.dart';
import '../services/telegram_service.dart';
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
  final history = OrderHistoryModel.instance;
  final addressBook = AddressBookModel.instance;
  final profile = ProfileModel.instance;

  late final TextEditingController nameCtrl;
  late final TextEditingController phoneCtrl;
  final TextEditingController personsCtrl = TextEditingController();
  final TextEditingController commentCtrl = TextEditingController();
  final TextEditingController timeCtrl = TextEditingController();

  CheckoutMode _mode = CheckoutMode.delivery;
  PaymentMethod? _payment;
  AddressModel? _selectedAddress;
  DateTime? _dateTime;

  @override
  void initState() {
    super.initState();
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

  bool get _canSubmit {
    if (nameCtrl.text.isEmpty ||
        phoneCtrl.text.isEmpty ||
        personsCtrl.text.isEmpty ||
        _payment == null) {
      return false;
    }
    if (_mode == CheckoutMode.delivery && _selectedAddress == null) {
      return false;
    }
    return true;
  }

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
    setState(() {
      _dateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
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
      }
    }
  }

  void _confirm() {
    final bool pickup = _mode == CheckoutMode.pickup;
    final order = Order(
      date: DateTime.now(),
      items: cart.items
          .map(
            (e) => CartItem(
              dish: e.dish,
              variant: e.variant,
              quantity: e.quantity,
            ),
          )
          .toList(),
      total: cart.total,
      name: nameCtrl.text,
      phone: phoneCtrl.text,
      city: 'Новороссийск',
      district: '',
      street: pickup ? 'Коммунистическая' : (_selectedAddress?.street ?? ''),
      house: pickup ? '51' : (_selectedAddress?.house ?? ''),
      flat: pickup ? '' : (_selectedAddress?.flat ?? ''),
      floor: pickup ? '' : (_selectedAddress?.floor ?? ''),
      intercom: pickup ? '' : (_selectedAddress?.code ?? ''),
      comment: commentCtrl.text,
      payment: _payment!.name,
      leaveAtDoor: false,
      pickup: pickup,
    );
    history.addOrder(order);
    firestoreService.saveOrder(order.toMap());

    final addressText = pickup
        ? 'г. Новороссийск, ул. Коммунистическая, д. 51'
        : 'г. ${order.city}, ул. ${order.street}, д. ${order.house}' +
            (order.flat.isNotEmpty ? ', кв. ${order.flat}' : '') +
            (order.floor.isNotEmpty ? ', этаж ${order.floor}' : '') +
            (order.intercom.isNotEmpty ? ', домофон ${order.intercom}' : '');
    final itemsText = order.items
        .map((e) => '• ${e.dish.name} ${e.variant.title} x${e.quantity} — ${e.variant.price} ₽')
        .join('\\n');
    final paymentText = _payment == PaymentMethod.cash
        ? 'Наличные'
        : _payment == PaymentMethod.terminal
            ? (_mode == CheckoutMode.delivery ? 'Карта курьеру' : 'Карта')
            : 'Онлайн-оплата';
    final message = '''
📦 *Новый заказ!*
🧍 Клиент: ${order.name}
📞 Телефон: ${order.phone}
🏠 Адрес: $addressText
🚚 Способ: ${pickup ? 'Самовывоз' : 'Доставка'}
💳 Оплата: $paymentText
📝 Комментарий: "${order.comment}"
🍽 Блюда:
$itemsText
💰 Сумма: ${order.total} ₽
🕒 Время: ${DateFormat('dd.MM.yyyy HH:mm').format(order.date)}
''';
    TelegramService.sendOrder(message);
    cart.clear();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Заказ оформлен'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: const Text('Ок'),
          ),
        ],
      ),
    );
  }

  Widget _buildContactFields() {
    return Column(
      children: [
        TextField(
          controller: nameCtrl,
          decoration: const InputDecoration(
            labelText: 'Имя *',
            prefixIcon: Icon(Icons.text_fields, color: Colors.red),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: phoneCtrl,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            labelText: 'Телефон *',
            prefixIcon: Icon(Icons.phone, color: Colors.red),
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
          decoration: const InputDecoration(
            labelText: 'Количество персон *',
            prefixIcon: Icon(Icons.people, color: Colors.red),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: commentCtrl,
          decoration: const InputDecoration(
            labelText: 'Комментарий',
            prefixIcon: Icon(Icons.chat_bubble_outline),
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
              decoration: InputDecoration(
                labelText: timeLabel,
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
                onPressed: _canSubmit ? _confirm : null,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('ОТПРАВИТЬ ЗАКАЗ'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

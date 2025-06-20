import '../models/promo.dart';

class PromoService {
  final List<Promo> _promos = [];

  List<Promo> get promos => _promos;

  void addPromo(Promo promo) => _promos.add(promo);
}

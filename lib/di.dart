import 'services/mock_auth_service.dart';
import 'services/mock_firestore_service.dart';
import 'services/interfaces/auth_service_interface.dart';
import 'services/interfaces/firestore_service_interface.dart';
import 'services/order_service.dart';
import 'services/promo_service.dart';
import 'services/stop_list_service.dart';

final AuthServiceInterface authService = MockAuthService();
final FirestoreServiceInterface firestoreService = MockFirestoreService();
final OrderService orderService = OrderService.instance;
final PromoService promoService = PromoService();
final StopListService stopListService = StopListService.instance;

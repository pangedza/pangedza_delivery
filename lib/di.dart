import 'services/mock_auth_service.dart';
import 'services/mock_firestore_service.dart';
import 'services/interfaces/auth_service_interface.dart';
import 'services/interfaces/firestore_service_interface.dart';

final AuthServiceInterface authService = MockAuthService();
final FirestoreServiceInterface firestoreService = MockFirestoreService();

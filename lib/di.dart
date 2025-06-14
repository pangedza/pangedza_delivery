import 'services/mock_auth_service.dart';
import 'services/mock_firestore_service.dart';

bool useFirebase = false;

final authService = useFirebase ? FirebaseAuthService() : MockAuthService();
final firestoreService =
    useFirebase ? FirestoreService() : MockFirestoreService();

class FirebaseAuthService {}

class FirestoreService {}

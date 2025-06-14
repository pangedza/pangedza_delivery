import 'interfaces/auth_service_interface.dart';

class MockAuthService implements AuthServiceInterface {
  @override
  Future<bool> signInWithPhone(String phone) async {
    await Future.delayed(const Duration(milliseconds: 300));
    print('Mock signInWithPhone: $phone');
    return true;
  }

  @override
  String getCurrentUserId() => 'test_user';

  @override
  Future<void> saveUserProfile(Map<String, dynamic> profile) async {
    await Future.delayed(const Duration(milliseconds: 100));
    print('Mock saveUserProfile: $profile');
  }
}

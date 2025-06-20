abstract class AuthServiceInterface {
  Future<bool> signInWithPhone(String phone);
  String getCurrentUserId();
  Future<void> saveUserProfile(Map<String, dynamic> profile);
}

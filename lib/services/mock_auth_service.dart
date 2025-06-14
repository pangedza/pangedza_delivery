class MockAuthService {
  Future<bool> signInWithPhone(String phone) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return true;
  }

  String getCurrentUserId() => 'test_user';
}

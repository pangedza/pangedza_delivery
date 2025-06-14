import '../data/local_menu.dart';

class MockFirestoreService {
  Future<List<Map<String, dynamic>>> getMenu() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return localMenu;
  }

  Future<List<Map<String, dynamic>>> getOrders() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [];
  }

  Future<void> saveOrder(Map<String, dynamic> data) async {
    await Future.delayed(const Duration(milliseconds: 100));
  }

  Future<void> saveUserProfile(String name) async {
    await Future.delayed(const Duration(milliseconds: 100));
  }
}

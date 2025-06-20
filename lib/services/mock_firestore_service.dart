import 'interfaces/firestore_service_interface.dart';

class MockFirestoreService implements FirestoreServiceInterface {
  Future<List<Map<String, dynamic>>> getMenu() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [];
  }

  Future<List<Map<String, dynamic>>> getOrders() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [];
  }

  @override
  Future<void> saveOrder(Map<String, dynamic> data) async {
    await Future.delayed(const Duration(milliseconds: 100));
    // print('Mock saveOrder: $data'); // [removed for production]
  }

  Future<void> saveUserProfile(String name) async {
    await Future.delayed(const Duration(milliseconds: 100));
  }
}

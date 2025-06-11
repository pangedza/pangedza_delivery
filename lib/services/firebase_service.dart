import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../firebase_options.dart';

class FirebaseService {
  FirebaseService._();
  static final FirebaseService instance = FirebaseService._();

  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  final messaging = FirebaseMessaging.instance;

  Future<void> init() async {
    await dotenv.load(fileName: '.env');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await messaging.requestPermission();
  }

  Future<void> saveUserProfile(String name) async {
    final user = auth.currentUser;
    if (user == null) return;
    final doc = firestore.collection('users').doc(user.uid);
    await doc.set({
      'phone': user.phoneNumber,
      'name': name,
      'role': 'user',
    }, SetOptions(merge: true));
    final token = await messaging.getToken();
    if (token != null) {
      await doc.update({'fcmToken': token});
    }
  }

  Future<void> saveOrder(Map<String, dynamic> data) async {
    await firestore.collection('orders').add(data);
  }
}

import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class SubscriptionService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// ✅ Đăng ký email nhận dự báo
  Future<void> subscribe(String email) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: "defaultPassword123"); // Tạo user Firebase
      await _db.collection("subscribers").doc(email).set({"email": email, "confirmed": false});

      final response = await http.post(
        Uri.parse("https://your-cloud-function-url/send-confirmation"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email}),
      );

      if (response.statusCode == 200) {
        print("Confirmation email sent to $email");
      } else {
        print("Failed to send confirmation email");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  /// ✅ Xác nhận email
  Future<void> confirmSubscription(String email) async {
    await _db.collection("subscribers").doc(email).update({"confirmed": true});
  }

  /// ✅ Hủy đăng ký
  Future<void> unsubscribe(String email) async {
    await _db.collection("subscribers").doc(email).delete();
    print("Unsubscribed: $email");
  }
}

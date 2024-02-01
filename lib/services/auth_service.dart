import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:interview_wallet_app/models/transaction_mode.dart';
import 'package:interview_wallet_app/models/user_model.dart';
import 'package:intl/intl.dart';

import '../user_cubit/user_cubit.dart';
import 'package:http/http.dart' as http;

class FirebaseService {
  final _db = FirebaseFirestore.instance;

  //transfer amount
  Future<String> transfer({
    required String sender,
    required String recipient,
    required int transferAmount,
    required String time,
    required int myBalance,
  }) async {
    final senderDoc = _db.collection("Users").doc(sender);
    final receiverDoc = _db.collection("Users").doc(recipient);
    print(sender);
    print(recipient);
    if (transferAmount <= myBalance) {
      await senderDoc
          .update({"balance": FieldValue.increment((-transferAmount))});
      await receiverDoc
          .update({"balance": FieldValue.increment(transferAmount)});

      await senderDoc.collection("transactions").doc().set({
        "amount": transferAmount,
        "type": "sent",
        "time": DateFormat('dd, MMM, yyyy').format(DateTime.now()),
        "sender": sender,
        "receiver": recipient,
      });
      await receiverDoc.collection("transactions").doc().set({
        "amount": transferAmount,
        "type": "received",
        "time": DateFormat('dd, MMM, yyyy, HH:mm').format(DateTime.now()),
        "sender": sender,
        "receiver": recipient,
      });

      return "Success";
    }
    return "Error";
  }

  Future<dynamic> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        // User canceled the sign-in process
        print('Google sign-in canceled.');
        return;
      }

      GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      print('Access Token: ${googleAuth.accessToken}');
      print('ID Token: ${googleAuth.idToken}');

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await FirebaseAuth.instance.signInWithCredential(credential);

      print('Successfully signed in with Google.');
    } catch (e) {
      print('Error during Google sign-in: $e');
      // Handle specific types of exceptions if needed
      // Example: if (e is FirebaseAuthException) { /* handle FirebaseAuthException */ }
    }
  }

  void sendPushNotification(
      {required String token,
      required String body,
      required String title}) async {
    try {
      await http.post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
          headers: <String, String>{
            "Content-Type": "application/json",
            'Authorization':
                "key=AAAAnzUKZhU:APA91bGawHPsACt2c0amZOTAm7r0cwF0rQlLc0zh_mM7oDcm4hsCWrcwD_WnATcfZgCZz3VGQmRQIQnllq0N1H9g_OzMO2kjUXZ0mU00GmL_6pTnAJhJp3KAPrAUZtMCrgDyz81bUuVd"
          },
          body: jsonEncode(<String, dynamic>{
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'status': 'done',
              'body': body,
              'title': title,
            },
            "notification": <String, dynamic>{
              'body': body,
              'title': title,
              'android_channel': "Wallet"
            },
            "to": token
          }));
    } catch (e) {
      print(e.toString());
    }
  }
}

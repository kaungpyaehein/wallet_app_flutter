import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_wallet_app/core/route_extensions.dart';
import 'package:interview_wallet_app/services/auth_service.dart';

import '../core/utils/colors.dart';
import '../core/utils/dimensions.dart';
import '../user_cubit/user_cubit.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  Future<void> _simulateDelayedLoading() async {
    // Simulate a delay using Future.delayed
    await Future.delayed(const Duration(seconds: 3));
  }

  @override
  void initState() {
    super.initState();
    _simulateDelayedLoading();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(kMarginLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),

            //logo
            RichText(
                text: const TextSpan(children: [
              TextSpan(
                  text: "Walle",
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontWeight: FontWeight.w300,
                    fontSize: kTextHeading2X * 2,
                  )),
              TextSpan(
                  text: "To",
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontWeight: FontWeight.w700,
                    fontSize: kTextHeading2X * 2,
                  )),
            ])),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade100,
                  padding: const EdgeInsets.symmetric(vertical: kMarginMedium2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(kMarginMedium),
                  )),
              onPressed: () {
                signIn();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //logo
                  Image.asset(
                    "assets/images/google_logo.png",
                    height: kMarginXLarge2,
                    width: kMarginXLarge2,
                  ),

                  ///spacer
                  const SizedBox(
                    width: kMarginMedium3,
                  ),

                  //title
                  const Text(
                    "Sign in with Google",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: kTextRegular2X,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: kMarginXXLarge3,
            )
          ],
        ),
      ),
    );
  }

  void signIn() async {
    try {
      await FirebaseService().signInWithGoogle().then((value) async {
        final credential = FirebaseAuth.instance.currentUser!;
        context.read<UserCubit>().getUserInfo(credential);
        final firebaseMessaging = FirebaseMessaging.instance;
        final token = await firebaseMessaging.getToken();
        final userDocRef = FirebaseFirestore.instance
            .collection("Users")
            .doc(credential.email);

        // Check if the document already exists
        final userDoc = await userDocRef.get();

        if (!userDoc.exists) {
          // User is new, create a new document
          await userDocRef.set({
            "email": credential.email,
            "name": credential.displayName,
            "id": credential.uid,
            "balance": 10000,
            "token": token.toString()
          });
        } else {
          await userDocRef.update({"token": token.toString()});
          // await userDocRef.update({
          //   "balance": FieldValue.increment(2000),
          // });
          // await userDocRef.set({
          //   "email": credential.email,
          //   "name": credential.displayName,
          //   "id": credential.uid,
          //
          // });
        }
      });
    } catch (e) {
      print(e.toString());
      context.pop();
    }
  }
}

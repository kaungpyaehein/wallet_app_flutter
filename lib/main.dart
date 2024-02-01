import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:interview_wallet_app/pages/auth_page.dart';
import 'package:interview_wallet_app/pages/home_page.dart';
import 'package:interview_wallet_app/pages/page0.dart';
import 'package:interview_wallet_app/push_notification.dart';
import 'package:interview_wallet_app/transaction_cubit/transaction_cubit.dart';
import 'package:interview_wallet_app/user_cubit/user_cubit.dart';
import 'package:interview_wallet_app/user_list_cubit/user_list_cubit.dart';

import 'firebase_options.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
// function to lisen to background changes
Future _firebaseBackgroundMessage(RemoteMessage message) async {
  if (message.notification != null) {
    print("Some notification Received");
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  PushNotification.init();
  PushNotification.localNotiInit();
  await FirebaseMessaging.instance.getInitialMessage().then((value) {
    if (value != null) {
      print("Launched from terminated state");
      Future.delayed(const Duration(seconds: 1), () {
        navigatorKey.currentState?.push(MaterialPageRoute(
          builder: (context) => const PageO(),
        ));
      });
    }
  });
  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessage);
  // to handle foreground notifications
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    String payloadData = jsonEncode(message.data);
    print("Got a message in foreground");
    if (message.notification != null) {
      PushNotification.showSimpleNotification(
          title: message.notification!.title!,
          body: message.notification!.body!,
          payload: payloadData);
    }
  });
  // await FirebaseMessaging.instance.getInitialMessage().then((value) {
  //   print("Got a message form terminated $value");
  // });
  // FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessage);
  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    print(message.notification?.title);
    print(message.notification?.body);
    if (message.notification != null) {
      print("Background Notification Tapped");

      // Ensure that navigatorKey.currentState is not null before using it

      navigatorKey.currentState?.push(MaterialPageRoute(
        builder: (context) => const PageO(),
      ));
    }
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => UserCubit()),
          BlocProvider(create: (_) => TransactionCubit()),
          BlocProvider(create: (_) => UserListCubit()),
        ],
        child: MaterialApp(
          theme: ThemeData(
              appBarTheme: const AppBarTheme(
            centerTitle: true,
          )),
          debugShowCheckedModeBanner: false,
          home: const PageO(),
        ));
  }
}

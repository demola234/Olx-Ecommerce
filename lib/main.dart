import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:olx/core/utils/navigator.dart';
import 'package:olx/di/di.dart';
import 'package:olx/features/authentication/presentation/provider/auth_provider.dart';
import 'package:olx/features/authentication/presentation/view/onboarding/onboarding.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'features/authentication/presentation/view/phone_authentication/phone_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await injector();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<AuthProvider>.value(
      value: AuthProvider(),
    ),
  ], child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    Timer(const Duration(milliseconds: 3), () {
      FirebaseAuth.instance.authStateChanges().listen((event) {
        if (event == null) {
          NavigationService().replaceScreen(const EnterPhone());
        } else {
          NavigationService().replaceScreen(const OnBoarding());
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
        child: MaterialApp(
      title: 'Olx',
      navigatorKey: NavigationService().navigationKey,
      debugShowCheckedModeBanner: false,
      home: const OnBoarding(),
    ));
  }
}

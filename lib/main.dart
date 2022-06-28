import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:olx/core/utils/navigator.dart';
import 'package:olx/di/di.dart';
import 'package:olx/features/authentication/presentation/provider/auth_provider.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'features/authentication/presentation/view/phone_authentication/phone_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await injector();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
        child: MaterialApp(
      title: 'Olx',
      navigatorKey: NavigationService().navigationKey,
      debugShowCheckedModeBanner: false,
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthProvider>.value(
            value: AuthProvider(),
          )
        ],
        child: EnterPhone(),
      ),
    ));
  }
}

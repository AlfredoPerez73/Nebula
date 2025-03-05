import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:nebula/firebase_options.dart';
import 'package:nebula/src/routes/app_routes.dart';
import 'package:nebula/src/routes/routes.dart';
import 'package:nebula/src/views/pages/frm_login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.login,
      routes: appRoutes,
      title: 'Fitness AI App',
      home: LoginPage(),
    );
  }
}

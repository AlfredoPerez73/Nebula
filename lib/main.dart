import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:nebula/src/provider/auth.provider.dart';
import 'package:nebula/src/provider/login.provider.dart';
import 'package:nebula/src/services/local_storage.services.dart';
import 'package:nebula/src/services/push_notification.services.dart';
import 'package:nebula/src/routes/app_routes.dart';
import 'package:nebula/src/routes/routes.dart';
import 'package:provider/provider.dart';

void main() async {
  Intl.defaultLocale = 'es_ES';
  await initializeDateFormatting();
  WidgetsFlutterBinding.ensureInitialized();
  await PushNotificationServices.initializeApp();
  await LocalStorage().init();
  final isLogged = LocalStorage().getIsLoggedIn();
  runApp(MyApp(isLogged: isLogged));
}

class MyApp extends StatelessWidget {
  final bool isLogged;
  const MyApp({super.key, required this.isLogged});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(lazy: false, create: (_) => LoginProvider()),
        ChangeNotifierProvider(lazy: false, create: (_) => RegisterProvider()),
      ],
      child: MaterialApp(
        supportedLocales: const [
          Locale('es', 'ES'),
          Locale('en', 'US'),
        ],
        debugShowCheckedModeBanner: false,
        initialRoute: Routes.login,
        routes: appRoutes,
      ),
    );
  }
}

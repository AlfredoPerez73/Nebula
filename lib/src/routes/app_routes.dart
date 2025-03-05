import 'package:flutter/material.dart';
import '../views/pages/frm_login.dart';
//import '../views/pages/frm_registro.dart';
import './routes.dart';

Map<String, Widget Function(BuildContext)> appRoutes = {
  Routes.login: (_) => const LoginPage(),
  //Routes.login: (_) => const registroPage()
};

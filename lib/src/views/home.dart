import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final dynamic userData;
  const HomeScreen({Key? key, this.userData}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenPageState();
}

class _HomeScreenPageState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

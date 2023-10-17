import 'package:flutter/material.dart';
import 'package:event_page/modules/routes.dart';
import 'package:event_page/screens/event_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: '옷다 랜딩페이지',
        routes: routes,
        debugShowCheckedModeBanner: false
    );
  }
}
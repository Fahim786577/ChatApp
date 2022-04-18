import 'package:chatapp/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/theme.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat Home',
      theme: AppTheme.light(),
      //darkTheme: AppTheme.dark(),
      //themeMode: ThemeMode.dark,
      home: const HomeScreen(),

    );
  }
}


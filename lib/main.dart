import 'package:flutter/material.dart';
import 'package:flutter_gpt/common/colors.dart';
import 'package:flutter_gpt/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Flutter GPT",
        theme: ThemeData.light(useMaterial3: true).copyWith(
            scaffoldBackgroundColor: AppColours.whiteColor,
            appBarTheme: const AppBarTheme(backgroundColor: AppColours.whiteColor)),
        home: const HomePage());
  }
}

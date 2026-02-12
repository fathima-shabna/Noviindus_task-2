import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'my_feed_screen.dart';
import 'home_screen.dart';
import 'add_feeds_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Noviindus Task 2',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF131313),
        textTheme: GoogleFonts.montserratTextTheme(ThemeData.dark().textTheme),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFC60000),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const MyFeedScreen(),
    );
  }
}

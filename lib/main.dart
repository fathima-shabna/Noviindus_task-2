import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'presentation/screens/mobile_entry_screen.dart';
import 'providers/auth_provider.dart';
import 'providers/home_provider.dart';
import 'providers/add_feed_provider.dart';
import 'providers/my_feed_provider.dart';
import 'data/services/api_service.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => ApiService()),
        ChangeNotifierProxyProvider<ApiService, AuthProvider>(
          create: (context) => AuthProvider(context.read<ApiService>()),
          update: (context, api, auth) => auth ?? AuthProvider(api),
        ),
        ChangeNotifierProxyProvider<ApiService, HomeProvider>(
          create: (context) => HomeProvider(context.read<ApiService>()),
          update: (context, api, home) => home ?? HomeProvider(api),
        ),
        ChangeNotifierProxyProvider<ApiService, AddFeedProvider>(
          create: (context) => AddFeedProvider(context.read<ApiService>()),
          update: (context, api, add) => add ?? AddFeedProvider(api),
        ),
        ChangeNotifierProxyProvider<ApiService, MyFeedProvider>(
          create: (context) => MyFeedProvider(context.read<ApiService>()),
          update: (context, api, my) => my ?? MyFeedProvider(api),
        ),
      ],
      child: const MyApp(),
    ),
  );
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
      home: const MobileEntryScreen(), // Start with Login
    );
  }
}

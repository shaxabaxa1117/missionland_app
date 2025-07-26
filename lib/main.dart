import 'package:flutter/material.dart';
import 'package:missionland_app/auth/presentation/sig_in_page.dart';
import 'package:missionland_app/auth/presentation/sign_up_page.dart';

void main() {
  runApp(const EcoApp());
}

class EcoApp extends StatelessWidget {
  const EcoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eco App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF4CAF50), // зелёный
        scaffoldBackgroundColor: const Color(0xFFE8F5E9), // светло-зелёный
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (_) => const SignInPage(),
        '/register': (_) => const SignUpPage(),
      },
    );
  }
}

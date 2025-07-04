import 'package:arsitektur_app/screens/ar_page%20backup%202.dart';
import 'package:arsitektur_app/screens/home_page.dart';
import 'package:arsitektur_app/screens/materi_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  // Ensure that Flutter bindings are initialized before running the app.
  WidgetsFlutterBinding.ensureInitialized();
  // Lock screen orientation to portrait mode.
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ARsitektur',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.grey,
        scaffoldBackgroundColor: const Color(0xFFF5F5F7),
        fontFamily: 'Inter',
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.black87),
          titleTextStyle: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4DB6AC), // Teal accent
          brightness: Brightness.light,
          primary: const Color(0xFF4DB6AC),
          secondary: const Color(0xFFE0F2F1), // Lighter teal for backgrounds
        ),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/materi': (context) => const MateriPage(),
        '/ar': (context) => const ArPage(),
      },
    );
  }
}

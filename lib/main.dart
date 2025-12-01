import 'package:arsitektur_app/screens/ar_page.dart';
import 'package:arsitektur_app/screens/home_page.dart';
import 'package:arsitektur_app/screens/materi_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// The main entry point of the application.
///
/// This function initializes the Flutter bindings, sets the preferred
/// screen orientation to portrait up, and runs the [MyApp] widget.
void main() {
  // Ensure that Flutter bindings are initialized before running the app.
  WidgetsFlutterBinding.ensureInitialized();
  // Lock screen orientation to portrait mode.
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const MyApp());
}

/// The root widget of the application.
///
/// This widget sets up the [MaterialApp] with a custom theme and routes.
class MyApp extends StatelessWidget {
  /// Creates an instance of [MyApp].
  const MyApp({super.key});

  /// Builds the widget tree for the application.
  ///
  /// This method configures the [MaterialApp] with the title, theme,
  /// and navigation routes.
  ///
  /// - [context]: The build context for the widget.
  ///
  /// Returns a [MaterialApp] widget.
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

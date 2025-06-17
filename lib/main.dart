import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart'; // Asegúrate que este archivo exista y tenga PantallaInicio

void main() {
  runApp(const JuegoMemoria());
}

class JuegoMemoria extends StatelessWidget {
  const JuegoMemoria({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Juego de Memoria',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF673AB7),
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFF673AB7),
          secondary: const Color(0xFFFFC107),
          surface: const Color(0xFF29294D),
          onPrimary: Colors.white,
          onSecondary: Colors.black,
          onSurface: Colors.white70,
        ),
        scaffoldBackgroundColor: const Color(0xFF1E1E2C),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF673AB7),
          elevation: 4,
          titleTextStyle: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
              fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
          titleLarge: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white70),
          bodyLarge: TextStyle(fontSize: 16, color: Colors.white70),
          labelLarge: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFFC107),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 32),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 6,
            shadowColor: Colors.black45,
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      home: const PantallaInicio(),
    );
  }
}

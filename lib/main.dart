import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';

void main() {
  runApp(JuegoMemoria());
}

class JuegoMemoria extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Juego de Memoria',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PantallaInicio(),
      debugShowCheckedModeBanner: false,
    );
  }
}
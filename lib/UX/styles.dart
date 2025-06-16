import 'package:flutter/material.dart';

class EstilosApp {
  // Paleta azul oscura
  static const Color colorPrimario = Color(0xFF0D47A1); // Azul oscuro
  static const Color colorFondo = Color.fromARGB(255, 56, 4, 124); // Fondo dark
  static const Color colorCartaOculta = Color(0xFF1E88E5); // Azul medio
  static const Color colorCartaVolteada = Colors.white;
  static const Color colorExito = Colors.green;
  static const Color colorBorde = Colors.white24;

  // Estilos de texto
  static const TextStyle tituloGrande = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle tituloMedio = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: Colors.white70,
  );

  static const TextStyle textoNormal = TextStyle(
    fontSize: 16,
    color: Colors.white70,
  );

  static const TextStyle textoDestacado = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle textoCartaGrande = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Color.fromARGB(255, 0, 0, 0),
  );

  static const TextStyle textoBoton = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  // Botón azul redondeado
  static final ButtonStyle botonPrincipal = ElevatedButton.styleFrom(
    backgroundColor: colorPrimario,
    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(25),
    ),
  );
}

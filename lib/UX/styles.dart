import 'package:flutter/material.dart';

class EstilosApp {
  // Colores
  static const Color colorPrimario = Colors.blue;
  static const Color colorFondo = Color(0xFFF5F5F5);
  static const Color colorCartaOculta = Colors.grey;
  static const Color colorCartaVolteada = Colors.white;
  static const Color colorExito = Colors.green;
  static const Color colorBorde = Colors.black54;
  
  // Estilos de texto
  static const TextStyle tituloGrande = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );
  
  static const TextStyle tituloMedio = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );
  
  static const TextStyle textoNormal = TextStyle(
    fontSize: 16,
    color: Colors.black87,
  );
  
  static const TextStyle textoDestacado = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );
  
  static const TextStyle textoCartaGrande = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );
  
  static const TextStyle textoBoton = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
  
  // Estilos de botones
  static final ButtonStyle botonPrincipal = ElevatedButton.styleFrom(
    backgroundColor: colorPrimario,
    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(25),
    ),
  );
}
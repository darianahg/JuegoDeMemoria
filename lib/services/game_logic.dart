import '../models/card_model.dart';
import 'dart:math';
import 'package:flutter/material.dart';

class LogicaJuego {
  List<List<ModeloCarta>> matriz = [];
  int intentos = 0;
  int intentosCorrectos = 0;
  int intentosFallidos = 0;
  int puntos = 0;
  int paresEncontrados = 0;
  int totalPares = 0;

  List<ModeloCarta> cartasVolteadas = [];

  // Callback para notificar cambios en la UI
  VoidCallback? onUpdateUI; // Genera la matriz 2D con las parejas aleatorizadas
  List<List<ModeloCarta>> generarMatriz(int filas, int columnas) {
    totalPares = (filas * columnas) ~/ 2;

    // Validar que el número de cartas sea par para formar parejas
    if ((filas * columnas) % 2 != 0) {
      throw ArgumentError(
          'El número total de cartas debe ser par para formar parejas');
    }

    // Crear lista de valores para las parejas
    List<String> valores = _generarValoresPareja(totalPares);

    // Aleatorizar completamente la ubicación de las parejas
    valores.shuffle(Random());

    // Crear la matriz 2D con las cartas
    matriz = _crearMatriz2D(filas, columnas, valores);

    return matriz;
  }

  // Método privado para generar los valores de las parejas
  List<String> _generarValoresPareja(int cantidadPares) {
    List<String> valores = [];
    for (int i = 0; i < cantidadPares; i++) {
      String valor = String.fromCharCode(65 + i); // A, B, C, D...
      valores.add(valor); // Primera carta del par
      valores.add(valor); // Segunda carta del par
    }
    return valores;
  }

  // Método privado para crear la matriz 2D
  List<List<ModeloCarta>> _crearMatriz2D(
      int filas, int columnas, List<String> valores) {
    List<List<ModeloCarta>> nuevaMatriz = [];
    int contador = 0;

    for (int i = 0; i < filas; i++) {
      List<ModeloCarta> fila = [];
      for (int j = 0; j < columnas; j++) {
        fila.add(ModeloCarta(
          id: contador,
          valor: valores[contador],
        ));
        contador++;
      }
      nuevaMatriz.add(fila);
    }
    return nuevaMatriz;
  }

  //Voltear carta
  bool voltearCarta(int fila, int columna) {
    if (matriz[fila][columna].estaVolteada ||
        matriz[fila][columna].estaEmparejada ||
        cartasVolteadas.length >= 2) {
      return false;
    }
    matriz[fila][columna].estaVolteada = true;
    cartasVolteadas.add(matriz[fila][columna]);

    if (cartasVolteadas.length == 2) {
      verificarPareja();
    }
    return true;
  }

  // Verificar si hay pareja y manejar puntaje
  void verificarPareja() {
    intentos++;

    if (_esParejValida()) {
      _manejarParejaCorrecta();
    } else {
      _manejarParejaIncorrecta();
    }
  }

  // Verificar si las cartas forman una pareja válida
  bool _esParejValida() {
    return cartasVolteadas[0].valor == cartasVolteadas[1].valor;
  }

  // Manejar pareja correcta
  void _manejarParejaCorrecta() {
    cartasVolteadas[0].estaEmparejada = true;
    cartasVolteadas[1].estaEmparejada = true;
    paresEncontrados++;
    intentosCorrectos++;

    // Calcular puntos: base + bonus por eficiencia
    int puntosBase = 10;
    int bonusEficiencia = _calcularBonusEficiencia();
    puntos += puntosBase + bonusEficiencia;

    cartasVolteadas.clear();
  }

  // Manejar pareja incorrecta
  void _manejarParejaIncorrecta() {
    intentosFallidos++;

    final primeraCarta = cartasVolteadas[0];
    final segundaCarta = cartasVolteadas[1];

    // Mantener cartas visibles por 2 segundos
    Future.delayed(Duration(milliseconds: 2000), () {
      primeraCarta.estaVolteada = false;
      segundaCarta.estaVolteada = false;
      cartasVolteadas.clear();

      if (onUpdateUI != null) {
        onUpdateUI!();
      }
    });
  }

  // Calcular bonus por eficiencia
  int _calcularBonusEficiencia() {
    if (intentosFallidos == 0) return 5; // Perfecto
    if (intentosFallidos <= 2) return 3; // Muy bueno
    if (intentosFallidos <= 5) return 1; // Bueno
    return 0; // Sin bonus
  }

  //verificar si el juego terminó
  bool juegoTerminado() {
    return paresEncontrados == totalPares;
  }

  // Reiniciar juego limpiando todos los valores
  void reiniciarJuego() {
    matriz.clear();
    intentos = 0;
    intentosCorrectos = 0;
    intentosFallidos = 0;
    puntos = 0;
    paresEncontrados = 0;
    totalPares = 0;
    cartasVolteadas.clear();
  }

  // Obtener estadísticas del juego
  Map<String, dynamic> obtenerEstadisticas() {
    return {
      'intentos': intentos,
      'intentosCorrectos': intentosCorrectos,
      'intentosFallidos': intentosFallidos,
      'puntos': puntos,
      'paresEncontrados': paresEncontrados,
      'totalPares': totalPares,
      'eficiencia':
          intentos > 0 ? (intentosCorrectos / intentos * 100).round() : 0,
    };
  }
}

import '../models/card_model.dart';
import 'dart:math';
import 'dart:collection';
import 'package:flutter/material.dart';

/// Clase para el historial de movimientos (Stack/Pila)
class HistorialMovimiento {
  final int puntos;
  final int intentos;
  final String accion; //'acierto' o 'error'
  
  HistorialMovimiento(this.puntos, this.intentos, this.accion);
}

/// Clase abstracta base para el juego
abstract class JuegoBase {
  void iniciarJuego();
  void reiniciarJuego();
  bool juegoTerminado();
}

/// Lógica principal del juego de memoria
/// Utiliza estructuras de datos específicas:
/// - Array 2D para la matriz de cartas
/// - Queue (Cola FIFO) para cartas volteadas
/// - List como Stack (Pila LIFO) para historial
/// - Set para valores únicos encontrados
class LogicaJuego extends JuegoBase {
  
  // ==================== PROPIEDADES ====================
  
  /// Matriz 2D - Array bidimensional de cartas
  List<List<ModeloCarta?>> matriz = [];
  
  /// Variables de estado del juego
  int intentos = 0;
  int intentosCorrectos = 0;
  int intentosFallidos = 0;
  int puntos = 0;
  int paresEncontrados = 0;
  int totalPares = 0;
  bool bloqueado = false; //Bloquear volteo durante verificación

  /// Estructuras de datos específicas
  Queue<ModeloCarta> cartasVolteadas = Queue<ModeloCarta>(); // Cola FIFO
  List<HistorialMovimiento> historial = []; // Lista como Stack (Pila LIFO)
  Set<String> valoresUnicos = Set<String>(); // Conjunto para valores únicos

  /// Callback para actualizar UI
  VoidCallback? onUpdateUI;

  // ==================== MÉTODOS PRINCIPALES ====================
  
  @override
  void iniciarJuego() => reiniciarJuego();

  /// Genera una matriz rectangular de cartas para el juego
  /// Optimizada para soportar hasta 20x20 cartas
  List<List<ModeloCarta?>> generarMatrizRectangular(int filas, int columnas) {
    int totalCartas = filas * columnas;
    if (totalCartas % 2 != 0) totalCartas--; // Asegurar número par
    totalPares = totalCartas ~/ 2;
    
    // Crear parejas usando Set para evitar duplicados
    Set<String> valoresSet = {};
    for (int i = 0; i < totalPares; i++) {
      valoresSet.add(_generarLetra(i));
    }
    
    // Convertir Set a List y duplicar para crear parejas
    List<String> valores = [];
    for (String valor in valoresSet) {
      valores.add(valor);
      valores.add(valor);
    }
    valores.shuffle(Random());

    // Crear matriz 2D
    matriz = List.generate(filas, (i) => 
      List.generate(columnas, (j) {
        int index = i * columnas + j;
        return index < valores.length 
          ? ModeloCarta(id: index, valor: valores[index])
          : null;
      })
    );
    
    return matriz;
  }

  /// Voltea una carta y maneja la lógica del juego
  /// Utiliza bloqueo para evitar volteos durante verificación
  bool voltearCarta(int fila, int columna) {
    // Verificaciones de validez
    if (bloqueado || 
        matriz[fila][columna] == null || 
        cartasVolteadas.length >= 2) {
      return false;
    }
    ModeloCarta carta = matriz[fila][columna]!;
    if (carta.estaVolteada || carta.estaEmparejada) return false;
    
    // Voltear carta y agregar a cola FIFO
    carta.estaVolteada = true;
    cartasVolteadas.add(carta);
    
    // Si hay 2 cartas, verificar si forman pareja
    if (cartasVolteadas.length == 2) {
      bloqueado = true; // Bloquear más volteos
      _verificarParejaConDelay();
    }
    return true;
  }

  @override
  bool juegoTerminado() => paresEncontrados == totalPares;

  @override
  void reiniciarJuego() {
    // Limpiar todas las estructuras de datos
    matriz.clear();
    cartasVolteadas.clear(); // Cola
    historial.clear(); // Stack/Lista
    valoresUnicos.clear(); // Set
    
    // Resetear variables
    intentos = intentosCorrectos = intentosFallidos = 0;
    puntos = paresEncontrados = totalPares = 0;
    bloqueado = false;
  }

  // ==================== MÉTODOS AUXILIARES ====================
  
  /// Genera letras para identificar cartas (A-Z, a-z, 0-9, AA-ZZ...)
  /// Soporta hasta 400+ cartas únicas
  String _generarLetra(int numero) {
    if (numero < 26) {
      return String.fromCharCode(65 + numero); // A-Z
    } else if (numero < 52) {
      return String.fromCharCode(97 + (numero - 26)); // a-z
    } else if (numero < 62) {
      return String.fromCharCode(48 + (numero - 52)); // 0-9
    } else {
      // Para matrices muy grandes: AA, AB, AC...
      int primera = (numero - 62) ~/ 26;
      int segunda = (numero - 62) % 26;
      return String.fromCharCode(65 + primera) + String.fromCharCode(65 + segunda);
    }
  }
  /// Verifica si dos cartas forman pareja con delay visual
  void _verificarParejaConDelay() {
    intentos++;
    
    // Usar Queue para obtener cartas en orden FIFO
    ModeloCarta primera = cartasVolteadas.removeFirst();
    ModeloCarta segunda = cartasVolteadas.removeFirst();
    
    bool esPareja = primera.valor == segunda.valor;
    if (esPareja) {
      _manejarAcierto(primera, segunda);
    } else {
      _manejarError(primera, segunda);
    }
  }

  /// Maneja cuando se encuentra una pareja correcta
  void _manejarAcierto(ModeloCarta primera, ModeloCarta segunda) {
    primera.estaEmparejada = true;
    segunda.estaEmparejada = true;
    paresEncontrados++;
    intentosCorrectos++;
    puntos += 10;
    
    //Agregar valor único encontrado al Set
    valoresUnicos.add(primera.valor);
    
    // Agregar movimiento al historial (Stack)
    historial.add(HistorialMovimiento(puntos, intentos, 'acierto'));
    
    bloqueado = false; // Desbloquear inmediatamente
    onUpdateUI?.call();
  }

  /// Maneja cuando se comete un error
  void _manejarError(ModeloCarta primera, ModeloCarta segunda) {
    intentosFallidos++;
    puntos = (puntos - 5).clamp(0, double.infinity).toInt();
    
    //Agregar movimiento al historial (Stack)
    historial.add(HistorialMovimiento(puntos, intentos, 'error'));
    
    // Delay para mostrar cartas antes de voltearlas de nuevo
    Future.delayed(const Duration(milliseconds: 1500), () {
      primera.estaVolteada = false;
      segunda.estaVolteada = false;
      bloqueado = false; // Desbloquear después del delay
      onUpdateUI?.call();
    });
  }

  // ==================== MÉTODOS DE CONSULTA ====================
  
  /// Obtiene el último movimiento del historial (comportamiento Stack)
  HistorialMovimiento? obtenerUltimoMovimiento() {
    return historial.isNotEmpty ? historial.last : null;
  }

  /// Genera estadísticas del juego usando las estructuras de datos
  Map<String, dynamic> obtenerEstadisticas() {
    return {
      'intentos': intentos,
      'intentosCorrectos': intentosCorrectos,
      'intentosFallidos': intentosFallidos,
      'puntos': puntos,
      'paresEncontrados': paresEncontrados,
      'totalPares': totalPares,
      'eficiencia': intentos > 0 ? (intentosCorrectos / intentos * 100).round() : 0,
      'valoresUnicos': valoresUnicos.length, // Tamaño del Set
      'totalMovimientos': historial.length, // Tamaño del Stack
      'cartasEnJuego': cartasVolteadas.length, // Tamaño de la Queue
    };
  }
}
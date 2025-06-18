import '../models/card_model.dart';
import 'dart:math';
import 'dart:collection';
import 'package:flutter/material.dart';

// Clase para el historial de movimientos usando Pila
class HistorialMovimiento {
  final int puntos;
  final int intentos;
  final String accion; //'acierto' o 'error'
  
  HistorialMovimiento(this.puntos, this.intentos, this.accion);
}

abstract class JuegoBase {
  void iniciarJuego();
  void reiniciarJuego();
  bool juegoTerminado();
}

class LogicaJuego extends JuegoBase {
  // Matriz 2D - Arreglo bidimensional
  List<List<ModeloCarta?>> matriz = [];
  
  // Variables de estado
  int intentos = 0;
  int intentosCorrectos = 0;
  int intentosFallidos = 0;
  int puntos = 0;
  int paresEncontrados = 0;
  int totalPares = 0;
  bool bloqueado = false; //Bloquear volteo durante verificación

  // Estructuras de datos específicas
  Queue<ModeloCarta> cartasVolteadas = Queue<ModeloCarta>(); //Cola FIFO
  List<HistorialMovimiento> historial = []; // Lista como Stack (Pila LIFO)
  Set<String> valoresUnicos = Set<String>(); // Conjunto para valores únicos

  VoidCallback? onUpdateUI;

  @override
  void iniciarJuego() => reiniciarJuego();

  // Función simple para generar letras hasta para (20x20)
  String _generarLetra(int numero) {
    if (numero < 26) {
      // A-Z
      return String.fromCharCode(65 + numero);
    } else if (numero < 52) {
      // a-z
      return String.fromCharCode(97 + (numero-26));
    } else if (numero < 62) {
      // 0-9
      return String.fromCharCode(48 + (numero-52));
    } else {
      // Para matrices muy grandes, combinaciones como AA, AB, etc.
      int primera = (numero - 62) ~/ 26;
      int segunda = (numero - 62) % 26;
      return String.fromCharCode(65 + primera) + String.fromCharCode(65 + segunda);
    }
  }

  // Generar matriz rectangular optimizada
  List<List<ModeloCarta?>> generarMatrizRectangular(int filas, int columnas) {
    int totalCartas = filas * columnas;
    if (totalCartas % 2 != 0) totalCartas--; // Asegurar número par
    
    totalPares = totalCartas ~/ 2;
    
    // Crear parejas usando Set para evitar duplicados
    Set<String> valoresSet = {};
    for (int i = 0; i < totalPares; i++) {
      String valor = _generarLetra(i); // Usar nueva función
      valoresSet.add(valor);
    }
    
    // Convertir Set a List y duplicar para parejas
    List<String> valores = [];
    valoresSet.forEach((valor) {
      valores.add(valor);
      valores.add(valor);
    });
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

  // Voltear carta con bloqueo mejorado
  bool voltearCarta(int fila, int columna) {
    // Verificaciones usando operadores lógicos
    if (bloqueado || 
        matriz[fila][columna] == null || 
        cartasVolteadas.length >= 2) return false;
    
    ModeloCarta carta = matriz[fila][columna]!;
    if (carta.estaVolteada || carta.estaEmparejada) return false;
    
    // Voltear carta y agregar a cola
    carta.estaVolteada = true;
    cartasVolteadas.add(carta);
    
    // Si hay 2 cartas, verificar pareja
    if (cartasVolteadas.length == 2) {
      bloqueado = true; //Bloquear más volteos
      _verificarParejaConDelay();
    }
    
    return true;
  }

  // Verificar pareja con delay optimizado
  void _verificarParejaConDelay() {
    intentos++;
    
    // Usar Queue para obtener cartas en orden FIFO
    ModeloCarta primera = cartasVolteadas.removeFirst();
    ModeloCarta segunda = cartasVolteadas.removeFirst();
    
    bool esPareja = primera.valor == segunda.valor;
    
    if (esPareja) {
      // Pareja correcta
      primera.estaEmparejada = true;
      segunda.estaEmparejada = true;
      paresEncontrados++;
      intentosCorrectos++;
      puntos += 10;
      
      //Agregar a Set de valores únicos encontrados
      valoresUnicos.add(primera.valor);
      
      // Agregar a historial (Stack)
      historial.add(HistorialMovimiento(puntos, intentos, 'acierto'));
      bloqueado = false; // Desbloquear inmediatamente
      onUpdateUI?.call();
      
    } else {
      // Pareja incorrecta
      intentosFallidos++;
      puntos = (puntos - 5).clamp(0, double.infinity).toInt();
      
      // Agregar a historial (Stack)
      historial.add(HistorialMovimiento(puntos, intentos, 'error'));
      
      // Delay para mostrar cartas antes de voltear
      Future.delayed(Duration(milliseconds: 1500), () {
        primera.estaVolteada = false;
        segunda.estaVolteada = false;
        bloqueado = false; //Desbloquear después del delay
        onUpdateUI?.call();
      });
    }
  }

  @override
  bool juegoTerminado() => paresEncontrados == totalPares;

  @override
  void reiniciarJuego() {
    // Limpiar todas las estructuras de datos
    matriz.clear();
    cartasVolteadas.clear(); // Cola
    historial.clear(); //Stack/Lista
    valoresUnicos.clear(); // Set
    
    // Resetear variables
    intentos = intentosCorrectos = intentosFallidos = 0;
    puntos = paresEncontrados = totalPares = 0;
    bloqueado = false;
  }

  // Obtener último movimiento del historial (Stack behavior)
  HistorialMovimiento? obtenerUltimoMovimiento() {
    return historial.isNotEmpty ? historial.last : null;
  }

  //Estadísticas usando las estructuras de datos
  Map<String, dynamic> obtenerEstadisticas() {
    return {
      'intentos': intentos,
      'intentosCorrectos': intentosCorrectos,
      'intentosFallidos': intentosFallidos,
      'puntos': puntos,
      'paresEncontrados': paresEncontrados,
      'totalPares': totalPares,
      'eficiencia': intentos > 0 ? (intentosCorrectos / intentos * 100).round() : 0,
      'valoresUnicos': valoresUnicos.length, // Set size
      'totalMovimientos': historial.length, //Stack size
      'cartasEnJuego': cartasVolteadas.length, //Queue size
    };
  }
}
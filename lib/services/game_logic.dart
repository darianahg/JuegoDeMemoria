import '../models/card_model.dart';
import 'dart:math';

class LogicaJuego {
  List<List<ModeloCarta>> matriz = [];
  int intentos = 0;
  int puntos = 0;
  int paresEncontrados = 0;
  int totalPares = 0;
  
  List<ModeloCarta> cartasVolteadas = [];
  
  //genera la matriz con parejas
  List<List<ModeloCarta>> generarMatriz(int filas, int columnas) {
    totalPares = (filas * columnas) ~/ 2;
    
    //Crear lista de valores para las parejas
    List<String> valores = [];
    for (int i = 0; i < totalPares; i++) {
      String valor = String.fromCharCode(65 + i); //letras A, B, C, ...
      valores.add(valor);
      valores.add(valor); //agregar la pareja
    }
    
    // Mezclar los valores
    valores.shuffle(Random());
    
    // Crear la matriz
    matriz = [];
    int contador = 0;
    
    for (int i = 0; i < filas; i++) {
      List<ModeloCarta> fila = [];
      for (int j=0; j < columnas; j++) {
        fila.add(ModeloCarta(
          id: contador,
          valor: valores[contador],
        ));
        contador++;
      }
      matriz.add(fila);
    }
    return matriz;
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
  
  // Verificar si hay pareja
  void verificarPareja() {
    intentos++;
  
    if (cartasVolteadas[0].valor == cartasVolteadas[1].valor) {
      //Es pareja correcta
      cartasVolteadas[0].estaEmparejada = true;
      cartasVolteadas[1].estaEmparejada = true;
      paresEncontrados++;
      puntos += 10;
    } else {
      //pareja incorrecta - voltear después de un tiempo
      Future.delayed(Duration(milliseconds: 1000), () {
        cartasVolteadas[0].estaVolteada = false;
        cartasVolteadas[1].estaVolteada = false;
      });
    }
    
    cartasVolteadas.clear();
  }
  
  //verificar si el juego terminó
  bool juegoTerminado() {
    return paresEncontrados == totalPares;
  }
  
  //reiniciar juego
  void reiniciarJuego() {
    matriz.clear();
    intentos = 0;
    puntos = 0;
    paresEncontrados = 0;
    cartasVolteadas.clear();
  }
}
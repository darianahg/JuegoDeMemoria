import 'package:flutter/material.dart';
import 'game_screen.dart';
import '../UX/styles.dart';

class PantallaInicio extends StatefulWidget {
  @override
  _PantallaInicioState createState() => _PantallaInicioState();
}
class _PantallaInicioState extends State<PantallaInicio> {
  int filas = 2;
  int columnas = 2;
  String nombreJugador = "";
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EstilosApp.colorFondo,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Juego de Memoria",
                style: EstilosApp.tituloGrande,
              ),
              SizedBox(height: 30),
                //Campo nombre
              TextField(
                decoration: InputDecoration(
                  labelText: "Tu nombre",
                  border: OutlineInputBorder(),
                  hintText: "Ingresa tu nombre aquí",
                ),
                onChanged: (valor) {
                  nombreJugador = valor;
                },
              ),
              SizedBox(height: 20),
              
              //Selector de filas
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Filas: ", style: EstilosApp.textoNormal),
                  DropdownButton<int>(
                    value: filas,
                    items: [2, 3, 4].map((int valor) {
                      return DropdownMenuItem<int>(
                        value: valor,
                        child: Text(valor.toString()),
                      );
                    }).toList(),
                    onChanged: (int? nuevoValor) {
                      setState(() {
                        filas = nuevoValor!;
                      });
                    },
                  ),
                ],
              ),
              
              // Selector de columnas
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Columnas: ", style: EstilosApp.textoNormal),
                  DropdownButton<int>(
                    value: columnas,
                    items: [2, 3, 4].map((int valor) {
                      return DropdownMenuItem<int>(
                        value: valor,
                        child: Text(valor.toString()),
                      );
                    }).toList(),
                    onChanged: (int? nuevoValor) {
                      setState(() {
                        columnas = nuevoValor!;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 30),
                //Botón iniciar
              ElevatedButton(
                onPressed: () {
                  if (nombreJugador.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Por favor ingresa tu nombre')),
                    );
                    return;
                  }
                  
                  // Validar que el número de cartas sea par
                  if ((filas * columnas) % 2 != 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('El número total de cartas debe ser par')),
                    );
                    return;
                  }
                  
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PantallaJuego(
                        filas: filas,
                        columnas: columnas,
                        nombreJugador: nombreJugador.trim(),
                      ),
                    ),
                  );
                },
                style: EstilosApp.botonPrincipal,
                child: Text("Iniciar Juego", style: EstilosApp.textoBoton),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../services/score_service.dart';
import '../UX/styles.dart';
import 'welcome_screen.dart';

class PantallaResultados extends StatelessWidget {
  final int puntos;
  final int intentos;
  final String nombreJugador;
  
  PantallaResultados({
    required this.puntos,
    required this.intentos, 
    required this.nombreJugador,
  });
  
  @override
  Widget build(BuildContext context) {
    int puntajeFinal = ServicioPuntaje.calcularPuntajeFinal(puntos, intentos);
    
    return Scaffold(
      backgroundColor: EstilosApp.colorFondo,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("¡Felicidades!!", style: EstilosApp.tituloGrande),
              SizedBox(height: 20),
              
              Text("$nombreJugador", style: EstilosApp.tituloMedio),
              SizedBox(height: 30),
              
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Text("Estadísticas:", style: EstilosApp.textoDestacado),
                    SizedBox(height: 10),
                    Text("Intentos: $intentos", style: EstilosApp.textoNormal),
                    Text("Puntos base: $puntos", style: EstilosApp.textoNormal),
                    Text("Puntaje final: $puntajeFinal", style: EstilosApp.textoDestacado),
                  ],
                ),
              ),
              
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => PantallaInicio()),
                    (route) => false,
                  );
                },
                style: EstilosApp.botonPrincipal,
                child: Text("Jugar de Nuevo", style: EstilosApp.textoBoton),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart'; // <-- Importa confetti
import '../services/score_service.dart';
import '../UX/styles.dart';
import 'welcome_screen.dart';

class PantallaResultados extends StatefulWidget {
  final int puntos;
  final int intentos;
  final String nombreJugador;

  const PantallaResultados({
    super.key,
    required this.puntos,
    required this.intentos,
    required this.nombreJugador,
  });

  @override
  State<PantallaResultados> createState() => _PantallaResultadosState();
}

class _PantallaResultadosState extends State<PantallaResultados> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
    _confettiController.play(); // Inicia la animación al cargar la pantalla
  }

  @override
  void dispose() {
    _confettiController.dispose(); // Libera recursos del controlador
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int puntajeFinal =
        ServicioPuntaje.calcularPuntajeFinal(widget.puntos, widget.intentos);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF0B0F2B), // Azul muy oscuro
                  Color(0xFF0D1B4C), // Azul oscuro medio
                  Color(0xFF123572), // Azul profundo final
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Center(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 450),
                  child: Container(
                    padding: const EdgeInsets.all(30),
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 23, 14, 63)
                          .withOpacity(0.95),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 12,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("¡Felicidades!", style: EstilosApp.tituloGrande),
                        const SizedBox(height: 20),
                        Text(widget.nombreJugador,
                            style: EstilosApp.tituloMedio),
                        const SizedBox(height: 30),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 19, 24, 68),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Text("Estadísticas:",
                                  style: EstilosApp.textoDestacado),
                              const SizedBox(height: 10),
                              Text("Intentos: ${widget.intentos}",
                                  style: EstilosApp.textoNormal),
                              Text("Puntos base: ${widget.puntos}",
                                  style: EstilosApp.textoNormal),
                              Text("Puntaje final: $puntajeFinal",
                                  style: EstilosApp.textoDestacado),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const PantallaInicio()),
                                (route) => false,
                              );
                            },
                            style: EstilosApp.botonPrincipal,
                            child: Text("Jugar de Nuevo",
                                style: EstilosApp.textoBoton),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Aquí agregamos el widget Confetti
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality:
                  BlastDirectionality.explosive, // explota en todas direcciones
              shouldLoop: false, // solo una vez
              colors: const [
                Colors.red,
                Colors.blue,
                Colors.yellow,
                Colors.green,
                Colors.orange,
                Colors.purple
              ],
              emissionFrequency: 0.05,
              numberOfParticles: 20,
              gravity: 0.1,
              maxBlastForce: 20,
              minBlastForce: 5,
            ),
          ),
        ],
      ),
    );
  }
}

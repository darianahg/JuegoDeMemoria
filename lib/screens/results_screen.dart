import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import '../services/score_service.dart';
import '../UX/styles.dart';
import 'welcome_screen.dart';

class PantallaResultados extends StatefulWidget {
  final int puntos;
  final int intentos;
  final int intentosCorrectos;
  final int intentosFallidos;
  final String nombreJugador;

  const PantallaResultados({
    super.key,
    required this.puntos,
    required this.intentos,
    required this.intentosCorrectos,
    required this.intentosFallidos,
    required this.nombreJugador,
  });

  @override
  State<PantallaResultados> createState() => _PantallaResultadosState();
}

class _PantallaResultadosState extends State<PantallaResultados> {
  late ConfettiController _confettiController;
  bool _puntajeGuardado = false;
  bool _esNuevoRecord = false;
  String _mensajeGuardado = "Verificando puntaje...";

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    _verificarYGuardarPuntaje();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _verificarYGuardarPuntaje() async {
    // Verificar si es nuevo récord
    bool esRecord = await ServicioPuntaje.esNuevoRecord(widget.puntos);
    
    setState(() {
      _esNuevoRecord = esRecord;
    });

    if (esRecord) {
      _confettiController.play(); // Solo confetti si es record
    }
    
    // Guardar puntaje
    bool guardado = await ServicioPuntaje.guardarPuntaje(
      widget.nombreJugador, 
      widget.puntos
    );
    
    setState(() {
      _puntajeGuardado = true;
      if (esRecord) {
        _mensajeGuardado = "¡NUEVO RÉCORD! Puntaje guardado";
      } else {
        _mensajeGuardado = "Puntaje registrado correctamente";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    int puntajeFinal = widget.puntos;
    double eficiencia = widget.intentos > 0 
        ? (widget.intentosCorrectos / widget.intentos * 100) 
        : 0;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF0B0F2B),
                  Color(0xFF0D1B4C),
                  Color(0xFF123572),
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
                        Text(
                          _esNuevoRecord ? "¡NUEVO RÉCORD!" : "¡Juego Terminado!",
                          style: EstilosApp.tituloGrande.copyWith(
                            color: _esNuevoRecord ? Colors.amber : Colors.white,
                            fontSize: _esNuevoRecord ? 32 : 28,
                          ),
                        ),
                        const SizedBox(height: 10),
                        
                        if (_esNuevoRecord)
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.amber.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.amber, width: 2),
                            ),
                            child: const Text(
                              "¡Felicidades! Has establecido un nuevo récord",
                              style: TextStyle(
                                color: Colors.amber,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        
                        const SizedBox(height: 20),
                        Text(widget.nombreJugador, style: EstilosApp.tituloMedio),
                        const SizedBox(height: 30),
                        
                        // Resumen de estadísticas
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 19, 24, 68),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Text("Resumen del Juego:", 
                                  style: EstilosApp.textoDestacado),
                              const SizedBox(height: 15),
                              
                              _construirFilaEstadistica("Intentos totales:", "${widget.intentos}"),
                              _construirFilaEstadistica("Aciertos:", "${widget.intentosCorrectos}"),
                              _construirFilaEstadistica("Errores:", "${widget.intentosFallidos}"),
                              _construirFilaEstadistica("Eficiencia:", "${eficiencia.toStringAsFixed(1)}%"),
                              
                              const Divider(color: Colors.white24, height: 20),
                              
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("🏆 Puntaje Final:", 
                                      style: EstilosApp.textoDestacado.copyWith(
                                        fontSize: 18,
                                        color: Colors.amber
                                      )),
                                  Text("$puntajeFinal pts", 
                                      style: EstilosApp.textoDestacado.copyWith(
                                        fontSize: 20,
                                        color: Colors.amber
                                      )),
                                ],
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // Estado de guardado
                        Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: _puntajeGuardado 
                                ? (_esNuevoRecord ? Colors.amber.withOpacity(0.2) : Colors.green.withOpacity(0.2))
                                : Colors.blue.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _puntajeGuardado 
                                  ? (_esNuevoRecord ? Colors.amber : Colors.green)
                                  : Colors.blue,
                              width: 1
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _puntajeGuardado 
                                    ? (_esNuevoRecord ? Icons.star : Icons.check_circle)
                                    : Icons.hourglass_empty,
                                color: _puntajeGuardado 
                                    ? (_esNuevoRecord ? Colors.amber : Colors.green)
                                    : Colors.blue,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  _mensajeGuardado,
                                  style: TextStyle(
                                    color: _puntajeGuardado 
                                        ? (_esNuevoRecord ? Colors.amber : Colors.green)
                                        : Colors.blue,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
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
                                    builder: (context) => const PantallaInicio()),
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
          
          // Confetti solo para nuevos récords
          if (_esNuevoRecord)
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                colors: const [
                  Colors.amber,
                  Colors.yellow,
                  Colors.orange,
                  Colors.red,
                  Colors.blue,
                  Colors.green
                ],
                emissionFrequency: 0.05,
                numberOfParticles: 30,
                gravity: 0.1,
                maxBlastForce: 25,
                minBlastForce: 8,
              ),
            ),
        ],
      ),
    );
  }
  Widget _construirFilaEstadistica(String etiqueta, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(etiqueta, style: EstilosApp.textoNormal),
          Text(valor, style: EstilosApp.textoNormal.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white
          )),
        ],
      ),
    );
  }
}
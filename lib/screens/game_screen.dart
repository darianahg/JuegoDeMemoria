import 'package:flutter/material.dart';
import '../services/game_logic.dart';
import '../widgets/card_widget.dart';
import '../UX/styles.dart';
import 'results_screen.dart';

class PantallaJuego extends StatefulWidget {
  final int filas;
  final int columnas;
  final String nombreJugador;

  const PantallaJuego({
    super.key,
    required this.filas,
    required this.columnas,
    required this.nombreJugador,
  });

  @override
  _PantallaJuegoState createState() => _PantallaJuegoState();
}

class _PantallaJuegoState extends State<PantallaJuego> {
  LogicaJuego logica = LogicaJuego();
  bool mostrarError = false;

  @override
  void initState() {
    super.initState();
    logica.generarMatrizRectangular(widget.filas, widget.columnas);
    logica.onUpdateUI = () {
      if (mounted) setState(() {});
    };
  }

  @override
  void dispose() {
    logica.onUpdateUI = null;
    super.dispose();
  }

  void alPresionarCarta(int fila, int columna) {
    setState(() {
      int intentosFallidosAntes = logica.intentosFallidos;
      bool pudoVoltear = logica.voltearCarta(fila, columna);

      if (pudoVoltear) {
        // Verificar si el juego terminó
        if (logica.juegoTerminado()) {
          Future.delayed(const Duration(milliseconds: 500), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => PantallaResultados(
                  puntos: logica.puntos,
                  intentos: logica.intentos,
                  intentosCorrectos: logica.intentosCorrectos,
                  intentosFallidos: logica.intentosFallidos,
                  nombreJugador: widget.nombreJugador,
                ),
              ),
            );
          });
        }

        // Mostrar emoji de error si falló
        if (logica.intentosFallidos > intentosFallidosAntes) {
          _mostrarEmojiError();
        }
      }
    });
  }

  void _mostrarEmojiError() {
    mostrarError = true;
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => mostrarError = false);
    });
  }

  Widget _construirEstadisticas() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 19, 24, 68),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("Intentos: ${logica.intentos}", style: EstilosApp.textoNormal),
              Text("Puntos: ${logica.puntos}", style: EstilosApp.textoNormal),
              Text("Pares: ${logica.paresEncontrados}/${logica.totalPares}", style: EstilosApp.textoNormal),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("✓ Correctos: ${logica.intentosCorrectos}",
                   style: const TextStyle(color: Colors.green, fontSize: 14)),
              Text("✗ Fallidos: ${logica.intentosFallidos}",
                   style: const TextStyle(color: Colors.red, fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }

  //Función simple para calcular tamaño de carta según dimensión
  double _calcularSizeCarta() {
    if (widget.columnas <= 6) return 1.0;
    if (widget.columnas <= 10) return 0.8;
    if (widget.columnas <= 15) return 0.6;
    return 0.5; // Para matrices muy grandes
  }

  Widget _construirGrilla() {
    final esGrande = widget.columnas > 10;
    final esMuyGrande = widget.columnas > 15;
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.columnas,
        crossAxisSpacing: esGrande ? 2 : 6, //Menos espacio para matrices grandes
        mainAxisSpacing: esGrande ? 2 : 6,
        childAspectRatio: _calcularSizeCarta(), //Cartas más pequeñas para matrices grandes
      ),
      itemCount: widget.filas * widget.columnas,
      itemBuilder: (context, index) {
        int fila = index ~/ widget.columnas;
        int columna = index % widget.columnas;
        
        // Si no hay carta, mostrar celda vacía
        if (logica.matriz[fila][columna] == null) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(esGrande ? 4 : 8),
              border: Border.all(color: Colors.grey.withOpacity(0.5)),
            ),
            child: Center(
              child: Icon(
                Icons.block, 
                color: Colors.grey, 
                size: esMuyGrande ? 12 : 20, //Iconos más pequeños
              ),
            ),
          );
        }
        
        return WidgetCarta(
          carta: logica.matriz[fila][columna]!,
          alPresionar: () => alPresionarCarta(fila, columna),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VOLVER'),
        backgroundColor: const Color(0xFF123572),
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Tooltip(
            message: 'Volver',
            child: Material(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => Navigator.pop(context),
                child: const SizedBox(
                  width: 36, height: 36,
                  child: Icon(Icons.arrow_back_ios_new, size: 20, color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0B0F2B), Color(0xFF0D1B4C), Color(0xFF123572)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Center(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 23, 14, 63).withOpacity(0.95),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 12, offset: Offset(0, 8))],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("¡Hola ${widget.nombreJugador}!", style: EstilosApp.tituloMedio),
                        const SizedBox(height: 20),
                        _construirEstadisticas(),
                        const SizedBox(height: 20),
                        _construirGrilla(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          //Emoji animado para errores
          AnimatedOpacity(
            opacity: mostrarError ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: mostrarError
                ? Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.all(40),
                      child: const Text("😡", style: TextStyle(fontSize: 80)),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
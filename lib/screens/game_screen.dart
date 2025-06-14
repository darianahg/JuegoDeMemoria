import 'package:flutter/material.dart';
import '../services/game_logic.dart';
import '../widgets/card_widget.dart';
import '../UX/styles.dart';
import 'results_screen.dart';

class PantallaJuego extends StatefulWidget {
  final int filas;
  final int columnas;
  final String nombreJugador;

  PantallaJuego({
    required this.filas,
    required this.columnas,
    required this.nombreJugador,
  });

  @override
  _PantallaJuegoState createState() => _PantallaJuegoState();
}

class _PantallaJuegoState extends State<PantallaJuego> {
  LogicaJuego logica = LogicaJuego();
  @override
  void initState() {
    super.initState();
    logica.generarMatriz(widget.filas, widget.columnas);
    // Configurar el callback para actualizar la UI
    logica.onUpdateUI = () {
      if (mounted) {
        setState(() {});
      }
    };
  }

  @override
  void dispose() {
    logica.onUpdateUI = null;
    super.dispose();
  }

  void alPresionarCarta(int fila, int columna) {
    setState(() {
      bool pudoVoltear = logica.voltearCarta(fila, columna);

      if (pudoVoltear && logica.juegoTerminado()) {
        //Navegar a pantalla de resultados después de un breve delay
        Future.delayed(Duration(milliseconds: 500), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => PantallaResultados(
                puntos: logica.puntos,
                intentos: logica.intentos,
                nombreJugador: widget.nombreJugador,
              ),
            ),
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EstilosApp.colorFondo,
      appBar: AppBar(
        title: Text("Hola ${widget.nombreJugador}!"),
        backgroundColor: EstilosApp.colorPrimario,
      ),
      body: Column(
        children: [
          // Estadísticas mejoradas
          Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("Intentos: ${logica.intentos}",
                        style: EstilosApp.textoNormal),
                    Text("Puntos: ${logica.puntos}",
                        style: EstilosApp.textoNormal),
                    Text(
                        "Pares: ${logica.paresEncontrados}/${logica.totalPares}",
                        style: EstilosApp.textoNormal),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("✓ Correctos: ${logica.intentosCorrectos}",
                        style: TextStyle(color: Colors.green, fontSize: 14)),
                    Text("✗ Fallidos: ${logica.intentosFallidos}",
                        style: TextStyle(color: Colors.red, fontSize: 14)),
                  ],
                ),
              ],
            ),
          ),

          //Tablero
          Expanded(
            child: Center(
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: widget.columnas,
                  childAspectRatio: 1.0,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 4.0,
                ),
                itemCount: widget.filas * widget.columnas,
                itemBuilder: (context, index) {
                  int fila = index ~/ widget.columnas;
                  int columna = index % widget.columnas;

                  return WidgetCarta(
                    carta: logica.matriz[fila][columna],
                    alPresionar: () => alPresionarCarta(fila, columna),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

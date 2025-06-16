import 'package:flutter/material.dart';
import 'game_screen.dart';
import '../UX/styles.dart';

class PantallaInicio extends StatefulWidget {
  const PantallaInicio({super.key});

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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0B0C28), // Azul casi negro
              Color(0xFF102542), // Azul muy oscuro
              Color(0xFF1B3358), // Azul oscuro intermedio
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 450),
              child: Container(
                padding: const EdgeInsets.all(30),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color:
                      const Color.fromARGB(255, 23, 14, 63).withOpacity(0.95),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
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
                    const SizedBox(height: 20),
                    Text(
                      "🧠 Juego de Memoria",
                      style: EstilosApp.tituloGrande.copyWith(
                        fontSize: 28,
                        color: Colors.blue[100],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 25),
                    TextField(
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "Tu nombre",
                        hintText: "Ingresa tu nombre aquí",
                        filled: true,
                        fillColor: const Color.fromARGB(255, 19, 24, 68),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        labelStyle: const TextStyle(color: Colors.white70),
                        hintStyle: const TextStyle(color: Colors.white54),
                      ),
                      onChanged: (valor) {
                        nombreJugador = valor;
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Filas: ",
                            style: EstilosApp.textoNormal
                                .copyWith(color: Colors.white)),
                        const SizedBox(width: 10),
                        DropdownButton<int>(
                          value: filas,
                          borderRadius: BorderRadius.circular(10),
                          dropdownColor: const Color.fromARGB(255, 34, 53, 85),
                          style: const TextStyle(color: Colors.white),
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
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Columnas: ",
                            style: EstilosApp.textoNormal
                                .copyWith(color: Colors.white)),
                        const SizedBox(width: 10),
                        DropdownButton<int>(
                          value: columnas,
                          borderRadius: BorderRadius.circular(10),
                          dropdownColor: const Color.fromARGB(255, 34, 53, 85),
                          style: const TextStyle(color: Colors.white),
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
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (nombreJugador.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Por favor ingresa tu nombre')),
                            );
                            return;
                          }
                          if ((filas * columnas) % 2 != 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'El número total de cartas debe ser par')),
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
                        child: Text(
                          "Iniciar Juego",
                          style: EstilosApp.textoBoton.copyWith(fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

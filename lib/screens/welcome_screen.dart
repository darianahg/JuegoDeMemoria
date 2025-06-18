import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'game_screen.dart';
import '../UX/styles.dart';
import '../services/score_service.dart';

class PantallaInicio extends StatefulWidget {
  const PantallaInicio({super.key});

  @override
  _PantallaInicioState createState() => _PantallaInicioState();
}

class _PantallaInicioState extends State<PantallaInicio> {
  int dimension = 4;
  String nombreJugador = "";
  String textoCompleto = "Cargando información...";
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    cargarInformacion();
  }

  void cargarInformacion() async {
    setState(() {
      cargando = true;
      textoCompleto = "Cargando información...";
    });

    try {
      await Future.delayed(const Duration(milliseconds: 300));
      await ServicioPuntaje.mostrarContenidoArchivo();
      String info = await ServicioPuntaje.obtenerTextoCompleto();
      
      setState(() {
        textoCompleto = info;
        cargando = false;
      });
      
      print('Información cargada: $info');
    } catch (e) {
      print('Error cargando información: $e');
      setState(() {
        textoCompleto = "Error cargando información";
        cargando = false;
      });
    }
  }

  void _mostrarDialog(String titulo, String contenido, List<Widget> acciones) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 23, 14, 63),
        title: Text(titulo, style: const TextStyle(color: Colors.white)),
        content: Text(contenido, style: const TextStyle(color: Colors.white70)),
        actions: acciones,
      ),
    );
  }

  void _mostrarConfirmacionSalir() {
    _mostrarDialog('¿Salir del juego?', '¿Estás seguro de que quieres cerrar el juego?', [
      TextButton(
        child: const Text('Cancelar'),
        onPressed: () => Navigator.of(context).pop(),
      ),
      ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
        child: const Text('Salir', style: TextStyle(color: Colors.white)),
        onPressed: () => SystemNavigator.pop(),
      ),
    ]);
  }

  void _mostrarMenuDebug() {
    _mostrarDialog('Opciones de Debug', '¿Qué quieres hacer?', [
      TextButton(
        child: const Text('Ver Archivo'),
        onPressed: () async {
          Navigator.of(context).pop();
          await ServicioPuntaje.mostrarContenidoArchivo();
        },
      ),
      TextButton(
        child: const Text('Limpiar Datos'),
        onPressed: () async {
          Navigator.of(context).pop();
          await ServicioPuntaje.limpiarDatos();
          cargarInformacion();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Datos limpiados')),
          );
        },
      ),
      TextButton(
        child: const Text('Cancelar'),
        onPressed: () => Navigator.of(context).pop(),
      ),
    ]);
  }

  // Calcular información de la matriz
  String _obtenerInfoMatriz(int dim) {
    int totalCeldas = dim * dim;
    int cartasJugables = totalCeldas % 2 == 0 ? totalCeldas : totalCeldas - 1;
    return "${dim}x$dim ($cartasJugables cartas)";
  }

  // Lista de tamaños disponibles
  List<int> get _tamanosDisponibles => [
    for (int i = 3; i <= 8; i++) i, // Tamaños pequeños
    10, 12, 15, // Tamaños medianos
    17, 18, 20, // Tamaños grandes
  ];

  Widget _construirInfoPuntajes() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 19, 24, 68),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber, width: 1),
      ),
      child: cargando 
        ? const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 16, height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                ),
              ),
              SizedBox(width: 10),
              Text("Cargando...", style: TextStyle(color: Colors.amber, fontSize: 14)),
            ],
          )
        : Column(
            children: [
              Text(
                textoCompleto,
                style: const TextStyle(color: Colors.amber, fontSize: 14, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: cargarInformacion,
                child: const Text(
                  "Actualizar",
                  style: TextStyle(color: Colors.blue, fontSize: 12, decoration: TextDecoration.underline),
                ),
              ),
            ],
          ),
    );
  }

  Widget _construirSelectorTamano() {
    return Column(
      children: [
        Text(
          "Tamaño: ${_obtenerInfoMatriz(dimension)}",
          style: EstilosApp.textoNormal.copyWith(color: Colors.white),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 19, 24, 68),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButton<int>(
            value: dimension,
            isExpanded: true,
            borderRadius: BorderRadius.circular(10),
            dropdownColor: const Color.fromARGB(255, 34, 53, 85),
            style: const TextStyle(color: Colors.white),
            underline: Container(),
            items: _tamanosDisponibles.map((valor) => 
              DropdownMenuItem<int>(
                value: valor,
                child: Text(_obtenerInfoMatriz(valor)),
              )
            ).toList(),
            onChanged: (nuevoValor) => setState(() => dimension = nuevoValor!),
          ),
        ),
      ],
    );
  }

  Widget _construirBoton(String texto, VoidCallback onPressed, {Color? color, bool outline = false}) {
    return SizedBox(
      width: double.infinity,
      child: outline 
        ? TextButton(
            onPressed: onPressed,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: color ?? Colors.red, width: 1),
              ),
            ),
            child: Text(texto, style: TextStyle(fontSize: 16, color: color ?? Colors.red)),
          )
        : ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: color ?? Colors.blue,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(
              texto,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0B0C28), Color(0xFF102542), Color(0xFF1B3358)],
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
                  color: const Color.fromARGB(255, 23, 14, 63).withOpacity(0.95),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 12, offset: Offset(0, 8))],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 20),
                    
                    //Título con botón debug
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "Juego de Memoria",
                            style: EstilosApp.tituloGrande.copyWith(
                              fontSize: 28, color: Colors.blue[100], fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: _mostrarMenuDebug,
                          child: const Icon(Icons.settings, color: Colors.white54, size: 20),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    
                    //Información de puntajes
                    _construirInfoPuntajes(),
                    const SizedBox(height: 25),
                    
                    // Campo de nombre
                    TextField(
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "Tu nombre",
                        hintText: "Ingresa tu nombre aquí",
                        filled: true,
                        fillColor: const Color.fromARGB(255, 19, 24, 68),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        labelStyle: const TextStyle(color: Colors.white70),
                        hintStyle: const TextStyle(color: Colors.white54),
                      ),
                      onChanged: (valor) => nombreJugador = valor,
                    ),
                    const SizedBox(height: 20),
                    
                    // Selector de tamaño
                    _construirSelectorTamano(),
                    const SizedBox(height: 20),
                    
                    // Sistema de puntuación
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 19, 24, 68),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Text("Sistema de Puntuación:", style: EstilosApp.textoDestacado),
                          const SizedBox(height: 8),
                          Text(
                            "✓ Acierto: +10 puntos\n✗ Error: -5 puntos\n Puntaje mínimo: 0",
                            style: EstilosApp.textoNormal.copyWith(fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    
                    // Botón Iniciar Juego
                    _construirBoton("Iniciar Juego", () async {
                      if (nombreJugador.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Por favor ingresa tu nombre')),
                        );
                        return;
                      }
                      
                      print('Iniciando juego con: ${nombreJugador.trim()}');
                      
                      // Navegar al juego
                      final resultado = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PantallaJuego(
                            filas: dimension,
                            columnas: dimension,
                            nombreJugador: nombreJugador.trim(),
                          ),
                        ),
                      );
                      
                      // Recargar información cuando regrese del juego
                      if (resultado != null) cargarInformacion();
                    }),
                    const SizedBox(height: 15),
                    
                    // Botón Salir
                    _construirBoton("Salir", _mostrarConfirmacionSalir, color: Colors.red, outline: true),
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
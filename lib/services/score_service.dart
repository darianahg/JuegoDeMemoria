import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

class ServicioPuntaje {
  static const String _nombreArchivo = 'puntajes_juego.txt';

  // Obtener la ruta del archivo
  static Future<String> _obtenerRutaArchivo() async {
    try {
      final directorio = await getApplicationDocumentsDirectory();
      final ruta = '${directorio.path}/$_nombreArchivo';
      print('Ruta archivo: $ruta'); //debug
      return ruta;
    } catch (e) {
      print('Error obteniendo ruta: $e');
      rethrow;
    }
  }

  // Leer datos del archivo
  static Future<Map<String, dynamic>> _leerDatos() async {
    try {
      final rutaArchivo = await _obtenerRutaArchivo();
      final archivo = File(rutaArchivo);
      
      if (!await archivo.exists()) {
        print('Archivo no existe, creando datos vacíos');
        return {};
      }
      
      String contenido = await archivo.readAsString();
      print('Contenido leído: $contenido'); // Debug
      
      if (contenido.trim().isEmpty) {
        print('Archivo vacío');
        return {};
      }
      
      return jsonDecode(contenido);
    } catch (e) {
      print('Error leyendo datos: $e');
      return {};
    }
  }

  // Escribir datos al archivo
  static Future<bool> _escribirDatos(Map<String, dynamic> datos) async {
    try {
      final rutaArchivo = await _obtenerRutaArchivo();
      final archivo = File(rutaArchivo);
      
      // Crear directorio si no existe
      await archivo.parent.create(recursive: true);
      String jsonString = jsonEncode(datos);
      await archivo.writeAsString(jsonString);
      
      print('Datos guardados: $jsonString'); // Debug
      return true;
    } catch (e) {
      print('Error escribiendo datos: $e');
      return false;
    }
  }

  // Guardar puntaje
  static Future<bool> guardarPuntaje(String nombre, int puntaje) async {
    try {
      // Leer datos existentes
      Map<String, dynamic> datos = await _leerDatos();
      
      // Actualizar último jugador
      datos['ultimo_jugador'] = nombre;
      datos['ultimo_puntaje'] = puntaje;
      
      //verificar y actualizar récord
      int recordActual = datos['record_puntaje'] ?? 0;
      if (puntaje > recordActual) {
        datos['record_jugador'] = nombre;
        datos['record_puntaje'] = puntaje;
        datos['record_fecha'] = DateTime.now().toIso8601String();
        print('¡Nuevo récord establecido! $nombre con $puntaje puntos');
      }
      
      // Guardar datos
      return await _escribirDatos(datos);
    } catch (e) {
      print('Error guardando puntaje: $e');
      return false;
    }
  }

  //Obtener último jugador
  static Future<Map<String, dynamic>?> obtenerUltimoJugador() async {
    try {
      Map<String, dynamic> datos = await _leerDatos();
      
      String? nombre = datos['ultimo_jugador'];
      int? puntaje = datos['ultimo_puntaje'];
      
      if (nombre == null || puntaje == null) {
        print('No hay último jugador registrado');
        return null;
      }
      
      return {
        'nombre': nombre,
        'puntaje': puntaje,
      };
    } catch (e) {
      print('Error obteniendo último jugador: $e');
      return null;
    }
  }

  // Obtener récord
  static Future<Map<String, dynamic>?> obtenerRecord() async {
    try {
      Map<String, dynamic> datos = await _leerDatos();
      
      String? nombre = datos['record_jugador'];
      int? puntaje = datos['record_puntaje'];
      String? fecha = datos['record_fecha'];
      
      if (nombre == null || puntaje == null) {
        print('No hay récord registrado');
        return null;
      }
      
      return {
        'nombre': nombre,
        'puntaje': puntaje,
        'fecha': fecha ?? DateTime.now().toIso8601String(),
      };
    } catch (e) {
      print('Error obteniendo récord: $e');
      return null;
    }
  }

  // Verificar si es nuevo récord
  static Future<bool> esNuevoRecord(int puntaje) async {
    try {
      final record = await obtenerRecord();
      if (record == null) {
        print('No hay récord previo, este será el primero');
        return true;
      }
      bool esNuevo = puntaje > record['puntaje'];
      print('¿Es nuevo récord? $esNuevo (Actual: $puntaje vs Récord: ${record['puntaje']})');
      return esNuevo;
    } catch (e) {
      print('Error verificando récord: $e');
      return true;
    }
  }

  // Obtener texto para mostrar en pantalla principal
  static Future<String> obtenerTextoCompleto() async {
    try {
      final ultimo = await obtenerUltimoJugador();
      final record = await obtenerRecord();
      
      String texto = "";
      
      // Último jugador
      if (ultimo != null) {
        texto += "🎮 Último: ${ultimo['nombre']} (${ultimo['puntaje']} pts)\n";
      } else {
        texto += "🎮 Primer juego\n";
      }
      
      // Récord
      if (record != null) {
        texto += "🏆 Récord: ${record['nombre']} - ${record['puntaje']} pts";
        
        try {
          DateTime fecha = DateTime.parse(record['fecha']);
          texto += "\n📅 ${fecha.day}/${fecha.month}/${fecha.year}";
        } catch (e) {
          print('Error formateando fecha: $e');
        }
      } else {
        texto += "🏆 ¡Establece el primer récord!";
      }
      
      return texto.trim();
    } catch (e) {
      print('Error obteniendo texto completo: $e');
      return "Error cargando información";
    }
  }

  // Método de debug para ver el contenido del archivo
  static Future<void> mostrarContenidoArchivo() async {
    try {
      final rutaArchivo = await _obtenerRutaArchivo();
      final archivo = File(rutaArchivo);
      
      print('=== DEBUG ARCHIVO ===');
      print('Ruta: $rutaArchivo');
      print('Existe: ${await archivo.exists()}');
      
      if (await archivo.exists()) {
        String contenido = await archivo.readAsString();
        print('Contenido: $contenido');
        print('Tamaño: ${contenido.length} caracteres');
      } else {
        print('El archivo no existe aún');
      }
      print('===================');
    } catch (e) {
      print('Error en debug: $e');
    }
  }

  // Método para limpiar datos
  static Future<bool> limpiarDatos() async {
    try {
      final rutaArchivo = await _obtenerRutaArchivo();
      final archivo = File(rutaArchivo);
      
      if (await archivo.exists()) {
        await archivo.delete();
        print('Archivo eliminado para limpiar datos');
      }
      return true;
    } catch (e) {
      print('Error limpiando datos: $e');
      return false;
    }
  }
}
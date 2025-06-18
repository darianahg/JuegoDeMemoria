import 'package:shared_preferences/shared_preferences.dart';

/// Servicio para manejar puntajes y récords del juego
class ServicioPuntaje {
  
  // ==================== CONSTANTES ====================
  
  /// Claves para SharedPreferences
  static const String _keyUltimoJugador = 'ultimo_jugador';
  static const String _keyUltimoPuntaje = 'ultimo_puntaje';
  static const String _keyRecordJugador = 'record_jugador';
  static const String _keyRecordPuntaje = 'record_puntaje';
  static const String _keyRecordFecha = 'record_fecha';

  // ==================== MÉTODOS PRIVADOS ====================
  /// Obtiene instancia de SharedPreferences con manejo de errores
  static Future<SharedPreferences> _getPrefs() async {
    try {
      return await SharedPreferences.getInstance();
    } catch (e) {
      print('Error obteniendo SharedPreferences: $e');
      rethrow;
    }
  }

  /// Valida que los datos de entrada sean correctos
  static bool _validarDatos(String nombre, int puntaje) {
    if (nombre.trim().isEmpty) {
      print('Error: nombre vacío');
      return false;
    }
    
    if (puntaje < 0) {
      print('Error: puntaje negativo');
      return false;
    }
    
    return true;
  }

  // ==================== MÉTODOS PRINCIPALES ====================
  
  /// Guarda un puntaje y actualiza récord si es necesario
  static Future<bool> guardarPuntaje(String nombre, int puntaje) async {
    try {
      // Validar datos de entrada
      if (!_validarDatos(nombre, puntaje)) return false;
      
      print('Guardando puntaje: $nombre = $puntaje puntos');
      
      final prefs = await _getPrefs();
      final nombreLimpio = nombre.trim();
      
      // Actualizar último jugador
      await prefs.setString(_keyUltimoJugador, nombreLimpio);
      await prefs.setInt(_keyUltimoPuntaje, puntaje);
      
      // Verificar y actualizar récord si es necesario
      await _actualizarRecordSiEsNecesario(prefs, nombreLimpio, puntaje);
      
      print('Puntaje guardado exitosamente');
      return true;
      
    } catch (e) {
      print('Error guardando puntaje: $e');
      return false;
    }
  }

  /// Obtiene información del último jugador
  static Future<Map<String, dynamic>?> obtenerUltimoJugador() async {
    try {
      final prefs = await _getPrefs();
      
      String? nombre = prefs.getString(_keyUltimoJugador);
      int? puntaje = prefs.getInt(_keyUltimoPuntaje);
      
      if (nombre == null || puntaje == null) {
        print('No hay último jugador registrado');
        return null;
      }
      
      return {'nombre': nombre, 'puntaje': puntaje};
      
    } catch (e) {
      print('Error obteniendo último jugador: $e');
      return null;
    }
  }
  /// Obtiene información del récord actual
  static Future<Map<String, dynamic>?> obtenerRecord() async {
    try {
      final prefs = await _getPrefs();
      
      String? nombre = prefs.getString(_keyRecordJugador);
      int? puntaje = prefs.getInt(_keyRecordPuntaje);
      String? fecha = prefs.getString(_keyRecordFecha);
      
      if (nombre == null || puntaje == null || puntaje == 0) {
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
  /// Verifica si un puntaje es un nuevo récord
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
      return true; //En caso de error, asume que es récord
    }
  }
  /// Obtiene texto completo para mostrar en pantalla principal
  static Future<String> obtenerTextoCompleto() async {
    try {
      final ultimo = await obtenerUltimoJugador();
      final record = await obtenerRecord();
      
      String texto = _construirTextoUltimoJugador(ultimo);
      texto += _construirTextoRecord(record);
      
      return texto.trim();
      
    } catch (e) {
      print('Error obteniendo texto completo: $e');
      return "🎮 ¡Bienvenido al juego!\n🏆 ¡Establece el primer récord!";
    }
  }
  // ==================== MÉTODOS AUXILIARES ====================
  
  /// Actualiza el récord si el puntaje actual es mayor
  static Future<void> _actualizarRecordSiEsNecesario(
      SharedPreferences prefs, String nombre, int puntaje) async {
    
    int recordActual = prefs.getInt(_keyRecordPuntaje) ?? 0;
    
    if (puntaje > recordActual) {
      await prefs.setString(_keyRecordJugador, nombre);
      await prefs.setInt(_keyRecordPuntaje, puntaje);
      await prefs.setString(_keyRecordFecha, DateTime.now().toIso8601String());
      print('¡Nuevo récord establecido! $nombre con $puntaje puntos');
    }
  }

  /// Construye el texto para mostrar el último jugador
  static String _construirTextoUltimoJugador(Map<String, dynamic>? ultimo) {
    if (ultimo != null) {
      return "🎮 Último: ${ultimo['nombre']} (${ultimo['puntaje']} pts)\n";
    } else {
      return "🎮 Primer juego\n";
    }
  }

  /// Construye el texto para mostrar el récord
  static String _construirTextoRecord(Map<String, dynamic>? record) {
    if (record != null) {
      String texto = "🏆 Récord: ${record['nombre']} - ${record['puntaje']} pts";
      
      // Agregar fecha si es posible
      try {
        DateTime fecha = DateTime.parse(record['fecha']);
        texto += "\n📅 ${fecha.day}/${fecha.month}/${fecha.year}";
      } catch (e) {
        print('Error formateando fecha: $e');
        // No agregar fecha si hay error
      }
      
      return texto;
    } else {
      return "🏆 ¡Establece el primer récord!";
    }
  }

  // ==================== MÉTODOS UTILITARIOS ====================
  
  /// Verifica si hay datos guardados previamente
  static Future<bool> hayDatosGuardados() async {
    try {
      final prefs = await _getPrefs();
      return prefs.containsKey(_keyUltimoJugador) || 
             prefs.containsKey(_keyRecordJugador);
    } catch (e) {
      print('Error verificando datos: $e');
      return false;
    }
  }

  /// Limpia todos los datos guardados (útil para resetear)
  static Future<bool> limpiarDatos() async {
    try {
      final prefs = await _getPrefs();
      
      await prefs.remove(_keyUltimoJugador);
      await prefs.remove(_keyUltimoPuntaje);
      await prefs.remove(_keyRecordJugador);
      await prefs.remove(_keyRecordPuntaje);
      await prefs.remove(_keyRecordFecha);
      
      print('Datos limpiados correctamente');
      return true;
    } catch (e) {
      print('Error limpiando datos: $e');
      return false;
    }
  }

  /// Muestra contenido de SharedPreferences para debug
  static Future<void> mostrarContenidoArchivo() async {
    try {
      final prefs = await _getPrefs();
      
      print('=== DEBUG SHARED PREFERENCES ===');
      print('Último jugador: ${prefs.getString(_keyUltimoJugador)}');
      print('Último puntaje: ${prefs.getInt(_keyUltimoPuntaje)}');
      print('Récord jugador: ${prefs.getString(_keyRecordJugador)}');
      print('Récord puntaje: ${prefs.getInt(_keyRecordPuntaje)}');
      print('Récord fecha: ${prefs.getString(_keyRecordFecha)}');
      print('Todas las claves: ${prefs.getKeys()}');
      print('===============================');
    } catch (e) {
      print('Error en debug: $e');
    }
  }
}
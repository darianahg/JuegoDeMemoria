
class ServicioPuntaje {
  static int calcularPuntajeFinal(int puntos, int intentos) {
    //puntos base menos penalización por intentos extras
    int puntajeFinal=puntos - (intentos * 2);
    return puntajeFinal > 0 ? puntajeFinal : 0;
  }
  
  static String obtenerCalificacion(int puntajeFinal, int totalPares) {
    double porcentaje = (puntajeFinal/(totalPares * 10)) * 100;
    
    if (porcentaje >= 80) return "¡Excelente!";
    if (porcentaje >= 60) return "¡Muy bien!";
    if (porcentaje >= 40) return "Bien";
    return "Puedes mejorar ;)";
  }
}

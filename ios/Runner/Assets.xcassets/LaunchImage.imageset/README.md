# Juego de Memoria - Flutter

Este proyecto es un juego de memoria tipo "Parejas" desarrollado en Flutter. El objetivo es encontrar las cartas que coinciden dentro de una matriz.

---

## Estructura del proyecto

- **lib/main.dart**  
  Punto de entrada principal de la aplicación.

- **lib/models/**  
  Contiene modelos de datos.  
  - `card_model.dart`: representa cada carta del juego con sus propiedades.

- **lib/services/**  
  Lógica y servicios del juego.  
  - `game_logic.dart`: reglas del juego, manejo de parejas, intentos y puntos.  
  - `score_service.dart`: manejo de puntuaciones, suma y resta de puntos.

- **lib/screens/**  
  Pantallas de la aplicación.  
  - `welcome_screen.dart`: pantalla de bienvenida.  
  - `game_screen.dart`: pantalla principal con la matriz y las cartas.  
  - `results_screen.dart`: pantalla final con estadísticas.

- **lib/widgets/**  
  Componentes visuales reutilizables.  
  - `card_widget.dart`: widget para mostrar cada carta.

- **lib/UX/**  
  Todo lo relacionado con diseño y estilos.  
  - `styles.dart`: definición de temas y estilos de la app.

---

## Cómo ejecutar el proyecto

1. Clonar el repositorio:  
   `git clone https://github.com/tu_usuario/nombre_repositorio.git`

2. Entrar en la carpeta del proyecto:  
   `cd nombre_repositorio`

3. Descargar las dependencias:  
   `flutter pub get`

4. Correr la app:  
   `flutter run`

---

## Participantes y responsabilidades

- **Participante 1:** Lógica del juego (`game_logic.dart`)  
- **Participante 2:** Pantallas y UI (`screens/`)  
- **Participante 3:** Manejo de archivos y récords

---

## Estado actual

- Funcionalidad básica del juego implementada.  
- Pendientes mejoras en UI y animaciones.  
- Sistema de puntajes en desarrollo.

---

## Notas

- Variables y métodos están en español. 
- *IMPORTANTE* Se recomienda trabajar en ramas separadas para evitar conflictos.


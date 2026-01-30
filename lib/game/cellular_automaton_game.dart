import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';

enum GamePhase { player1, player2 }

/// Clase de lógica del juego sin dependencias de Flame.
/// Ahora es un ChangeNotifier puro para integración con Provider.
class CellularAutomatonGame extends ChangeNotifier {
  static const int gridSize = 20;

  late Color cellColorAlivePlayer1;
  late Color cellColorAlivePlayer2;
  final Color cellColorDead = const Color(0xFF000000);
  final bool showDivider;

  CellularAutomatonGame({this.showDivider = false}) {
    resetGameState();
  }

  late List<List<int>> gameState; // 0: muerta, 1: Jugador 1, 2: Jugador 2
  late List<List<int>> newGameState;
  bool pauseExec = true;
  bool allowEditing = true;
  int iteration = 0;
  int population = 0;

  // Variables para controlar el bloqueo de los lados
  bool isRightSideLocked = true;
  bool isLeftSideLocked = true;

  // Contadores para los jugadores
  int player1Counter = 25;
  int player2Counter = 25;

  // Fase actual del juego (multiplayer)
  GamePhase currentPhase = GamePhase.player1;

  // Contadores de empates
  int empatesAsignadosJ1 = 0;
  int empatesAsignadosJ2 = 0;

  // --- TRACKING DE ESTADÍSTICAS ---
  // Estas métricas se utilizan para el Leaderboard.

  /// Máxima población observada. Se actualiza en cada paso de la simulación.
  int maxPopulation = 0;
  /// Mínima población observada. Se inicializa con las fichas iniciales y se rastrea.
  int minPopulation = 0;
  /// Fichas capturadas justo antes de que se procese la primera generación.
  int initialFichas = 0;
  /// Cronómetros para medir el tiempo real de juego de cada jugador.
  final Stopwatch _playStopwatchJ1 = Stopwatch();
  final Stopwatch _playStopwatchJ2 = Stopwatch();

  // Timer para auto-simulación
  Timer? _simulationTimer;

  void resetGameState() {
    gameState = List.generate(gridSize, (_) => List.filled(gridSize, 0));
    newGameState = List.generate(gridSize, (_) => List.filled(gridSize, 0));
    _generateRandomAliveColors();
    pauseExec = true;
    allowEditing = true;
    iteration = 0;
    population = 0;
    player1Counter = 25;
    player2Counter = 25;
    currentPhase = GamePhase.player1;
    // Reiniciar estadísticas para una nueva partida
    maxPopulation = 0;
    minPopulation = 0;
    initialFichas = 0;
    player1AliveTime = 0;
    player2AliveTime = 0;
    
    _playStopwatchJ1.stop();
    _playStopwatchJ1.reset();
    _playStopwatchJ2.stop();
    _playStopwatchJ2.reset();
    
    notifyListeners();
  }

  // Alive time tracking
  int player1AliveTime = 0;
  int player2AliveTime = 0;

  void startSimulation() {
    pauseExec = false;
    allowEditing = false;
    
    // Capturar fichas iniciales si es el comienzo real de la partida (iteración 0)
    if (iteration == 0) {
      initialFichas = countPlayerCells(1) + countPlayerCells(2);
      maxPopulation = initialFichas;
      minPopulation = initialFichas;
    }
    
    // Iniciar o reanudar el tiempo de juego
    if (countPlayerCells(1) > 0) _playStopwatchJ1.start();
    if (countPlayerCells(2) > 0) _playStopwatchJ2.start();
    notifyListeners();
  }

  /// Genera colores Neón ultra-vibrantes con tonos eléctricos
  /// Usa paleta curada de hues neón para colores más impactantes
  void _generateRandomAliveColors() {
    final random = Random();
    
    // Paleta de hues neón eléctricos
    final neonHues = [
      180.0, // Cian eléctrico
      160.0, // Turquesa neón
      120.0, // Verde lima brillante
      90.0,  // Verde-amarillo neón
      300.0, // Magenta intenso
      330.0, // Rosa neón
      270.0, // Violeta eléctrico
      240.0, // Azul neón
      30.0,  // Naranja brillante
      0.0,   // Rojo neón
    ];
    
    // Seleccionar primer hue
    final hue1 = neonHues[random.nextInt(neonHues.length)];
    
    // Filtrar para el segundo hue: debe haber una distancia mínima de 60 grados
    final validHuesForPlayer2 = neonHues.where((h2) {
      final diff = (hue1 - h2).abs();
      final circularDiff = diff > 180 ? 360 - diff : diff;
      return circularDiff >= 60;
    }).toList();

    // Si por alguna razón no hay colores válidos (no debería pasar con esta lista), usamos un fallback
    final hue2 = validHuesForPlayer2.isNotEmpty 
        ? validHuesForPlayer2[random.nextInt(validHuesForPlayer2.length)]
        : (hue1 + 180) % 360;
    
    // Saturation MUY ALTA (0.9-1.0) para colores ultra-saturados
    // Value ALTO (0.85-1.0) para máximo brillo
    cellColorAlivePlayer1 = HSVColor.fromAHSV(
      1.0,
      hue1,
      0.90 + (random.nextDouble() * 0.10), // Saturation: 90-100%
      0.85 + (random.nextDouble() * 0.15)  // Value: 85-100%
    ).toColor();

    cellColorAlivePlayer2 = HSVColor.fromAHSV(
      1.0,
      hue2,
      0.90 + (random.nextDouble() * 0.10),
      0.85 + (random.nextDouble() * 0.15)
    ).toColor();
  }

  /// Inicia el timer de simulación automática
  /// Intervalo reducido para animación más dinámica y fluida
  void startAutoSimulation() {
    _simulationTimer?.cancel();
    _simulationTimer = Timer.periodic(const Duration(milliseconds: 60), (timer) {
      if (!pauseExec) {
        applyRules();
        population = gameState.expand((row) => row).where((cell) => cell != 0).length;
        if (population > 0) {
          // Add alive time logic
          if (countPlayerCells(1) > 0) player1AliveTime++;
          if (countPlayerCells(2) > 0) player2AliveTime++;
        }
        
        // Actualizar estadísticas de población
        if (population > maxPopulation) maxPopulation = population;
        if (population < minPopulation || minPopulation == 0) minPopulation = population;

        if (population == 0) {
          pauseExec = true;
          _playStopwatchJ1.stop();
          _playStopwatchJ2.stop();
          timer.cancel();
        } else {
          // Detener cronómetros individuales si la población llega a 0
          if (countPlayerCells(1) == 0) _playStopwatchJ1.stop();
          if (countPlayerCells(2) == 0) _playStopwatchJ2.stop();
        }
        notifyListeners();
      } else {
        _playStopwatchJ1.stop();
        _playStopwatchJ2.stop();
        timer.cancel();
      }
    });
  }

  /// Detiene el timer de simulación
  void stopAutoSimulation() {
    _simulationTimer?.cancel();
    _playStopwatchJ1.stop();
    _playStopwatchJ2.stop();
    pauseExec = true;
    notifyListeners();
  }

  Duration get currentPlayTime => _playStopwatchJ1.elapsed;
  Duration getPlayerPlayTime(int player) {
    return player == 1 ? _playStopwatchJ1.elapsed : _playStopwatchJ2.elapsed;
  }
  
  bool isPlayerStopwatchRunning(int player) {
    return player == 1 ? _playStopwatchJ1.isRunning : _playStopwatchJ2.isRunning;
  }
  int get currentFinalFichas => countPlayerCells(1) + countPlayerCells(2);

  // Modificar applyRules() para contar empates
  void applyRules() {
    final random = Random();
    for (var x = 0; x < gridSize; x++) {
      for (var y = 0; y < gridSize; y++) {
        final neighbors = countNeighbors(x, y);
        newGameState[x][y] = gameState[x][y];

        if (gameState[x][y] != 0) {
          newGameState[x][y] = (neighbors == 2 || neighbors == 3) ? gameState[x][y] : 0;
        } else {
          if (neighbors == 3) {
            final p1Neighbors = countPlayerNeighbors(x, y, 1);
            final p2Neighbors = countPlayerNeighbors(x, y, 2);

            if (p1Neighbors == p2Neighbors) {
              final asignacion = random.nextBool() ? 1 : 2;
              newGameState[x][y] = asignacion;
              // Contar asignaciones
              if (asignacion == 1) empatesAsignadosJ1++;
              else empatesAsignadosJ2++;
            } else {
              newGameState[x][y] = p1Neighbors > p2Neighbors ? 1 : 2;
            }
          }
        }
      }
    }
    gameState = newGameState.map((row) => List<int>.from(row)).toList();
    iteration++;
  }

  int countNeighbors(int x, int y) {
    var count = 0;
    for (var i = -1; i <= 1; i++) {
      for (var j = -1; j <= 1; j++) {
        if (i == 0 && j == 0) continue;
        final nx = (x + i + gridSize) % gridSize;
        final ny = (y + j + gridSize) % gridSize;
        if (gameState[nx][ny] != 0) count++;
      }
    }
    return count;
  }

  int countPlayerNeighbors(int x, int y, int player) {
    var count = 0;
    for (var i = -1; i <= 1; i++) {
      for (var j = -1; j <= 1; j++) {
        if (i == 0 && j == 0) continue;
        final nx = (x + i + gridSize) % gridSize;
        final ny = (y + j + gridSize) % gridSize;
        if (gameState[nx][ny] == player) count++;
      }
    }
    return count;
  }

  int countPlayerCells(int player) {
    int count = 0;
    for (var x = 0; x < gridSize; x++) {
      for (var y = 0; y < gridSize; y++) {
        if (gameState[x][y] == player) {
          count++;
        }
      }
    }
    return count;
  }

  void unlockRightSide() {
    isRightSideLocked = false;
  }

  void unlockLeftSide() {
    isLeftSideLocked = false;
  }

  void setupEmpateForzado() {
    // Configuración para forzar empate
    gameState = List.generate(gridSize, (_) => List.filled(gridSize, 0));
    
    // Crear patrón simétrico que genere empate
    gameState[9][9] = 1;
    gameState[9][10] = 1;
    gameState[10][9] = 2;
    gameState[10][10] = 2;
    
    gameState[8][9] = 1;
    gameState[11][10] = 2;
    
    notifyListeners();
  }

  void simular100Empates() {
    // Simular 100 generaciones para acumular empates
    for (int i = 0; i < 100; i++) {
      applyRules();
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _simulationTimer?.cancel();
    super.dispose();
  }
}

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flutter/services.dart';

enum GamePhase { player1, player2 }


class CellularAutomatonGame extends FlameGame with TapCallbacks, DragCallbacks, KeyboardEvents {
  static const int gridSize = 20;

  late Color cellColorAlivePlayer1; // Color para el Jugador 1
  late Color cellColorAlivePlayer2; // Color para el Jugador 2
  final Color cellColorDead = const Color(0xFF000000);
  final Color borderColor = const Color(0xFF606060);
  final bool showDivider;

  CellularAutomatonGame({this.showDivider = false});

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


  @override
  Future<void> onLoad() async {
    super.onLoad();
    resetGameState();
  }

  void resetGameState() {
    gameState = List.generate(gridSize, (_) => List.filled(gridSize, 0)); // 0: muerta
    newGameState = List.generate(gridSize, (_) => List.filled(gridSize, 0)); // 0: muerta
    _generateRandomAliveColors(); // Generar colores para ambos jugadores
    pauseExec = true;
    allowEditing = true;
    population = 0;
    iteration = 0;

    // Desbloquear los lados correspondientes al inicio
    isLeftSideLocked = false;  // Jugador 1 puede colocar en la parte izquierda
    isRightSideLocked = true;  // Bloquear la parte derecha para el Jugador 1

    // Reiniciar la fase del juego
    currentPhase = GamePhase.player1;

    // Reiniciar los contadores de los jugadores
    player1Counter = 25.clamp(0, 25); // 0 ≤ player1Counter ≤ 25
    player2Counter = 25.clamp(0, 25); // 0 ≤ player2Counter ≤ 25

      }

  void startSimulation() {
    pauseExec = false;
    allowEditing = false;
    isLeftSideLocked = false;  // Desbloquear ambos lados durante la simulación
    isRightSideLocked = false;
    }

  void _generateRandomAliveColors() {
    final random = Random();
    cellColorAlivePlayer1 = Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
    cellColorAlivePlayer2 = Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (!pauseExec) {
      population = gameState.expand((row) => row).where((cell) => cell != 0).length;
      if (population == 0) pauseExec = true;
      applyRules();
    }
  }



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
  }

  int countNeighbors(int x, int y) {
    var count = 0;
    for (var i = -1; i <= 1; i++) {
      for (var j = -1; j <= 1; j++) {
        if (i == 0 && j == 0) continue; // Ignorar la celda actual
        final nx = (x + i + gridSize) % gridSize; // Manejar bordes (tablero toroidal)
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
        if (i == 0 && j == 0) continue; // Ignorar la celda actual
        final nx = (x + i + gridSize) % gridSize; // Manejar bordes (tablero toroidal)
        final ny = (y + j + gridSize) % gridSize;
        if (gameState[nx][ny] == player) count++;
      }
    }
    return count;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final cellSize = size.x / gridSize;

    // Dibujar las celdas
    for (var x = 0; x < gridSize; x++) {
      for (var y = 0; y < gridSize; y++) {
        final rect = Rect.fromLTWH(
          x * cellSize,
          y * cellSize,
          cellSize,
          cellSize,
        );

        // Determinar el color de la celda
        Color cellColor = cellColorDead; // Por defecto, celda muerta
        if (gameState[x][y] == 1) {
          cellColor = cellColorAlivePlayer1; // Jugador 1
        } else if (gameState[x][y] == 2) {
          cellColor = cellColorAlivePlayer2; // Jugador 2
        }

        // Dibujar célula
        canvas.drawRect(
          rect,
          Paint()
            ..color = cellColor
            ..style = PaintingStyle.fill,
        );

        // Dibujar borde
        canvas.drawRect(
          rect,
          Paint()
            ..color = borderColor
            ..style = PaintingStyle.stroke
            ..strokeWidth = 0.5,
        );
      }
    }

    // Dibujar la línea divisoria solo en el modo multijugador y dentro del tablero
    if (showDivider) {
      final centerX = size.x / 2; // Centro del tablero en el eje X
      final boardHeight = gridSize * cellSize; // Altura del tablero

      final linePaint = Paint()
        ..color = Colors.white // Color de la línea
        ..strokeWidth = 5.0; // Grosor de la línea

      canvas.drawLine(
        Offset(centerX, 0), // Punto inicial (parte superior del tablero)
        Offset(centerX, boardHeight), // Punto final (parte inferior del tablero)
        linePaint,
      );

      // Dibujar contadores solo en el modo multijugador
      final textStyle = TextStyle(color: Colors.white, fontSize: 24);

      if (!pauseExec) {
        // Fase de simulación: Mostrar contadores de población
        final population1 = _countPlayerCells(1); // Población del jugador 1
        final population2 = _countPlayerCells(2); // Población del jugador 2

        // Contador de población del jugador 1 (izquierda)
        final textSpan1 = TextSpan(text: 'Población 1: $population1', style: textStyle);
        final textPainter1 = TextPainter(text: textSpan1, textDirection: TextDirection.ltr);
        textPainter1.layout();

        final textX1 = 10.0; // Margen izquierdo
        final textY1 = gridSize * cellSize + 10.0; // Justo debajo del tablero

        if (textY1 < size.y) {
          textPainter1.paint(canvas, Offset(textX1, textY1)); // Posición del contador
        }

        // Contador de población del jugador 2 (derecha)
        final textSpan2 = TextSpan(text: 'Población 2: $population2', style: textStyle);
        final textPainter2 = TextPainter(text: textSpan2, textDirection: TextDirection.ltr);
        textPainter2.layout();

        final textX2 = size.x - textPainter2.width - 10.0; // Margen derecho
        final textY2 = gridSize * cellSize + 10.0; // Justo debajo del tablero

        if (textY2 < size.y) {
          textPainter2.paint(canvas, Offset(textX2, textY2)); // Posición del contador
        }
      } else {
        // Fase de colocación: Mostrar contadores de colocación (0 a 25)
        final textSpan1 = TextSpan(text: 'Jugador 1: ${_countPlayerCells(1)}/25', style: textStyle);
        final textPainter1 = TextPainter(text: textSpan1, textDirection: TextDirection.ltr);
        textPainter1.layout();

        final textX1 = 10.0; // Margen izquierdo
        final textY1 = gridSize * cellSize + 10.0; // Justo debajo del tablero

        if (textY1 < size.y) {
          textPainter1.paint(canvas, Offset(textX1, textY1)); // Posición del contador
        }

        final textSpan2 = TextSpan(text: 'Jugador 2: ${_countPlayerCells(2)}/25', style: textStyle);
        final textPainter2 = TextPainter(text: textSpan2, textDirection: TextDirection.ltr);
        textPainter2.layout();

        final textX2 = size.x - textPainter2.width - 10.0; // Margen derecho
        final textY2 = gridSize * cellSize + 10.0; // Justo debajo del tablero

        if (textY2 < size.y) {
          textPainter2.paint(canvas, Offset(textX2, textY2)); // Posición del contador
        }
      }
    }


  }

  int _countPlayerCells(int player) {
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

  @override
  void onTapDown(TapDownEvent event) {
    if (!allowEditing) return;
    final cellSize = size.x / gridSize;
    final position = event.localPosition;
    final x = (position.x / cellSize).floor();
    final y = (position.y / cellSize).floor();

    // Verificar si se hizo clic en el botón "Listo"
    if (pauseExec && position.y >= size.y - 100 && position.y <= size.y - 50) {
      if (position.x >= size.x / 2 - 50 && position.x <= size.x / 2 + 50) {
        if (currentPhase == GamePhase.player1) {
          // Pasar al Jugador 2
          currentPhase = GamePhase.player2;
          isLeftSideLocked = true;   // Bloquear la parte izquierda
          isRightSideLocked = false; // Desbloquear la parte derecha
                  } else if (currentPhase == GamePhase.player2) {
          // Iniciar la simulación
          startSimulation();
                  }
        return;
      }
    }

    // Lógica para colocar fichas
    if (x >= 0 && x < gridSize && y >= 0 && y < gridSize) {
      if (showDivider) {
        final middleX = gridSize ~/ 2;

        if (currentPhase == GamePhase.player1) {
          // Jugador 1: Solo puede colocar celdas en la parte izquierda
          if (x < middleX && (player1Counter > 0 || gameState[x][y] == 1)) {
            gameState[x][y] = gameState[x][y] == 1 ? 0 : 1; // Alternar entre muerta (0) y Jugador 1 (1)
            player1Counter += gameState[x][y] == 1 ? -1 : 1; // Actualizar el contador
          }
        } else if (currentPhase == GamePhase.player2) {
          // Jugador 2: Solo puede colocar celdas en la parte derecha
          if (x >= middleX && (player2Counter > 0 || gameState[x][y] == 2)) {
            gameState[x][y] = gameState[x][y] == 2 ? 0 : 2; // Alternar entre muerta (0) y Jugador 2 (2)
            player2Counter += gameState[x][y] == 2 ? -1 : 1; // Actualizar el contador
          }
        }
      } else {
        // Modo normal: Sin restricciones
        gameState[x][y] = gameState[x][y] == 1 ? 0 : 1; // Alternar entre muerta (0) y Jugador 1 (1)
      }
    }
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (!allowEditing) return; // No permitir interacción si el juego no está en modo de edición
    final cellSize = size.x / gridSize;
    final position = event.localPosition;
    final x = (position.x / cellSize).floor();
    final y = (position.y / cellSize).floor();

    if (x >= 0 && x < gridSize && y >= 0 && y < gridSize) {
      if (showDivider) {
        final middleX = gridSize ~/ 2;

        if (currentPhase == GamePhase.player1) {
          // Jugador 1: Solo puede colocar celdas en la parte izquierda
          if (x < middleX && player1Counter > 0 && gameState[x][y] == 0) {
            gameState[x][y] = 1; // Colocar celda del Jugador 1
            player1Counter -= 1; // Actualizar el contador
          }
        } else if (currentPhase == GamePhase.player2) {
          // Jugador 2: Solo puede colocar celdas en la parte derecha
          if (x >= middleX && player2Counter > 0 && gameState[x][y] == 0) {
            gameState[x][y] = 2; // Colocar celda del Jugador 2
            player2Counter -= 1; // Actualizar el contador
          }
        }
      } else {
        // Modo normal: Sin restricciones
        if (gameState[x][y] == 0) {
          gameState[x][y] = 1; // Colocar celda del Jugador 1
        }
      }
    }
  }

  // Método para desbloquear la parte derecha
  void unlockRightSide() {
    isRightSideLocked = false;
  }

  // Método para desbloquear la parte izquierda
  void unlockLeftSide() {
    isLeftSideLocked = false;
  }

  @override
  KeyEventResult onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event is KeyDownEvent) {
      if (keysPressed.contains(LogicalKeyboardKey.escape)) {
        SystemNavigator.pop();
      } else if (keysPressed.contains(LogicalKeyboardKey.keyR)) {
        resetGameState();
      }
    }
    return KeyEventResult.handled;
  }



  GamePhase currentPhase = GamePhase.player1; // Fase actual del juego

  int empatesAsignadosJ1 = 0;
  int empatesAsignadosJ2 = 0;

  // Método para forzar un escenario de empate
  void setupEmpateForzado() {
    gameState = List.generate(
      CellularAutomatonGame.gridSize,
          (_) => List.filled(CellularAutomatonGame.gridSize, 0),
    );

    // Celda muerta en posición (5,5)
    int x = 5, y = 5;

    // Colocar 2 vecinos del Jugador 1
    gameState[(x - 1) % CellularAutomatonGame.gridSize][y] = 1; // Arriba
    gameState[x][(y - 1) % CellularAutomatonGame.gridSize] = 1; // Izquierda

    // Colocar 1 vecino del Jugador 2
    gameState[(x + 1) % CellularAutomatonGame.gridSize][y] = 2; // Abajo
  }



  // Método para simular 100 empates
  void simular100Empates() {
    empatesAsignadosJ1 = 0;
    empatesAsignadosJ2 = 0;

    for (int i = 0; i < 100; i++) {
      resetGameState();     // Reiniciar tablero
      setupEmpateForzado(); // Forzar escenario de empate
      applyRules();         // Aplicar reglas
    }

     }
  }


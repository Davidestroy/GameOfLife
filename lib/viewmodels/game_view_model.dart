import 'package:flutter/material.dart';
import '../game/cellular_automaton_game.dart';
import '../screens/multiplayer_game.dart';
import '../game/game_manager.dart';
import '../models/leaderboard_entry.dart';
import '../services/leaderboard_service.dart';

class GameViewModel extends ChangeNotifier {
  final CellularAutomatonGame game;

  GameViewModel({required this.game}) {
    game.addListener(notifyListeners);
  }

  @override
  void dispose() {
    game.removeListener(notifyListeners);
    super.dispose();
  }

  // --- LÓGICA DE SIMULACIÓN ---

  // Lógica del botón Play/Pause
  Color get playButtonColor => game.pauseExec ? Colors.green : Colors.red;
  IconData get playButtonIcon => game.pauseExec ? Icons.play_arrow : Icons.pause;

  /// Lógica del botón Play/Pause.
  /// Si está pausado, inicia la simulación y el temporizador automático.
  /// Si está corriendo, detiene el temporizador.
  void onPlayPressed() {
    if (game.pauseExec) {
      game.startSimulation();
      game.startAutoSimulation();
    } else {
      game.stopAutoSimulation();
    }
    notifyListeners();
  }

  /// Lógica del botón Reiniciar.
  /// Registra las estadísticas actuales antes de limpiar el estado del juego.
  void onResetPressed() {
    _recordStats(); // Guardar resultados antes de limpiar
    game.resetGameState();
    notifyListeners();
  }

  /// Lógica para volver al menú principal.
  /// Asegura que se guarden los resultados y se limpie el tablero.
  void onExitPressed(BuildContext context) {
    _recordStats();
    game.resetGameState();
    Navigator.pop(context);
  }

  /// Registra y guarda las estadísticas de la partida actual en el almacenamiento persistente.
  /// Solo se guarda si hubo actividad (iteraciones > 0).
  void _recordStats() {
    if (game.iteration > 0) {
      // 1. Estructuración: Se crea un objeto LeaderboardEntry con las métricas del motor de juego.
      final entry = LeaderboardEntry(
        maxPopulation: game.maxPopulation,
        minPopulation: game.minPopulation,
        initialFichas: game.initialFichas,
        finalFichas: game.currentFinalFichas, // Fichas vivas en este instante
        playTime: game.currentPlayTime,       // Tiempo medido por el Stopwatch del juego
        date: DateTime.now(),
        gameMode: game.showDivider ? "Dos jugadores" : "Un jugador",
      );
      
      print('Estadísticas guardadas: ${entry.playTime.inSeconds}s, Max Pop: ${entry.maxPopulation}');
      
      // 2. Persistencia: Se usa el servicio para guardar el objeto en SharedPreferences.
      LeaderboardService.saveEntry(entry);
    }
  }

  // Lógica de Sonido
  bool _isSoundEnabled = true;
  bool get isSoundEnabled => _isSoundEnabled; 
  
  // Getters visuales para el sonido
  Color get soundButtonColor => _isSoundEnabled ? Colors.green : Colors.grey;
  IconData get soundButtonIcon => _isSoundEnabled ? Icons.volume_up : Icons.volume_off;

  // Lógica del color de Reiniciar
  Color get resetIconColor => activePlayerColor;
  
  // Mantenemos activePlayerColor para la lógica interna si es necesario, 
  // pero el botón Reset ahora usará un color aleatorio cada vez.
  Color get activePlayerColor {
    if (game.currentPhase == GamePhase.player1) {
      return game.cellColorAlivePlayer1;
    } else {
      return game.cellColorAlivePlayer2;
    }
  }

  void toggleSound() {
    _isSoundEnabled = !_isSoundEnabled;
    notifyListeners();
  }

  // Validaciones
  String? getSinglePlayerValidationError() {
    // Si no hay fichas (población = 0), no dejar iniciar
    // Nota: countPlayerCells(1) cuenta las fichas tipo 1.
    final count = game.countPlayerCells(1); 
    if (count == 0) {
      return "Debes poner fichas antes de iniciar.";
    }
    return null;
  }

  // Valida si se puede pasar de fase (Botón Listo)
  String? getMultiplayerPhaseError() {
    int remaining = 0;
    if (game.currentPhase == GamePhase.player1) {
      remaining = game.player1Counter;
    } else {
      remaining = game.player2Counter;
    }

    if (remaining > 0) {
      return remaining == 25 ? "Faltan 25 fichas." : "Faltan $remaining fichas.";
    }
    return null;
  }

  // Valida si se puede INICIAR el juego (Botón Play)
  String? getMultiplayerStartError() {
    // 1. Verificar Jugador 1
    if (game.player1Counter > 0) {
        // En teoría si estamos en fase 1 y le damos play, falta terminar la fase 1
        return "El Jugador 1 debe terminar de poner sus fichas.";
    }

    // 2. Verificar Jugador 2
    if (game.player2Counter == 25) {
       return "El Jugador 2 aún no ha puesto sus fichas.";
    } else if (game.player2Counter > 0) {
       return "Faltan ${game.player2Counter} fichas al Jugador 2.";
    }
    
    return null;
  }

  // Lógica del botón Multijugador
  // game_view_model.dart
  void onMultiplayerPressed(BuildContext context) {
    // Obtener la instancia Singleton de GameManager (no crear una nueva)
    final gameManager = GameManager();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MultiplayerGame(
          game: gameManager.getMultiplayerGame(), // Instancia dedicada del multiplayer
        ),
      ),
    );
  }

}
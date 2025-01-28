import 'package:flutter/material.dart';
import 'cellular_automaton_game.dart';
import 'multiplayer_game.dart'; // Importa MultiplayerGame

class GameViewModel extends ChangeNotifier {
  final CellularAutomatonGame game;

  GameViewModel({required this.game});

  // Lógica del botón Play/Pause
  Color get playButtonColor => game.pauseExec ? Colors.green : Colors.grey;

  void onPlayPressed() {
    if (game.pauseExec) {
      game.startSimulation();
    } else {
      game.pauseExec = true; // Pausar la simulación
    }
    notifyListeners(); // Notificar a la interfaz que el estado ha cambiado
  }

  // Lógica del botón Reiniciar
  void onResetPressed() {
    game.resetGameState();
    notifyListeners(); // Notificar a la interfaz que el estado ha cambiado
  }

  // Lógica del botón Multijugador
  void onMultiplayerPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MultiplayerGame(
          game: game,
        ),
      ),
    );
  }
}
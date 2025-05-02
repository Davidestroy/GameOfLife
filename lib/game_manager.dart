import 'cellular_automaton_game.dart'; // Para la clase CellularAutomatonGame
import 'singleplayer_game.dart'; // Para la clase SinglePlayerGame
import 'multiplayer_game.dart'; // Para la clase MultiplayerGame

class GameManager {
  static final GameManager _instance = GameManager._internal();
  late CellularAutomatonGame singlePlayerGame;
  late CellularAutomatonGame multiplayerGame;

  factory GameManager() => _instance;

  GameManager._internal() {
    singlePlayerGame = CellularAutomatonGame(showDivider: false);
    multiplayerGame = CellularAutomatonGame(showDivider: true);

    // Mejora: Reiniciar estados al inicializar
    singlePlayerGame.resetGameState();
    multiplayerGame.resetGameState();
  }

  CellularAutomatonGame getSinglePlayerGame() => singlePlayerGame;
  CellularAutomatonGame getMultiplayerGame() => multiplayerGame;

  SinglePlayerGame getSinglePlayerScreen() => SinglePlayerGame(game: singlePlayerGame);
  MultiplayerGame getMultiplayerScreen() => MultiplayerGame(game: multiplayerGame);
}
import 'cellular_automaton_game.dart';
import '../screens/singleplayer_game.dart';
import '../screens/multiplayer_game.dart';
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
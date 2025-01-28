import 'cellular_automaton_game.dart';

class GameManager {
  static final GameManager _instance = GameManager._internal();
  late CellularAutomatonGame singlePlayerGame;
  late CellularAutomatonGame multiplayerGame;

  factory GameManager() {
    return _instance;
  }

  GameManager._internal() {
    singlePlayerGame = CellularAutomatonGame(showDivider: false); // Modo de un solo jugador
    multiplayerGame = CellularAutomatonGame(showDivider: true); // Modo multijugador
  }

  CellularAutomatonGame getSinglePlayerGame() => singlePlayerGame;
  CellularAutomatonGame getMultiplayerGame() => multiplayerGame;
}
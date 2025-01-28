import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:provider/provider.dart'; // Importa el paquete provider
import 'cellular_automaton_game.dart';
import 'game_view_model.dart';
import 'game_manager.dart';
import 'multiplayer_game.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final gameManager = GameManager(); // Instancia del GameManager

    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 25, 25, 25),
        body: GameWidget<CellularAutomatonGame>(
          game: gameManager.getSinglePlayerGame(), // Usa el juego de un solo jugador
          overlayBuilderMap: {
            'controls': (context, game) => GameControls(
              game: game as CellularAutomatonGame,
              onMultiplayerPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MultiplayerGame(
                      game: gameManager.getMultiplayerGame(), // Pasa el juego de multijugador
                    ),
                  ),
                );
              },
            ),
          },
          initialActiveOverlays: const ['controls'],
        ),
      ),
    );
  }
}

class GameControls extends StatelessWidget {
  final CellularAutomatonGame game;
  final VoidCallback onMultiplayerPressed;

  const GameControls({
    super.key,
    required this.game,
    required this.onMultiplayerPressed,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = GameViewModel(game: game);

    return ChangeNotifierProvider(
      create: (_) => viewModel,
      child: Consumer<GameViewModel>(
        builder: (context, viewModel, child) {
          return Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _ControlButton(
                      icon: Icons.play_arrow,
                      color: viewModel.playButtonColor,
                      onPressed: viewModel.onPlayPressed,
                      size: 40,
                    ),
                    const SizedBox(width: 15),
                    _ControlButton(
                      icon: Icons.restart_alt,
                      color: Colors.blue,
                      onPressed: viewModel.onResetPressed,
                      size: 40,
                    ),
                    const SizedBox(width: 15),
                    _ControlButton(
                      icon: Icons.group,
                      color: Colors.orange,
                      onPressed: onMultiplayerPressed,
                      size: 40,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback? onPressed;
  final double size;

  const _ControlButton({
    required this.icon,
    required this.color,
    this.onPressed,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, color: Colors.white),
      iconSize: size,
      onPressed: onPressed,
      style: IconButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.all(10),
        shape: const CircleBorder(),
      ),
    );
  }
}
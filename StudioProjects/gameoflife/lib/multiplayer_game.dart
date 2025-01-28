import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:provider/provider.dart';
import 'cellular_automaton_game.dart';
import 'game_view_model.dart';

class MultiplayerGame extends StatelessWidget {
  final CellularAutomatonGame game;

  const MultiplayerGame({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final viewModel = GameViewModel(game: game);

    return ChangeNotifierProvider(
      create: (_) => viewModel,
      child: Scaffold(
        backgroundColor: const Color(0xFF1A1A1A),
        body: Stack(
          children: [
            GameWidget(game: game),
            Positioned(
              bottom: 100,
              left: 0,
              right: 0,
              child: Center(
                child: Consumer<GameViewModel>(
                  builder: (context, viewModel, child) {
                    return Container(
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
                            icon: Icons.person,
                            color: Colors.purple,
                            onPressed: () => Navigator.pop(context),
                            size: 40,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
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
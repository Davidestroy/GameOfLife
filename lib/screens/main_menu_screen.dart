import 'package:flutter/material.dart';
import '../game/game_manager.dart';

import 'singleplayer_game.dart';
import 'multiplayer_game.dart';
import 'instructions_screen.dart';
import 'leaderboard_screen.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameManager = GameManager();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 25, 25, 25),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'EL JUEGO DE LA VIDA',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 50),
            _MenuButton(
              label: 'Un jugador',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SinglePlayerGame(
                      game: gameManager.getSinglePlayerGame(),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            _MenuButton(
              label: 'Dos jugadores',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MultiplayerGame(
                      game: gameManager.getMultiplayerGame(),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            _MenuButton(
              label: 'Instrucciones',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const InstructionsScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            _MenuButton(
              label: 'Leaderboard',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LeaderboardScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _MenuButton({
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent, // Color consistente con el tema
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
      ),
    );
  }
}

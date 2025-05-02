import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:provider/provider.dart';
import 'cellular_automaton_game.dart';
import 'game_view_model.dart';
import 'base_game_controls.dart';
import 'control_button.dart';
import 'sliding_menu.dart'; // Importa el menú deslizante

class SinglePlayerGame extends StatelessWidget {
  final CellularAutomatonGame game;
  const SinglePlayerGame({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final viewModel = GameViewModel(game: game);

    return ChangeNotifierProvider(
      create: (_) => viewModel,
      child: Scaffold(
        backgroundColor: const Color(0xFF1A1A1A),
        body: Stack(
          children: [
            // 1. El tablero del juego (fondo)
            GameWidget(game: game),

            // 2. Menú deslizante (parte superior derecha)
            SlidingMenu(
              menuWidth: 200, // Ancho del menú
              menuItems: [
                // Ejemplo: Control de velocidad
                Row(

                ),
                // Ejemplo: Sonido
                SwitchListTile(
                  title: const Text("Sonido", style: TextStyle(color: Colors.white)),
                  value: true,
                  onChanged: (value) => print("Sonido: $value"), // Lógica del sonido
                ),
              ],
            ),

            // 3. Controles inferiores (play, reset, home)
            BaseGameControls(
              buttons: [
                ControlButton(
                  icon: Icons.play_arrow,
                  color: viewModel.playButtonColor,
                  onPressed: viewModel.onPlayPressed,
                  size: 40,
                ),
                const SizedBox(width: 15),
                ControlButton(
                  icon: Icons.restart_alt,
                  color: Colors.blue,
                  onPressed: viewModel.onResetPressed,
                  size: 40,
                ),
                const SizedBox(width: 15),
                ControlButton(
                  icon: Icons.home,
                  color: Colors.purple,
                  onPressed: () => Navigator.pop(context), // Volver al menú principal
                  size: 40,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
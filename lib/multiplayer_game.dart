import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:provider/provider.dart';
import 'cellular_automaton_game.dart';
import 'game_view_model.dart';
import 'base_game_controls.dart'; // Widget reutilizable
import 'control_button.dart';     // Botón reutilizable

class MultiplayerGame extends StatelessWidget {
  final CellularAutomatonGame game;
  const MultiplayerGame({super.key, required this.game});
  void _handleListoPressed(BuildContext context) {


    if (game.currentPhase == GamePhase.player1) {
      // Cambiar al Jugador 2
      game.currentPhase = GamePhase.player2;
      game.isLeftSideLocked = true;
      game.isRightSideLocked = false;
      game.allowEditing = true;

      // Notificar cambios (si usas ViewModel)
      final viewModel = Provider.of<GameViewModel>(context, listen: false);
      viewModel.notifyListeners();
    }
    else if (game.currentPhase == GamePhase.player2) {
      // Iniciar simulación
      final viewModel = Provider.of<GameViewModel>(context, listen: false);
      viewModel.onPlayPressed();
    }
  }
  @override
  Widget build(BuildContext context) {
    final viewModel = GameViewModel(game: game);

    return ChangeNotifierProvider.value(
      value: viewModel,
      child: Scaffold(
        backgroundColor: const Color(0xFF1A1A1A),
        body: Stack(
          children: [
            GameWidget(game: game),
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
                if (game.showDivider)
                  ControlButton(
                    icon: Icons.check,
                    color: Colors.green,
                    onPressed: () => _handleListoPressed(context),
                    size: 40,
                  ),
                const SizedBox(width: 15),
                ControlButton(
                  icon: Icons.arrow_back,
                  color: Colors.purple,
                  onPressed: () => Navigator.pop(context),
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



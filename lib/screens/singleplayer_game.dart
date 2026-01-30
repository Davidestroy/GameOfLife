import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../game/cellular_automaton_game.dart';
import '../viewmodels/game_view_model.dart';
import '../widgets/game_controls_bar.dart';
import '../widgets/control_button.dart';
import '../widgets/neon_grid_widget.dart';
import '../widgets/game_timer_widget.dart';


class SinglePlayerGame extends StatelessWidget {
  final CellularAutomatonGame game;
  const SinglePlayerGame({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GameViewModel(game: game),
        child: Scaffold(
          backgroundColor: const Color(0xFF1A1A1A),
          body: SafeArea(
            child: Consumer<GameViewModel>(
              builder: (context, viewModel, child) {
                return Column(
                  children: [
                    // Barra de estado superior con estadísticas detalladas
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        border: Border(
                          bottom: BorderSide(
                            color: viewModel.game.cellColorAlivePlayer1.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (viewModel.game.iteration == 0)
                            // Fase de Preparación: Solo Fichas Iniciales
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.edit, color: viewModel.game.cellColorAlivePlayer1, size: 18),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Fichas Iniciales: ${viewModel.game.countPlayerCells(1)}',
                                      style: TextStyle(
                                        color: viewModel.game.cellColorAlivePlayer1,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                GameTimerWidget(
                                  game: game,
                                  playerIndex: 1,
                                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                                ),
                              ],
                            )
                          else
                            // Fase de Simulación: Estadísticas completas
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    _statText('Iniciales', viewModel.game.initialFichas.toString(), Colors.white70),
                                    _statText('Población', viewModel.game.countPlayerCells(1).toString(), viewModel.game.cellColorAlivePlayer1),
                                    GameTimerWidget(
                                      game: game,
                                      playerIndex: 1,
                                      style: const TextStyle(color: Colors.greenAccent, fontSize: 13, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    _statText('Máx. Población', viewModel.game.maxPopulation.toString(), Colors.orangeAccent),
                                    _statText('Mín. Población', viewModel.game.minPopulation.toString(), Colors.cyanAccent),
                                  ],
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                    // 1. El tablero del juego con widgets neón (Ocupa el espacio restante)
                    Expanded(
                      child: Center(
                        child: NeonGridWidget(game: game),
                      ),
                    ),

                    // 3. Controles inferiores (play, reset, sonido, home)
                    // Ya no usamos Positioned, BaseGameControls es un Container flexible
                    // 3. Controles inferiores
                    GameControlsBar(
                      isMultiplayer: false,
                      buttons: [
                        ControlButton(
                          icon: viewModel.playButtonIcon,
                          color: viewModel.playButtonColor,
                          onPressed: () {
                            // Validación antes de play
                            if (!viewModel.game.pauseExec) {
                                 viewModel.onPlayPressed();
                                 return;
                            }
                            
                            final error = viewModel.getSinglePlayerValidationError();
                            if (error != null) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  content: Text(error),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text("OK"),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              viewModel.onPlayPressed();
                            }
                          },
                          size: 32.0, 
                        ),
                        ControlButton(
                          icon: Icons.restart_alt,
                          color: viewModel.resetIconColor,
                          onPressed: viewModel.onResetPressed,
                          size: 32.0, 
                        ),
                        // NUEVO: Botón de Sonido
                        ControlButton(
                          icon: viewModel.soundButtonIcon,
                          color: viewModel.soundButtonColor,
                          onPressed: viewModel.toggleSound,
                          size: 32.0,
                        ),
                        ControlButton(
                          icon: Icons.home,
                          color: Colors.purple,
                          onPressed: () => viewModel.onExitPressed(context),
                          size: 32.0,
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );
  }

  Widget _statText(String label, String value, Color color) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 13, color: Colors.white60),
        children: [
          TextSpan(text: '$label: '),
          TextSpan(
            text: value,
            style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
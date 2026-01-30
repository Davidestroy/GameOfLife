import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../game/cellular_automaton_game.dart';
import '../viewmodels/game_view_model.dart';
import '../widgets/game_controls_bar.dart';
import '../widgets/control_button.dart';
import '../widgets/neon_grid_widget.dart';
import '../widgets/game_timer_widget.dart';

class MultiplayerGame extends StatefulWidget {
  final CellularAutomatonGame game;
  const MultiplayerGame({super.key, required this.game});

  @override
  State<MultiplayerGame> createState() => _MultiplayerGameState();
}

class _MultiplayerGameState extends State<MultiplayerGame> {
  void _handleListoPressed(BuildContext context) {
    if (widget.game.currentPhase == GamePhase.player1) {
      // Cambiar al Jugador 2
      widget.game.currentPhase = GamePhase.player2;
      widget.game.isLeftSideLocked = true;
      widget.game.isRightSideLocked = false;
      widget.game.allowEditing = true;

      // Notificar cambios (si usas ViewModel)
      final viewModel = Provider.of<GameViewModel>(context, listen: false);
      viewModel.game.notifyListeners();
    }
    else if (widget.game.currentPhase == GamePhase.player2) {
      // Iniciar simulación
      final viewModel = Provider.of<GameViewModel>(context, listen: false);
      viewModel.onPlayPressed();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GameViewModel(game: widget.game),
      child: Scaffold(
        backgroundColor: const Color(0xFF1A1A1A),
        body: SafeArea(
          child: Builder(
            builder: (context) {
              final screenSize = MediaQuery.of(context).size;
              return Consumer<GameViewModel>(
                builder: (context, viewModel, child) {
                  return Column(
                    children: [
                      // Barra de estado superior (Población y Tiempo)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        color: Colors.black54,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Jugador 1 info
                            Flexible( 
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      widget.game.iteration == 0 
                                        ? 'Fichas: ${widget.game.countPlayerCells(1)} / 25'
                                        : 'Población: ${widget.game.countPlayerCells(1)}',
                                      style: TextStyle(
                                        color: widget.game.cellColorAlivePlayer1,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: GameTimerWidget(
                                      game: widget.game,
                                      playerIndex: 1,
                                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            // Jugador 2 info
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      widget.game.iteration == 0 
                                        ? 'Fichas: ${widget.game.countPlayerCells(2)} / 25'
                                        : 'Población: ${widget.game.countPlayerCells(2)}',
                                      style: TextStyle(
                                        color: widget.game.cellColorAlivePlayer2,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: GameTimerWidget(
                                      game: widget.game,
                                      playerIndex: 2,
                                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Grid con widgets neón (Ocupa el espacio restante)
                      Expanded(
                        child: Center(
                          child: NeonGridWidget(game: widget.game, showDivider: true),
                        ),
                      ),
                      
                      // Controles inferiores
                      // Controles inferiores
                      GameControlsBar(
                        isMultiplayer: true,
                        buttons: [
                          ControlButton(
                            icon: viewModel.playButtonIcon,
                            color: viewModel.playButtonColor,
                            onPressed: () {
                               // Validación Play (Inicio del juego)
                               if (!viewModel.game.pauseExec) {
                                 viewModel.onPlayPressed();
                                 return;
                               }
                               final error = viewModel.getMultiplayerStartError();
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
                            size: 28.0, 
                          ),

                          ControlButton(
                            icon: Icons.restart_alt,
                            color: viewModel.resetIconColor,
                            onPressed: viewModel.onResetPressed,
                            size: 28.0,
                          ),

                          if (widget.game.showDivider)
                            ControlButton(
                              icon: Icons.check,
                              color: viewModel.activePlayerColor,
                              onPressed: () {
                                // Validación Listo (Cambio de Fase / Fin turno)
                                final error = viewModel.getMultiplayerPhaseError();
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
                                  _handleListoPressed(context);
                                }
                              },
                              size: 28.0,
                            ),

                          // Botón de Sonido (Añadido)
                          ControlButton(
                            icon: viewModel.soundButtonIcon,
                            color: viewModel.soundButtonColor,
                            onPressed: viewModel.toggleSound,
                            size: 28.0,
                          ),

                          ControlButton(
                            icon: Icons.home, // Icono Home unificado
                            color: Colors.purple,
                            onPressed: () => viewModel.onExitPressed(context), // Volver guardando estadísticas
                            size: 28.0,
                          ),
                        ],
                      ),
                    ],
                  );
                }
              );
            }
          ),
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../game/cellular_automaton_game.dart';
import '../viewmodels/game_view_model.dart';
import 'neon_cell.dart';

/// Widget principal del grid con células neón.
/// Reemplaza el GameWidget de Flame con un GridView basado en widgets.
class NeonGridWidget extends StatefulWidget {
  final CellularAutomatonGame game;
  final bool showDivider;

  const NeonGridWidget({
    super.key,
    required this.game,
    this.showDivider = false,
  });

  @override
  State<NeonGridWidget> createState() => _NeonGridWidgetState();
}

class _NeonGridWidgetState extends State<NeonGridWidget> {
  static const int gridSize = 20;

  @override
  void initState() {
    super.initState();
    // Escuchar cambios del game para reconstruir durante simulación
    widget.game.addListener(_onGameStateChanged);
  }

  @override
  void dispose() {
    widget.game.removeListener(_onGameStateChanged);
    super.dispose();
  }

  /// Callback cuando el game notifica cambios (durante simulación)
  void _onGameStateChanged() {
    setState(() {}); // Reconstruir grid con nuevo estado
  }

  void _handleCellTap(int x, int y) {
    if (!widget.game.allowEditing) return;

    final game = widget.game;
    
    if (widget.showDivider) {
      final middleX = gridSize ~/ 2;

      if (game.currentPhase == GamePhase.player1) {
        // Jugador 1: Solo lado izquierdo
        if (x < middleX && (game.player1Counter > 0 || game.gameState[x][y] == 1)) {
          game.gameState[x][y] = game.gameState[x][y] == 1 ? 0 : 1;
          game.player1Counter += game.gameState[x][y] == 1 ? -1 : 1;
        }
      } else if (game.currentPhase == GamePhase.player2) {
        // Jugador 2: Solo lado derecho
        if (x >= middleX && (game.player2Counter > 0 || game.gameState[x][y] == 2)) {
          game.gameState[x][y] = game.gameState[x][y] == 2 ? 0 : 2;
          game.player2Counter += game.gameState[x][y] == 2 ? -1 : 1;
        }
      }
    } else {
      // Modo normal: Sin restricciones
      game.gameState[x][y] = game.gameState[x][y] == 1 ? 0 : 1;
    }

    setState(() {}); // Actualizar UI
    widget.game.notifyListeners();
  }

  /// Convierte una posición de pantalla a coordenadas de celda (x, y)
  /// Retorna null si la posición está fuera del grid
  Map<String, int>? _positionToCell(Offset position, double cellSize) {
    final x = (position.dx / cellSize).floor();
    final y = (position.dy / cellSize).floor();
    
    if (x >= 0 && x < gridSize && y >= 0 && y < gridSize) {
      return {'x': x, 'y': y};
    }
    return null;
  }

  /// Maneja la colocación de células durante el arrastre
  void _handlePanUpdate(Offset localPosition, double cellSize) {
    if (!widget.game.allowEditing) return;

    final coords = _positionToCell(localPosition, cellSize);
    if (coords == null) return;

    final x = coords['x']!;
    final y = coords['y']!;
    final game = widget.game;

    if (widget.showDivider) {
      final middleX = gridSize ~/ 2;

      if (game.currentPhase == GamePhase.player1) {
        // Jugador 1: Solo lado izquierdo, solo colocar (no quitar durante drag)
        if (x < middleX && game.player1Counter > 0 && game.gameState[x][y] == 0) {
          game.gameState[x][y] = 1;
          game.player1Counter -= 1;
          setState(() {});
          game.notifyListeners();
        }
      } else if (game.currentPhase == GamePhase.player2) {
        // Jugador 2: Solo lado derecho, solo colocar (no quitar durante drag)
        if (x >= middleX && game.player2Counter > 0 && game.gameState[x][y] == 0) {
          game.gameState[x][y] = 2;
          game.player2Counter -= 1;
          setState(() {});
          game.notifyListeners();
        }
      }
    } else {
      if (game.gameState[x][y] == 0) {
        game.gameState[x][y] = 1;
        setState(() {});
        game.notifyListeners();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calcular tamaño de celda basado en el espacio disponible
        final gridWidth = constraints.maxWidth;
        final gridHeight = constraints.maxHeight;

        // Usamos el minimo entre ancho y alto para asegurar que quepa
        // Restamos un pequeño margen para que no toque los bordes
        final double minForGrid = (gridWidth < gridHeight ? gridWidth : gridHeight) - 20;
        final double calculatedCellSize = (minForGrid / gridSize).floorToDouble();
        
        // Aseguramos un tamaño minimo razonable pero respetando limites
        final double cellSize = calculatedCellSize < 5.0 ? 5.0 : calculatedCellSize;

        // Calculamos el tamaño final del grid para centrarlo
        final double finalGridSize = cellSize * gridSize;

        return GestureDetector(
          // Importante: behavior para que gestos no sean bloqueados por widgets hijos
          behavior: HitTestBehavior.translucent,
          
          // Detectar inicio de arrastre
          onPanStart: (details) {
            _handlePanUpdate(details.localPosition, cellSize);
          },
          
          // Detectar movimiento continuo durante arrastre
          onPanUpdate: (details) {
            _handlePanUpdate(details.localPosition, cellSize);
          },
          
          child: Center(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Grid de células
                SizedBox(
                  width: finalGridSize,
                  height: finalGridSize,
                  child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: gridSize,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: gridSize * gridSize,
                  itemBuilder: (context, index) {
                    final x = index % gridSize;
                    final y = index ~/ gridSize;
                    final cellState = widget.game.gameState[x][y];

                    Color cellColor = Colors.black;
                    bool isAlive = false;

                    if (cellState == 1) {
                      cellColor = widget.game.cellColorAlivePlayer1;
                      isAlive = true;
                    } else if (cellState == 2) {
                      cellColor = widget.game.cellColorAlivePlayer2;
                      isAlive = true;
                    }

                    return NeonCell(
                      cellColor: cellColor,
                      isAlive: isAlive,
                      size: cellSize,
                      onTap: () => _handleCellTap(x, y),
                    );
                  },
                ),
              ),

              // Línea divisoria (multiplayer)
              if (widget.showDivider)
                Positioned(
                  left: cellSize * gridSize / 2 - 2.5,
                  top: 0,
                  bottom: 0,
                  child: IgnorePointer( // No interferir con gestos
                    child: Container(
                      width: 5,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.3),
                            blurRadius: 4,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Contadores eliminados de aqui, ahora se manejan en la pantalla principal
              ],
            ),
          ),
        );
      },
    );
  }
}

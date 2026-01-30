import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';

/// Widget de mini-simulación para instrucciones.
/// Ahora usa widgets con flutter_glow en lugar de CustomPaint.
class MiniSimulationPreview extends StatefulWidget {
  final String title;
  final String description;
  final List<List<int>> initialGrid; // 10x10 Grid (1 = alive, 0 = dead)

  const MiniSimulationPreview({
    super.key,
    required this.title,
    required this.description,
    required this.initialGrid,
  });

  @override
  State<MiniSimulationPreview> createState() => _MiniSimulationPreviewState();
}

class _MiniSimulationPreviewState extends State<MiniSimulationPreview> {
  late List<List<int>> grid;
  late Timer _timer;
  final int gridSize = 10;

  @override
  void initState() {
    super.initState();
    // Clonar la rejilla inicial
    grid = List.generate(
      gridSize,
      (i) => List.from(widget.initialGrid[i]),
    );

    // Iniciar animación automática con intervalos más rápidos
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      _nextGeneration();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _nextGeneration() {
    List<List<int>> newGrid = List.generate(
      gridSize,
      (i) => List.filled(gridSize, 0),
    );

    for (int x = 0; x < gridSize; x++) {
      for (int y = 0; y < gridSize; y++) {
        int neighbors = _countNeighbors(x, y);
        int cell = grid[x][y];

        if (cell == 1) {
          if (neighbors < 2 || neighbors > 3) {
            newGrid[x][y] = 0;
          } else {
            newGrid[x][y] = 1;
          }
        } else {
          if (neighbors == 3) {
            newGrid[x][y] = 1;
          } else {
            newGrid[x][y] = 0;
          }
        }
      }
    }

    setState(() {
      grid = newGrid;
    });
  }

  int _countNeighbors(int x, int y) {
    int count = 0;
    for (int i = -1; i <= 1; i++) {
      for (int j = -1; j <= 1; j++) {
        if (i == 0 && j == 0) continue;
        int nx = (x + i + gridSize) % gridSize;
        int ny = (y + j + gridSize) % gridSize;
        count += grid[nx][ny];
      }
    }
    return count;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título
          Text(
            widget.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          
          // Rejilla visual con widgets neón
          Center(
            child: SizedBox(
              width: 200,
              height: 200,
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
                  final isAlive = grid[x][y] == 1;

                  if (!isAlive) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(
                          color: Colors.grey[800]!,
                          width: 0.5,
                        ),
                      ),
                    );
                  }

                  // Célula viva con efecto neón mejorado
                  const baseColor = Colors.greenAccent;
                  final glowColor = Color.lerp(baseColor, Colors.white, 0.6)!;

                  return GlowContainer(
                    color: baseColor,
                    glowColor: glowColor,
                    borderRadius: BorderRadius.circular(1),
                    spreadRadius: 2,  // Aumentado para mejor visibilidad
                    blurRadius: 6,    // Aumentado para glow más suave
                    child: Container(
                      decoration: BoxDecoration(
                        color: baseColor,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.4),
                          width: 0.5,
                        ),
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Descripción
          Text(
            widget.description,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../widgets/mini_simulation_preview.dart';

class InstructionsScreen extends StatelessWidget {
  const InstructionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 25, 25, 25), // Color de fondo oscuro consistente
      appBar: AppBar(
        title: const Text('Instrucciones'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Alinear a la izquierda
          children: [
            const Text(
              '¿Qué es el Juego de la Vida?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'El Juego de la Vida es un autómata celular diseñado por el matemático británico John Horton Conway en 1970. Es un juego de cero jugadores, lo que significa que su evolución está determinada por el estado inicial y no necesita ninguna intervención posterior.',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              'Reglas Fundamentales',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'El universo del Juego de la Vida es una rejilla ortogonal bidimensional infinita de celdas cuadradas, cada una de las cuales se encuentra en uno de dos estados posibles, viva o muerta. Cada celda interactúa con sus ocho vecinos.',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 15),
            const Text(
              'En cada paso de tiempo, ocurren las siguientes transiciones:',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 10),
            _buildRuleItem('1. Subpoblación', 'Cualquier célula viva con menos de dos vecinos vivos muere.'),
            _buildRuleItem('2. Supervivencia', 'Cualquier célula viva con dos o tres vecinos vivos vive para la siguiente generación.'),
            _buildRuleItem('3. Sobrepoblación', 'Cualquier célula viva con más de tres vecinos vivos muere.'),
            _buildRuleItem('4. Reproducción', 'Cualquier célula muerta con exactamente tres vecinos vivos se convierte en una célula viva.'),
            const SizedBox(height: 30),

            // Ejemplos Visuales
            const Text(
              'Ejemplos Visuales',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            // Ejemplo 1: Still Life (Block)
            MiniSimulationPreview(
              title: "Patrón Estacionario (Block)",
              description: "Una configuración que nunca cambia. Cada célula tiene exactamente 3 vecinos, sobreviviendo indefinidamente.",
              initialGrid: [
                [0,0,0,0,0,0,0,0,0,0],
                [0,0,0,0,0,0,0,0,0,0],
                [0,0,0,0,0,0,0,0,0,0],
                [0,0,0,1,1,0,0,0,0,0],
                [0,0,0,1,1,0,0,0,0,0],
                [0,0,0,0,0,0,0,0,0,0],
                [0,0,0,0,0,0,0,0,0,0],
                [0,0,0,0,0,0,0,0,0,0],
                [0,0,0,0,0,0,0,0,0,0],
                [0,0,0,0,0,0,0,0,0,0],
              ],
            ),

            // Ejemplo 2: Oscillator (Blinker)
            MiniSimulationPreview(
              title: "Oscilador (Blinker)",
              description: "Alterna entre dos estados. Ilustra el nacimiento (celdas vacías con 3 vecinos) y muerte por soledad (extremos con 1 vecino).",
              initialGrid: [
                [0,0,0,0,0,0,0,0,0,0],
                [0,0,0,0,0,0,0,0,0,0],
                [0,0,0,0,1,0,0,0,0,0],
                [0,0,0,0,1,0,0,0,0,0],
                [0,0,0,0,1,0,0,0,0,0],
                [0,0,0,0,0,0,0,0,0,0],
                [0,0,0,0,0,0,0,0,0,0],
                [0,0,0,0,0,0,0,0,0,0],
                [0,0,0,0,0,0,0,0,0,0],
                [0,0,0,0,0,0,0,0,0,0],
              ],
            ),

            // Ejemplo 3: Regla de Sobrepoblación
            MiniSimulationPreview(
              title: "Sobrepoblación",
              description: "El centro de la cruz tiene 4 vecinos y muere en la siguiente generación. Los extremos sobreviven o nacen nuevas celdas.",
              initialGrid: [
                [0,0,0,0,0,0,0,0,0,0],
                [0,0,0,0,1,0,0,0,0,0],
                [0,0,0,1,1,1,0,0,0,0],
                [0,0,0,0,1,0,0,0,0,0],
                [0,0,0,0,0,0,0,0,0,0],
                [0,0,0,0,0,0,0,0,0,0],
                [0,0,0,0,0,0,0,0,0,0],
                [0,0,0,0,0,0,0,0,0,0],
                [0,0,0,0,0,0,0,0,0,0],
                [0,0,0,0,0,0,0,0,0,0],
              ],
            ),

            const SizedBox(height: 20),

            // Naves Espaciales
            const Text(
              'Naves Espaciales (Spaceships)',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Una "nave" es un patrón finito que se desplaza por la rejilla, repitiendo su forma pero en una posición diferente en cada ciclo. Ilustra la capacidad de movimiento en el universo del juego.',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 10),

            // Ejemplo 4: Glider
            MiniSimulationPreview(
              title: "El Glider (Planeador)",
              description: "La nave más pequeña y común. Se desplaza diagonalmente una casilla cada 4 generaciones.",
              initialGrid: [
                [0,0,1,0,0,0,0,0,0,0],
                [1,0,1,0,0,0,0,0,0,0],
                [0,1,1,0,0,0,0,0,0,0],
                [0,0,0,0,0,0,0,0,0,0],
                [0,0,0,0,0,0,0,0,0,0],
                [0,0,0,0,0,0,0,0,0,0],
                [0,0,0,0,0,0,0,0,0,0],
                [0,0,0,0,0,0,0,0,0,0],
                [0,0,0,0,0,0,0,0,0,0],
                [0,0,0,0,0,0,0,0,0,0],
              ],
            ),

            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('Entendido', style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildRuleItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.circle, color: Colors.blueAccent, size: 10),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.white70, fontSize: 16),
                children: [
                  TextSpan(
                    text: '$title: ',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  TextSpan(text: description),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

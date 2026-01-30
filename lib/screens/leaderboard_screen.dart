import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/leaderboard_entry.dart';
import '../services/leaderboard_service.dart';

/// Pantalla que muestra el historial de partidas y los mejores resultados.
/// Carga los datos de forma asíncrona desde el almacenamiento persistente.
class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        title: const Text('TOP 10 RESULTADOS', 
          style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          // Opción para limpiar el historial
          IconButton(
            icon: const Icon(Icons.delete_sweep_outlined, color: Colors.redAccent),
            tooltip: 'Borrar historial',
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: const Color(0xFF2A2A2A),
                  title: const Text('¿Borrar historial?', style: TextStyle(color: Colors.white)),
                  content: const Text('Esta acción no se puede deshacer.', style: TextStyle(color: Colors.white70)),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
                    TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Borrar', style: TextStyle(color: Colors.redAccent))),
                  ],
                ),
              );
              if (confirm == true) {
                await LeaderboardService.clearAll();
                setState(() {}); // Refrescar pantalla
              }
            },
          ),
        ],
      ),
      // 1. Carga de datos: Se usa FutureBuilder para obtener la lista del servicio.
      body: FutureBuilder<List<LeaderboardEntry>>(
        future: LeaderboardService.loadEntries(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.cyanAccent));
          }
          
          // 2. Filtrado: Tomamos solo los 10 mejores resultados de la lista cargada.
          final allEntries = snapshot.data ?? [];
          final entries = allEntries.take(10).toList();
          
          if (entries.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Icon(Icons.emoji_events_outlined, size: 80, color: Colors.grey),
                   SizedBox(height: 16),
                   Text(
                    'Sin récords todavía.',
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                ],
              ),
            );
          }

          // 3. Presentación: ListView para mostrar las tarjetas de resultados.
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entry = entries[index];
              final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
              
              // Colores especiales para el podio
              Color rankColor = Colors.cyanAccent;
              if (index == 0) rankColor = Colors.amber;        // Oro
              else if (index == 1) rankColor = Colors.grey;     // Plata
              else if (index == 2) rankColor = Colors.brown;    // Bronce

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: rankColor.withOpacity(0.4), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: rankColor.withOpacity(0.05),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Círculo con el ranking
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: rankColor.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '#${index + 1}',
                            style: TextStyle(color: rankColor, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              entry.gameMode,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              dateFormat.format(entry.date),
                              style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 11),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Divider(color: Colors.white10, height: 1),
                    ),
                    // Uso de widgets de etiquetas + valor para cada métrica
                    _StatRow(label: 'Pob. Máxima', value: '${entry.maxPopulation}', icon: Icons.keyboard_double_arrow_up, color: Colors.greenAccent),
                    _StatRow(label: 'Pob. Mínima', value: '${entry.minPopulation}', icon: Icons.keyboard_double_arrow_down, color: Colors.redAccent),
                    _StatRow(label: 'Fichas Iniciales', value: '${entry.initialFichas}', icon: Icons.play_circle_fill_outlined, color: Colors.blueAccent),
                    _StatRow(label: 'Fichas Finales', value: '${entry.finalFichas}', icon: Icons.stop_circle_outlined, color: Colors.orangeAccent),
                    _StatRow(label: 'Tiempo', value: _formatDuration(entry.playTime), icon: Icons.timer_outlined, color: Colors.purpleAccent),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _formatDuration(Duration d) {
    if (d.inHours > 0) {
      return "${d.inHours}h ${d.inMinutes.remainder(60)}m ${d.inSeconds.remainder(60)}s";
    }
    return "${d.inMinutes}m ${d.inSeconds.remainder(60)}s";
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatRow({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color.withOpacity(0.7)),
          const SizedBox(width: 10),
          Text(label, style: const TextStyle(color: Colors.white60, fontSize: 13)),
          const Spacer(),
          Text(value, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }
}

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/leaderboard_entry.dart';

/// Servicio para gestionar el almacenamiento persistente de las estadísticas de partidas.
/// Utiliza [SharedPreferences] para guardar la lista de resultados en formato JSON.
class LeaderboardService {
  static const String _storageKey = 'leaderboard_data';

  /// Guarda una nueva entrada en la lista persistente.
  /// Mantiene las entradas ordenadas por mejor resultado y limita el historial.
  static Future<void> saveEntry(LeaderboardEntry entry) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<LeaderboardEntry> entries = await loadEntries();
      
      entries.add(entry);
      
      // ORDENACIÓN: Criterio de "tabla de mejores resultados".
      // Principal: Mayor población alcanzada.
      // Secundario: Fecha más reciente para desempates.
      entries.sort((a, b) {
        int cmp = b.maxPopulation.compareTo(a.maxPopulation);
        if (cmp == 0) return b.date.compareTo(a.date);
        return cmp;
      });

      // Mantenemos solo las mejores 50 partidas para optimizar el almacenamiento.
      if (entries.length > 50) {
        entries.removeRange(50, entries.length);
      }

      final String encodedData = jsonEncode(
        entries.map((e) => e.toJson()).toList(),
      );
      
      await prefs.setString(_storageKey, encodedData);
    } catch (e) {
      print('Error en LeaderboardService.saveEntry: $e');
    }
  }

  /// Carga la lista completa de resultados desde el almacenamiento local.
  /// Retorna una lista vacía si no hay datos o si ocurre un error.
  static Future<List<LeaderboardEntry>> loadEntries() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? encodedData = prefs.getString(_storageKey);

      if (encodedData == null) return [];

      final List<dynamic> decodedList = jsonDecode(encodedData);
      return decodedList.map((item) => LeaderboardEntry.fromJson(item)).toList();
    } catch (e) {
      print('Error cargando leaderboard: $e');
      return [];
    }
  }

  /// Borra todos los registros del leaderboard.
  static Future<void> clearAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_storageKey);
    } catch (e) {
      print('Error borrando leaderboard: $e');
    }
  }
}

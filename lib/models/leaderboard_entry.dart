import 'dart:convert';

/// Modelo que representa una entrada en la tabla de mejores resultados (Leaderboard).
/// Contiene las métricas clave de una partida para ser persistidas.
class LeaderboardEntry {
  /// Número máximo de células vivas alcanzado durante la simulación.
  final int maxPopulation;
  /// Número mínimo de células vivas observado (incluyendo el estado inicial y el final).
  final int minPopulation;
  /// Cantidad de fichas colocadas manualmente por los jugadores antes de iniciar.
  final int initialFichas;
  /// Cantidad de fichas vivas al momento de detener la simulación o terminar.
  final int finalFichas;
  /// Duración real de la simulación activa (medida con un Cronómetro).
  final Duration playTime;
  /// Fecha y hora en que se registró el resultado.
  final DateTime date;
  /// Identificador del modo jugado: "Un jugador" o "Dos jugadores".
  final String gameMode;

  LeaderboardEntry({
    required this.maxPopulation,
    required this.minPopulation,
    required this.initialFichas,
    required this.finalFichas,
    required this.playTime,
    required this.date,
    required this.gameMode,
  });

  /// Convierte la entrada a un mapa para guardarlo como JSON en almacenamiento local.
  Map<String, dynamic> toJson() => {
    'maxPopulation': maxPopulation,
    'minPopulation': minPopulation,
    'initialFichas': initialFichas,
    'finalFichas': finalFichas,
    'playTimeMs': playTime.inMilliseconds,
    'date': date.toIso8601String(),
    'gameMode': gameMode,
  };

  /// Crea una instancia a partir de un mapa JSON recuperado del almacenamiento.
  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntry(
      maxPopulation: json['maxPopulation'],
      minPopulation: json['minPopulation'],
      initialFichas: json['initialFichas'],
      finalFichas: json['finalFichas'],
      playTime: Duration(milliseconds: json['playTimeMs']),
      date: DateTime.parse(json['date']),
      gameMode: json['gameMode'] ?? 'Un jugador',
    );
  }
}

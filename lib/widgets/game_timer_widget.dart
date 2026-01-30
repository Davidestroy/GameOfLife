import 'dart:async';
import 'package:flutter/material.dart';
import '../game/cellular_automaton_game.dart';

class GameTimerWidget extends StatefulWidget {
  final CellularAutomatonGame game;
  final TextStyle? style;
  final int playerIndex; // 1 para Jugador 1, 2 para Jugador 2

  const GameTimerWidget({
    super.key, 
    required this.game, 
    this.style,
    this.playerIndex = 1, // Por defecto J1
  });

  @override
  State<GameTimerWidget> createState() => _GameTimerWidgetState();
}

class _GameTimerWidgetState extends State<GameTimerWidget> {
  Timer? _timer;
  String _formattedTime = "00:00:000";
  bool _isFinished = false;

  @override
  void initState() {
    super.initState();
    // Iniciar el timer para actualizar la UI con alta frecuencia
    _timer = Timer.periodic(const Duration(milliseconds: 30), (_) {
      _updateTime();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateTime() {
    if (mounted) {
      final duration = widget.game.getPlayerPlayTime(widget.playerIndex);
      final isRunning = widget.game.isPlayerStopwatchRunning(widget.playerIndex);
      
      setState(() {
        _formattedTime = _formatDuration(duration);
        // Si el cronómetro del jugador está parado pero la simulación sigue activa y ya empezó (iteration > 0), está extinguido
        _isFinished = !isRunning && !widget.game.pauseExec && widget.game.iteration > 0;
      });
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String threeDigits(int n) => n.toString().padLeft(3, "0");
    
    // Si dura más de una hora, mostramos HH:MM:SS, sino MM:SS:mmm
    if (duration.inHours > 0) {
       return "${twoDigits(duration.inHours)}:${twoDigits(duration.inMinutes.remainder(60))}:${twoDigits(duration.inSeconds.remainder(60))}";
    } else {
       return "${twoDigits(duration.inMinutes.remainder(60))}:${twoDigits(duration.inSeconds.remainder(60))}:${threeDigits(duration.inMilliseconds.remainder(1000))}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      "Tiempo: $_formattedTime",
      style: (widget.style ?? const TextStyle(color: Colors.white, fontSize: 14)).copyWith(
        color: _isFinished ? Colors.white.withOpacity(0.4) : null,
      ),
    );
  }
}

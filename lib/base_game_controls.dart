// base_game_controls.dart
import 'package:flutter/material.dart';

class BaseGameControls extends StatelessWidget {
  final List<Widget> buttons;

  const BaseGameControls({super.key, required this.buttons});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 100,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: buttons,
          ),
        ),
      ),
    );
  }
}
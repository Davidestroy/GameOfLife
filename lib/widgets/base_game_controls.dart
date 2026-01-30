// base_game_controls.dart
import 'package:flutter/material.dart';

class BaseGameControls extends StatelessWidget {
  final List<Widget> buttons;

  const BaseGameControls({super.key, required this.buttons});

  @override
  Widget build(BuildContext context) {
    // AJUSTE: Padding relativo al tamaño de pantalla
    final double verticalPadding = MediaQuery.of(context).size.height * 0.02;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: verticalPadding,
        horizontal: 16.0,
      ),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: buttons.map((btn) => Flexible(child: btn)).toList(),
          ),
        ),
      ),
    );
  }
}
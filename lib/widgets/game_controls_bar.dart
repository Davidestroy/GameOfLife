import 'package:flutter/material.dart';

class GameControlsBar extends StatelessWidget {
  final List<Widget> buttons;
  final bool isMultiplayer;

  const GameControlsBar({
    super.key,
    required this.buttons,
    this.isMultiplayer = false,
  });

  @override
  Widget build(BuildContext context) {
    // AJUSTE: Padding relativo al tamaño de pantalla
    final double verticalPadding = MediaQuery.of(context).size.height * 0.02;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: verticalPadding,
        horizontal: isMultiplayer ? 10.0 : 16.0, // Más ancho en multiplayer
      ),
      child: Center(
        child: Container(
          width: double.infinity, 
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: buttons.map((btn) => Flexible(child: btn)).toList(),
          ),
        ),
      ),
    );
  }
}

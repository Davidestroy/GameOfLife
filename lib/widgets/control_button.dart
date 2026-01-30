// control_button.dart
import 'package:flutter/material.dart';

class ControlButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback? onPressed;
  final double size;

  const ControlButton({
    super.key,
    required this.icon,
    required this.color,
    this.onPressed,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, color: Colors.white),
      iconSize: size,
      onPressed: onPressed,
      style: IconButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.all(10),
        shape: const CircleBorder(),
      ),
    );
  }
}
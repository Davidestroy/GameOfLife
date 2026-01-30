import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';

/// Widget individual para una célula con efecto neón.
/// Usa GlowContainer de flutter_glow para crear el resplandor brillante.
class NeonCell extends StatelessWidget {
  final Color cellColor;
  final bool isAlive;
  final VoidCallback? onTap;
  final double size;

  const NeonCell({
    super.key,
    required this.cellColor,
    required this.isAlive,
    this.onTap,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    if (!isAlive) {
      // Célula muerta: fondo negro sin efecto
      return GestureDetector(
        onTap: onTap,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(
              color: Colors.grey[800]!,
              width: 0.5,
            ),
          ),
        ),
      );
    }

    // Célula viva: efecto neón con GlowContainer
    // Glow más brillante (60% blanco) para halo ultra-luminoso
    final glowColor = Color.lerp(cellColor, Colors.white, 0.6)!;

    return GestureDetector(
      onTap: onTap,
      child: GlowContainer(
        color: cellColor, // Color base neón ultra-saturado
        glowColor: glowColor, // Resplandor muy brillante (whitish)
        borderRadius: BorderRadius.circular(2),
        spreadRadius: 3,  // Aumentado para halo más amplio
        blurRadius: 10,   // Aumentado para efecto más suave y luminoso
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: cellColor,
            border: Border.all(
              color: Colors.white.withOpacity(0.4), // Borde más visible
              width: 1,
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'control_button.dart'; // Importa el botón reutilizable

class SlidingMenu extends StatefulWidget {
  final List<Widget> menuItems;
  final double menuWidth;

  const SlidingMenu({
    super.key,
    required this.menuItems,
    required this.menuWidth,
  });

  @override
  _SlidingMenuState createState() => _SlidingMenuState();
}

class _SlidingMenuState extends State<SlidingMenu> with SingleTickerProviderStateMixin {
  bool _isMenuOpen = false;
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<Offset>(
      begin: const Offset(1, 0), // Fuera de la pantalla (derecha)
      end: Offset.zero,          // Posición original
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
      _isMenuOpen ? _controller.forward() : _controller.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 20,    // 20 píxeles desde la parte superior
      right: 20,  // 20 píxeles desde la derecha
      child: Stack(
        children: [
          // Botón para abrir/cerrar el menú (usando ControlButton)
          ControlButton(
            icon: _isMenuOpen ? Icons.close : Icons.menu,
            color: Colors.blue,
            onPressed: _toggleMenu,
            size: 40,
          ),

          // Menú deslizante (animado)
          SlideTransition(
            position: _animation,
            child: Container(
              width: widget.menuWidth,
              margin: const EdgeInsets.only(top: 60), // Espacio debajo del botón
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.menuItems,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
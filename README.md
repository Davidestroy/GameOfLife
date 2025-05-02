# Game of Life - Flutter Implementation

Implementación del Juego de la Vida de Conway con modos individual y multijugador.

## 🔧 Instrucciones del Modo Multijugador

### Configuración
- Jugador 1: Mitad izquierda del tablero
- Jugador 2: Mitad derecha del tablero
- Cada jugador inicia con 25 células para colocar

### Fases del Juego

1. **Fase de Colocación**:
   - Turnos alternados entre jugadores
   - Toque simple para colocar/eliminar células
   - Contador de células restantes visible

2. **Fase de Simulación**:
   - Las células evolucionan automáticamente
   - Reglas estándar del Juego de la Vida:
     - Supervivencia con 2-3 vecinos
     - Nacimiento con exactamente 3 vecinos
   - Sistema de turnos se desactiva

### Controles
- **Botón Listo**: Finaliza tu turno de colocación
- **Botón Reiniciar**: Vuelve a la fase inicial
- **Botón Pausa**: Detiene la simulación

## Tecnologías Utilizadas
- Flutter 3.x
- Flame 1.x
- Provider para gestión de estado

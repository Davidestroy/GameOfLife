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

## 📲 Descarga la Versión Beta

Prueba la versión preliminar del juego instalando el APK directamente en tu dispositivo Android:

[![Botón de Descarga](https://img.shields.io/badge/Descargar_APK-GameOfLife_Beta_v1.0-0078D7?style=for-the-badge&logo=android&logoColor=white)](https://github.com/Davidestroy/GameOfLife/releases/download/v1.0.0-beta/GameOfLife-beta-v1.0.apk)

**Instrucciones de instalación**:
1. Descarga el archivo APK haciendo clic en el botón superior
2. En tu Android, ve a **Ajustes > Seguridad** y activa "Instalar aplicaciones desconocidas"
3. Abre el archivo descargado y selecciona "Instalar"
4. ¡Disfruta del juego y reporta cualquier bug!

*Nota: Esta es una versión beta - algunas características pueden estar en desarrollo.*

## Tecnologías Utilizadas
- Flutter 3.x
- Flame 1.x
- Provider para gestión de estado

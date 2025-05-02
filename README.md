# Game of Life - Flutter Implementation



Implementación interactiva del autómata celular "Juego de la Vida" de Conway con modos individual y multijugador.

## 🎮 Instrucciones del Modo Multijugador

### 🔷 Configuración Inicial
- **Jugador 1**: Controla el lado izquierdo (color azul)
- **Jugador 2**: Controla el lado derecho (color rojo)
- Cada jugador dispone de **25 células** iniciales

### ⏳ Fase de Colocación
1. **Turno del Jugador 1**:
   - Toca celdas en la mitad izquierda para colocar/eliminar células
   - Observa tu contador de células restantes
   - Presiona **"LISTO"** cuando termines

2. **Turno del Jugador 2**:
   - Ahora puedes interactuar con la mitad derecha
   - Coloca tus 25 células estratégicamente
   - Presiona **"LISTO"** para iniciar la simulación

### ⚡ Fase de Simulación
- Las células evolucionan automáticamente
- Las reglas de competencia son:
  - **Células nuevas**: Se asignan al jugador con más vecinos
  - **Empates**: Se decide aleatoriamente
- La simulación continúa hasta:
  - Que un jugador domine >70% del tablero
  - Se alcancen 100 generaciones
  - Todas las células mueran (raro)

### 🏆 Condiciones de Victoria
| Escenario | Ganador |
|-----------|---------|
| Un jugador tiene >70% de células | Jugador dominante |
| Tras 100 generaciones | Jugador con más células |
| Todas las células mueren | Empate |

### 🕹️ Controles Básicos
- **Toque simple**: Alterna células
- **Arrastre**: Coloca múltiples células
- **PAUSA**: Detiene la simulación
- **REINICIAR**: Vuelve a la fase de colocación

### 💡 Estrategias Recomendadas
1. Crea patrones estables (bloques, colmenas)
2. Usa "naves espaciales" para invadir
3. Protege tus patrones clave
4. Mantén reservas en esquinas

## Tecnologías Utilizadas
- **Flutter** + **Flame** (motor de juego)
- **Provider** (gestión de estado)
- **Dart** (lenguaje)

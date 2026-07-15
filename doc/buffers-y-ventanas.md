# Buffers, ventanas y pestañas en Neovim

Guía de referencia para gestionar buffers y organizar las pantallas (ventanas/splits). Incluye tanto los comandos nativos de Neovim como los keymaps propios de esta config (leader = `<Space>`).

## Conceptos clave

Antes de las teclas, conviene tener claro el modelo mental de Neovim, porque es distinto al de otros editores:

- **Buffer**: un archivo cargado en memoria. Puedes tener 50 buffers abiertos aunque solo veas uno. Un buffer no desaparece al dejar de verlo.
- **Ventana (window)**: un "viewport" que muestra un buffer. Los splits son ventanas. Varias ventanas pueden mostrar el mismo buffer a la vez.
- **Pestaña (tab)**: una colección de ventanas (un layout). No es "un archivo por pestaña" como en VS Code; es más bien "un espacio de trabajo por pestaña".

```
Tab 1                          Tab 2
┌──────────┬──────────┐        ┌─────────────────────┐
│ ventana  │ ventana  │        │      ventana        │
│ buffer A │ buffer B │        │      buffer A       │
├──────────┴──────────┤        │  (el mismo buffer   │
│  ventana → buffer C │        │   puede verse aquí) │
└─────────────────────┘        └─────────────────────┘
```

---

## Buffers

### Listar y cambiar de buffer

| Tecla / Comando | Modo | Descripción |
| --- | --- | --- |
| `<leader>sb` | normal | **(esta config)** Picker de Telescope con los buffers abiertos — la forma más cómoda de saltar entre ellos |
| `:ls` o `:buffers` | comando | Lista todos los buffers con su número y estado (`%` = actual, `#` = alterno, `+` = modificado) |
| `:b <n>` | comando | Ir al buffer número `n` (ej. `:b 3`) |
| `:b <texto><Tab>` | comando | Ir a un buffer por nombre parcial con autocompletado (ej. `:b remap`) |
| `:bnext` / `:bn` | comando | Buffer siguiente |
| `:bprev` / `:bp` | comando | Buffer anterior |
| `:bfirst` / `:blast` | comando | Primer / último buffer |
| `<C-^>` (Ctrl+6) | normal | Alternar con el buffer anterior (el "alterno") — imprescindible para saltar entre dos archivos |

### Cerrar buffers

| Comando | Descripción |
| --- | --- |
| `:bd` | Cierra (elimina) el buffer actual. Si tiene cambios sin guardar, avisa |
| `:bd!` | Cierra descartando cambios |
| `:bd 3 5` | Cierra los buffers 3 y 5 |
| `:%bd` | Cierra todos los buffers |
| `:%bd \| e#` | Truco: cierra todo y reabre solo el buffer en el que estabas |

> **Ojo**: `:q` cierra la *ventana*, no el buffer. El buffer sigue en `:ls`. Para quitarlo de la lista usa `:bd`.

### Harpoon (esta config)

Para los 4-5 archivos en los que trabajas constantemente, Harpoon es más rápido que cualquier lista de buffers:

| Tecla | Descripción |
| --- | --- |
| `<leader>ha` | Añadir el archivo actual a Harpoon |
| `<leader>hm` / `<leader><space>` | Abrir el menú rápido de Harpoon |
| `<leader>hn` / `<leader>hp` | Saltar a la marca siguiente / anterior |
| `<leader>sm` | Ver las marcas de Harpoon en Telescope |

---

## Ventanas (splits): ordenar las pantallas

### Crear splits

| Tecla / Comando | Modo | Descripción |
| --- | --- | --- |
| `<C-w>s` o `:sp [archivo]` | normal | Split horizontal (uno encima de otro) |
| `<C-w>v` o `:vsp [archivo]` | normal | Split vertical (lado a lado) |
| `<C-w>n` o `:new` | normal | Split horizontal con un buffer vacío |
| `:sb <n>` | comando | Abrir el buffer `n` en un split horizontal |
| `:vert sb <n>` | comando | Abrir el buffer `n` en un split vertical |

### Moverse entre ventanas

| Tecla | Modo | Descripción |
| --- | --- | --- |
| `<C-h>` | normal | **(esta config)** Ir a la ventana de la izquierda |
| `<C-j>` | normal | **(esta config)** Ir a la ventana de abajo |
| `<C-k>` | normal | **(esta config)** Ir a la ventana de arriba |
| `<C-l>` | normal | **(esta config)** Ir a la ventana de la derecha |
| `<C-w>w` | normal | Ciclar a la siguiente ventana |
| `<C-w>p` | normal | Volver a la ventana anterior (previous) |
| `<C-w>t` / `<C-w>b` | normal | Ir a la ventana superior-izquierda / inferior-derecha |

### Reordenar ventanas (mover el split de sitio)

Aquí está la clave de "ordenar las pantallas". Las versiones en **mayúscula** mueven la ventana actual:

| Tecla | Descripción |
| --- | --- |
| `<C-w>H` | Mover la ventana actual todo a la **izquierda** (ocupa toda la altura) |
| `<C-w>J` | Mover la ventana actual todo **abajo** (ocupa todo el ancho) |
| `<C-w>K` | Mover la ventana actual todo **arriba** |
| `<C-w>L` | Mover la ventana actual todo a la **derecha** |
| `<C-w>r` | Rotar las ventanas de la fila/columna actual |
| `<C-w>x` | Intercambiar la ventana actual con la siguiente |
| `<C-w>T` | Convertir la ventana actual en una pestaña nueva |

Ejemplo: si tienes dos splits horizontales y los quieres en vertical, ponte en uno y pulsa `<C-w>H` o `<C-w>L`.

### Redimensionar ventanas

| Tecla / Comando | Descripción |
| --- | --- |
| `<C-w>=` | Igualar el tamaño de todas las ventanas (el más usado) |
| `<C-w>+` / `<C-w>-` | Aumentar / reducir la altura una línea |
| `<C-w>>` / `<C-w><` | Aumentar / reducir el ancho una columna |
| `<C-w>_` | Maximizar la altura de la ventana actual |
| `<C-w>\|` | Maximizar el ancho de la ventana actual |
| `:resize 20` | Fijar la altura a 20 líneas |
| `:vertical resize 80` | Fijar el ancho a 80 columnas |
| `10<C-w>+` | Los comandos aceptan contador: aumenta 10 líneas de golpe |

### Cerrar ventanas

| Tecla / Comando | Descripción |
| --- | --- |
| `<C-w>q` o `:q` | Cerrar la ventana actual (el buffer sigue abierto) |
| `<C-w>o` o `:only` | Cerrar **todas las demás** ventanas y quedarse solo con la actual |
| `:qa` | Cerrar todas las ventanas y salir de Neovim |

---

## Pestañas (tabs)

Útiles cuando quieres dos layouts distintos (por ejemplo, código en una pestaña y tests en otra):

| Tecla / Comando | Descripción |
| --- | --- |
| `:tabnew [archivo]` | Abrir una pestaña nueva |
| `gt` / `gT` | Pestaña siguiente / anterior |
| `2gt` | Ir a la pestaña 2 |
| `:tabclose` | Cerrar la pestaña actual |
| `:tabonly` | Cerrar todas las demás pestañas |
| `<C-w>T` | Mover la ventana actual a una pestaña nueva |
| `:tabmove 0` | Mover la pestaña al principio |

---

## Flujos de trabajo recomendados

1. **Dos archivos relacionados** (código + test): `:vsp`, abre el otro con `<leader>sf`, y alterna con `<C-h>` / `<C-l>`.
2. **Saltar entre muchos archivos**: no abras un split por archivo; mantén una sola ventana y usa `<leader>sb` (Telescope) o Harpoon.
3. **Ping-pong entre dos archivos**: `<C-^>` alterna con el buffer anterior sin abrir nada.
4. **El layout se ha descuadrado**: `<C-w>=` lo iguala todo; `<C-w>o` cierra el ruido y te deja solo con la ventana actual.
5. **Quiero este split en el otro lado**: `<C-w>H` / `<C-w>L` (o `J`/`K` para arriba/abajo).

## Ayuda nativa

- `:help windows` — todo sobre ventanas
- `:help buffers` — todo sobre buffers
- `:help CTRL-W` — lista completa de comandos `<C-w>`
- `<leader>sk` — buscar keymaps de esta config con Telescope

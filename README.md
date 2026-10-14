# Rosewood
Rosewood is a wayland Desktop Enviroment.
It has one palette.
It makes the color files for many programs from that palette.

## Requirements

Install these programs:
- `matugen`: makes the color files
- `jq`: reads and writes the JSON data
- `stow`:  puts the files in your home directory
- `sway` and `swaymsg`: the window manager

These programs are optional:
- `foot`: the terminal
- `rofi`: the application menu
- `mako`: the notification program
- `nvim`: the text editor
- `clipman`, `swaylock`, and `swayidle`: small desktop tools
- `sddm`: the login screen

## Installation

1. Install the deps from "Requirements".
2. Clone the repo:
   ```
   git clone https://github.com/z3nnix/rosewood.git
   cd rosewood
   ```

3. Install:
   ```
   ./home/.local/bin/rosewood install
   ```
   It checks deps, runs stow, then adds the session entry (asks for root).

4. Pick a mode (required):
   ```
   rosewood mode strict
   ```
   **or**
   ```
   rosewood mode adaptive
   ```

5. Set a wallpaper:
   ```
   rosewood apply wallpaper0.jpg
   ```
   It looks up the wallpaper, picks the flavor, writes the color files.

6. Open a new terminal and you're good.

## Colors

| Hex | Role | Use |
| --- | --- | --- |
| `#0E0A0D` | `bg` | Base background |
| `#1A1418` | `bg_soft` | Panels, bars, popups, statusline |
| `#2A2028` | `bg_alt` | Inactive tabs, dividers |
| `#3A2E35` | `bg_sel` | Selection, highlights |
| `#F2D5C4` | `fg` | Primary text |
| `#5C4A52` | `muted` | Comments, line numbers, disabled |
| `#C77D9A` | `rose` | Primary accent: focus, active actions |
| `#6A8A9A` | `steel` | Secondary accent: strings, types, links |
| `#D9534F` | `red` | Errors, danger |

### Terminal

| Slot | Hex |
| --- | --- |
| bg | `#1F1122` |
| fg | `#F2C9A8` |
| 0 black | `#2B1D1D` |
| 1 red | `#C96B5E` |
| 2 green | `#8C6B4A` |
| 3 yellow | `#E8B87A` |
| 4 blue | `#D4B8A8` |
| 5 magenta | `#C98A8A` |
| 6 cyan | `#A88A7A` |
| 7 white | `#E8D8C8` |
| 8 br black | `#4A3535` |
| 9 br red | `#E88A7A` |
| 10 br green | `#A88A6A` |
| 11 br yellow | `#F2D8A8` |
| 12 br blue | `#F2E8D8` |
| 13 br magenta | `#E8B8B8` |
| 14 br cyan | `#C8B8A8` |
| 15 br white | `#FFFFFF` |

> ANSI hints:
> red: errors
> green: success
> yellow: warnings
> blue: paths and structure
> magenta: constants
> cyan: keys and metadata

## License

MIT. See the `LICENSE` file.

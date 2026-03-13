# uart_rx_leds

Receives ASCII characters over UART and toggles individual LEDs on the
**Lattice iCE40-HX8K breakout board**.

## What it does

Send a single character from a serial terminal at 9600 baud:

| Character | Effect |
|---|---|
| `0` – `7` | Toggle the corresponding LED |
| `r` | Turn off all LEDs |
| `a` | Turn on all LEDs |

Any other character is ignored.

## Build and flash

```bash
make        # synthesise, place-and-route, and pack the bitstream
make burn   # flash the bitstream to the board
```

The compiled output is written to `./build/`.

## Interact via serial terminal

Open a serial session with `screen`:

```bash
screen /dev/{fpga_port} 9600
```

Type any of the commands from the table above. To close the session press `Ctrl-A` then `k`.
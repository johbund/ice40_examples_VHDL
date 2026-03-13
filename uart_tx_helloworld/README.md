# uart_tx_helloworld

Continuously transmits "Hello, World! " over UART on the
**Lattice iCE40-HX8K breakout board**.

## What it does

After flashing, the board transmits the string "Hello, World! " repeatedly
at 9600 baud with a new character sent every 4 Hz (one character per 250 ms).

## Build and flash

```bash
make        # synthesise, place-and-route, and pack the bitstream
make burn   # flash the bitstream to the board
```

The compiled output is written to `./build/`.

## Read the output via serial terminal

Open a serial session with `screen`:

```bash
screen /dev/{fpga_port} 9600
```

The output should appear character by character in the terminal.
To close the session press `Ctrl-A` then `k`.
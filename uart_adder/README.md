# uart_adder

Receives two unsigned bytes over UART, adds them together, and transmits
the result back — all on the **Lattice iCE40-HX8K breakout board**.

## What it does

Send two bytes to the FPGA. It computes their unsigned sum and transmits
the result as a single byte back. Overflow wraps silently (modulo 256).

## Build and flash

```bash
make        # synthesise, place-and-route, and pack the bitstream
make burn   # flash the bitstream to the board
```

The compiled output is written to `./build/`.

## Test with Python

This folder contains the test script `test.py`, which querys two input numbers and prints the result.

The script requires [pyserial](https://pypi.org/project/pyserial/).

Then send two decimal numbers and read the result:

```bash
python3 test.py
```

Replace `/dev/ttyUSB1` with the actual port on your machine. The `timeout=2` prevents
the script from hanging if no response arrives.
# iCE40-HX8K VHDL examples

A collection of examples for testing and experimenting with the
[Lattice iCE40-HX8K breakout board](https://www.latticesemi.com/Products/DevelopmentBoardsAndKits/iCE40HX8KBreakoutBoard).
Each example is written in VHDL and targets the open-source IceStorm toolchain
with GHDL for synthesis. The examples have been designed to test functionality 
of the toolchain and learn more about VHDL programming and UART communication.

---

## Toolchain

The following tools are required to build and flash the examples:

- **GHDL** — VHDL simulator and synthesiser, used as a Yosys plugin via `ghdl-synth`.
  [github.com/ghdl/ghdl](https://github.com/ghdl/ghdl)
- **Yosys** — synthesis framework, drives the GHDL plugin and produces a netlist.
  [github.com/YosysHQ/yosys](https://github.com/YosysHQ/yosys)
- **nextpnr-ice40** — place-and-route tool for the iCE40 family.
  [github.com/YosysHQ/nextpnr](https://github.com/YosysHQ/nextpnr)
- **icepack / iceprog** — pack the routed design into a bitstream and flash it to the board.
  Part of [Project IceStorm](https://github.com/YosysHQ/icestorm)

---

## Quick start

Clone the repository and navigate to any example folder:

```bash
git clone https://github.com/johbund/ice40_examples_VHDL.git ice40_examples
cd ice40_examples
cd uart_rx_leds
```

Build and flash:

```bash
make        # synthesise, place-and-route, and pack the bitstream
make burn   # flash the bitstream to the board over USB
```

---

## Examples

### uart_rx_leds
Receives single ASCII characters over UART and toggles the corresponding LED
on the board. Characters `0`–`7` toggle individual LEDs, `r` turns all LEDs
off, and `a` turns all LEDs on. A simple starting point to verify that the UART
transmit path is working correctly and play with the onboard LEDs. 

### uart_tx_helloworld
Continuously transmits the string "Hello, World! " over UART at 4 Hz — one
character every 250 ms. Useful for practising how to read serial input from 
to the host.

### uart_adder
The FPGA receives two unsigned bytes over UART, computes their sum using a
combinatorial adder, and transmits the result back as a single unsigned byte.
Introduces a simple finite state machine and shows how to combine UART
receive and transmit in a single design.

---

## Hardware and host setup

### Hardware

The examples run on the **Lattice iCE40-HX8K breakout board**. The board is
connected to the host via a single USB cable, which provides both
programming (via `iceprog`) and UART communication.

### Host

These examples have been developed and tested on a **Raspberry Pi 3 Model B**
running **Debian GNU/Linux 13 (Trixie)**. Any Linux system with the toolchain
installed should work.

### UART

All examples use **9600 baud, 8N1**. The board appears as a USB serial device,
typically `/dev/ttyUSB0`. To open a serial session:

```bash
screen /dev/ttyUSB0 9600
```

To close the session press `Ctrl-A` then `k`.

Each example folder contains a README with further instructions specific to
that example.
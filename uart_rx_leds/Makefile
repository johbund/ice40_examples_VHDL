WORKDIR = ./build
PROJECT = uart_rx_leds_top

FILES = top.vhdl uart_rx.vhdl
PINMAP = pinmap.pcf

.PHONY: all clean burn

all: $(WORKDIR)/$(PROJECT).bin

$(WORKDIR)/$(PROJECT).bin: $(FILES) $(PINMAP)
	mkdir -p $(WORKDIR)
	yosys -m ghdl -p 'ghdl --std=08 --workdir=$(WORKDIR) $(FILES) -e $(PROJECT); synth_ice40 -json $(WORKDIR)/$(PROJECT).json'
	nextpnr-ice40 --hx8k --package ct256 --pcf $(PINMAP) --asc $(WORKDIR)/$(PROJECT).asc --json $(WORKDIR)/$(PROJECT).json
	icepack $(WORKDIR)/$(PROJECT).asc $(WORKDIR)/$(PROJECT).bin

burn: $(WORKDIR)/$(PROJECT).bin
	iceprog $(WORKDIR)/$(PROJECT).bin

clean:
	rm -rf $(WORKDIR)

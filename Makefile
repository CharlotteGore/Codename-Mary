# Project setup
PROJ      = mary
BUILD     = ./build
DEVICE    = hx8k
FOOTPRINT = ct256
LOGS 	  = ./log
PINMAP    = ./pinmap.pcf
TARGET_FREQ = 96

# Files
FILES = ./src/top.v

.PHONY: all clean burn

all:
	# if build folder doesn't exist, create it
	mkdir -p $(LOGS)
	mkdir -p $(BUILD)
	# synthesize using Yosys
	yosys -p "synth_ice40 -top top -json $(BUILD)/$(PROJ).json" $(FILES) > $(LOGS)/yosys.log
	# Place and route using nextpnr
	nextpnr-ice40 --$(DEVICE) --package $(FOOTPRINT) --pcf $(PINMAP) --freq $(TARGET_FREQ) --opt-timing --asc ./build/$(PROJ).asc --json $(BUILD)/$(PROJ).json > $(LOGS)/nextpnr.log
	# Convert to bitstream using IcePack
	icepack $(BUILD)/$(PROJ).asc $(BUILD)/$(PROJ).bin

timing:
	icetime -tmd $(DEVICE) -c $(TARGET_FREQ) -p $(PINMAP) -r $(LOG)/timing-report.log $(BUILD)/$(PROJ).asc

burn:
	iceprog $(BUILD)/$(PROJ).bin

clean:
	rm build/*
 
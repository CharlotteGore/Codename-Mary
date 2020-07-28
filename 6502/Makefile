# Project setup
BUILD     = ./build
DEVICE	  = AT28C256
OUT 	  = rom.bin

# Files
IN = rom.s

.PHONY: all clean burn

all:
	# if build folder doesn't exist, create it
	mkdir -p $(BUILD)
	# Assemble ROM using vasm
	vasm6502_oldstyle -dotdir $(IN) -Fbin -o $(BUILD)/$(OUT)

burn:
	minipro -p "$(DEVICE)" -w $(BUILD)/$(OUT)

clean:
	rm build/*
 
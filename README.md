# Mary, The Custom Chip

Codename Mary is a custom chip (synthesised onto an Lattice iCE40HX8k FPGA) for a hobby 6502 based computer. Mary does (is supposed to do)

- Mapping the 65C02's 64k memory space to devices in the computer (ROM, RAM, SID etc)
- UART, to let the CPU communicate via Serial with the outside world
- Timer Interrupts - Implements a "fake" scanline counter to trigger 50hz interrupts

Where possible the addresses used by Mary are meant to be the same as those used by the Commodore 64, at least enough that code designed
to play music on the SID SHOULD work on this computer too. Specifically this requires the SID to be at $d400 and for Timer Interrupts to be
at the same address as the VICII chip.

Currently Mary lives on an iCE40HX8K Breakout Board.

## Dependencies

Building is done with the Icestorm toolchain. [Follow the documentation here](http://www.clifford.at/icestorm/).

## Synthized / Place and Route

`make`

## Burn

`make burn`

## Notes

All of this stuff works fine in the simulator but doesn't work on the actual hardware which is extremely frustrating so please do not use any of this code, it's most likely completely garbage at this point. Something something crossing clock domains something something metastability.

## Roadmap

Actually get it working, I guess? After what I currently have is actually working I will be working on getting some ROM routines to enable interacting with 
the computer, and then for Mary I will be working on video output. 
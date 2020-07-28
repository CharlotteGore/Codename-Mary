# Computer ROM

This is massively work in progress with currently just a few random bits of code to test various Mary features.

## Dependencies

Assembly requires `vasm6502_oldstyle` which can be [built from source](https://github.com/mbitsnbites/vasm-mirror). Burning requires an EEPROM programmer. I have a TL866II Plus and use `minipro` for this, which is available on [gitlabs](https://gitlab.com/DavidGriffith/minipro/).

## Build

`make`

## Burn

`make burn`

## The EEPROM chip

For now the computer is using the classic AT28C256, which is a 32k EEPROM. It's pretty slow and probably caps the computer to something like 2mhz. The solution is almost certainly to shadow the ROM contents to fast RAM on boot up. Not critical for now as only intending to run the W65C02 at 1mhz for now.
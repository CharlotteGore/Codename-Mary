// NOTES:
// R9, G1 are Global Inputs, should be used for Reset/Clock wires.
// J3 is a global input and this has the 12mhz clock input.
// There are other global wires that can be used internally, most are not hooked up. There's one left actually 
// connected after we use 3 of them.
// IO0-3 are connected to the VCCIO of the FPGA, around 3.3v. 



Bank2/J3: 
|GND|T1 |R2 |R3 |GND|T5 |T6 |T7 |GND|T9 |P8 |T10|GND|T11|N10|N12|GND|T13|T15|R16|
|   |NC |SYN|DO2|   |D05|DO6|BEB|   |A00|A02|A04|   |A06|   |   |   |   |   |CBE|

|GND|T2 |T3 |R4 |GND|R5 |R6 |T8 |GND|R9*|P9 |R10|GND|P10|M11|P13|GND|T14|T16|IO2|
|   |RST|DO0|DO1|   |DO4|DO3|DO7|   |Ø2 |A01|A03|   |A05|   |   |   |NC |NC |   |

Bank3/J4
|GND|B1 |C1 |D1 |GND|E2 |F2 |G2 |GND|H2 |J2 |K3 |GND|L3 |M2 |N3 |GND|P1 |3.3|3.3|
|   |VPB|DI1|DI3|   |DI5|DI7|IRQ|   |ROM|HRM|NMI|   |A07|A09|A11|   |A13|   |   |

|GND|B2 |C2 |D2 |GND|F1 |G1*|H1 |GND|J3*|J1 |K1 |GND|L1 |M1 |N2 |GND|P2 |R1 |IO3|
|   |DI0|DI2|DI4|   |DI6|RWB|RDB|   |   |LRM|SID|   |A08|A10|A12|   |A14|A15|   |


// Computer Board Header
|NC |SYC|RSB|VPB|RWB|Ø2 |DI0|DI1|DI2|DI3|DI4|DI5|DI6|DI7|A0 |A1 |A2 |A3 |A4 |A5 |A6 |A7 |A8 |A9 |A10|A11|A12|A13|A14|A15|
|DO0|DO1|DO2|DO3|DO4|DO5|DO6|DO7|BEB|RDB|IQB|ROMB|LRAMB|HRAMB|SIDB|NMIB|CBE|NC |NC|

BEB: Mary Bus Output Enable, active low
RDB: CPU Ready, can be pulled low to make the CPU stop what it's currently doing
IQB: CPU IRQ, active low.
ROMB: Rom chip select, active low
LRAMB: Ram (lower 32k) active low
HRAMB: Ram (upper 32k) active low
SIDB: SID active low
NMIB: Non-maskable interrupt, active low.
CBE: CPU Bus Enable. Active High.
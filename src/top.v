`include "memory_map.v"
`include "vic-interrupts.v"
`include "comms.v"
`include "input_cleaner.v"
`include "pll.v"
// Computer
/* module */
module top (
     clk_12mhz,
     a_addr,
     a_data, 
     data_out,
     clk_1mhz, b_en,
     cs_rom,cs_lram,cs_hram,cs_sid,cpu_int,cpu_nmi,cpu_be,
     cpu_rdy, cpu_rwb, cpu_sync, cpu_reset, cpu_vpb,
     ftdi_tx, ftdi_rx,
     leds,
    );

    // async inputs to be cleaned up
    input wire [15:0] a_addr;
    input wire [7:0] a_data;
    input wire clk_12mhz;

    input wire clk_1mhz;
    input wire cpu_rwb;
    input wire cpu_sync;
    input wire cpu_reset;
    input wire cpu_vpb;

    // outputs
    output reg [7:0] leds;
    output reg [7:0] data_out = 8'h00;

    output wire cs_rom;
    output wire cs_lram;
    output reg cs_hram = 1'b1; // not yet implemented
    output wire cs_sid;
    output wire cpu_int;

    // control signals not currently being
    // used, so set up suitable correct defaults.
    output reg cpu_nmi = 1'b1;
    output reg cpu_rdy = 1'b1;
    output reg cpu_be = 1'b1;

    // this controls whether the data out buffer actually 
    // emits the data out register to teh CPU's bus.
    output reg b_en;

    // UART I/O
    output wire ftdi_tx;
    input wire ftdi_rx;

    // hopefully this is high to begin with...
    wire reset;
    wire cpu_clk;

    // put reset on a global net.
    SB_GB cpuClk(
        .USER_SIGNAL_TO_GLOBAL_BUFFER(cpu_reset),
        .GLOBAL_BUFFER_OUTPUT(reset)
    );

    wire sysclk;
    wire locked;

    pll myPLL(
        .clock_in(clk_12mhz),
        .global_clock(sysclk),
        .locked(locked)
    );

    reg [15:0] addr;
    reg [7:0] data_in;

    wire cs_mary;

    reg reset = 0;

    wire [7:0] comms_out_data;
    wire [7:0] vic_out_data;
    wire comms_send_out;
    wire vic_send_out;

    always @(posedge clk_96mhz) begin
        b_en <= !(!cs_mary && clk_1mhz && cpu_rwb);
    end

    CLEANER cleaner(
        .clk_96mhz(clk_96mhz),
        .i_cpu_addr(a_addr),
        .i_cpu_data(a_data),
        .o_cpu_addr(addr),
        .o_cpu_data(data_in)
    );

    always @(posedge clk_96mhz) begin
        data_out <= (comms_send_out) ? comms_out_data : ((vic_send_out) ? vic_out_data : 8'b10101010); 
    end

    MEMORY_MAP map(
        .clk(clk_96mhz),
        .cpu_clk(cpu_clk),
        .cpu_rwb(cpu_rwb),  
        .addr(addr),
        .cs_rom(cs_rom),
        .cs_ram(cs_lram),
        .cs_sid(cs_sid),
        .cs_mary(cs_mary)
    );

    VIC_INTERRUPTS vic_int(
        .addr(addr),
        .data_in(data_in),
        .data_out(vic_out_data),
        .send_out(vic_send_out),
        .cpu_clk(cpu_clk),
        .cpu_int(cpu_int),
        .cpu_rwb(cpu_rwb),
        .debug(leds),
    );

    COMMS comms(
        .sysclk(clk_96mhz),
        .cpuclk(cpu_clk),
        .rx(ftdi_rx),
        .tx(ftdi_tx),
        .cpu_rwb(cpu_rwb),
        .addr(addr),
        .data_in(data_in),
        .data_out(comms_out_data),
        .send_out(comms_send_out),
        .reset(reset)
    );

endmodule

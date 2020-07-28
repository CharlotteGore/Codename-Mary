`ifndef COMMSCLOCK
`define COMMSCLOCK

// MIDI Baud Rate of 31250.
// System clock speed of 12mhz
// 12.000.000 / 31250 = 384. 
// need 8 cycles per bit for RX, so 384 / 8, but also takes 2 clock cycles to toggle so..
// 384 / 16, gives 24. 
module CLOCK(clk, rxclk, txclk);
  input clk;
  output reg rxclk = 1;
  output reg txclk = 1;
  
  parameter rxclk_count = 192 - 1;
  parameter txclk_count = 8 - 1;
  
  reg [8:0] tick_counter = 0;
  reg [3:0] eight_tick_counter = 0;
  
  always @(posedge clk) begin
    if (tick_counter == rxclk_count) begin
      rxclk <= ~rxclk;
      tick_counter <= 0;
    end 
    else
      tick_counter <= tick_counter + 1;
  end
  
  always @(posedge rxclk) begin
    if (eight_tick_counter == txclk_count) begin
      txclk <= ~txclk;
      eight_tick_counter <= 0;
    end
    else
      eight_tick_counter <= eight_tick_counter + 1;
  end

endmodule

`endif
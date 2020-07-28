`ifndef VICINT
`define VICINT

module VIC_INTERRUPTS(addr, data_in, data_out, send_out, cpu_clk, cpu_rwb, cpu_int, debug);
  input wire [15:0] addr;
  input wire [7:0] data_in;
  output reg [7:0] data_out;
  input wire cpu_clk;
  output reg cpu_int = 1;
  input wire cpu_rwb;
  output reg send_out = 0; 
  output reg [7:0] debug = 0;

  reg [8:0] vpos = 9'b000000000;
  reg [7:0] hpos = 8'b00000000;
  reg [7:0] line = 7'b00000111;
  reg en = 0;

  wire hmaxxed = hpos == 63 -1;
  wire vmaxxed = vpos == 312 -1;

  always @(posedge cpu_clk) begin
      cpu_int <= !(en && vpos == line && hpos == 0);
      debug <= hpos;
      if (hmaxxed) begin
          hpos <= 0;
          if (vmaxxed)
              vpos <= 0;
          else
              vpos <= vpos + 1;
      end
      else
          hpos <= hpos + 1;

    if (cpu_rwb == 1) begin
      if (addr == 16'hd012) begin
        data_out <= line;
        send_out <= 1;
      end
      else if (addr == 16'hd01a) begin
        data_out <= {7'b0, en };
        send_out <= 1;
      end
      else if (addr == 16'hd010) begin
        data_out <= vpos[7:0];
        send_out <= 1;
      end
      else
        send_out <= 0;
    end
   	else begin
      send_out <= 0;
      if (addr == 16'hd01a && data_in[0] == 1) begin
          en <= 1;
      end
      else if (addr == 16'hd01a && data_in[0] == 0) begin
          en <= 0;
      end
      else if (addr == 16'hd012) begin
          line <= data_in;
      end
      else
        en <= en;
        line <= line;
    end
  end

endmodule


`endif
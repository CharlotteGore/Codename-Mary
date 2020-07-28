module ONEPING(clk, in, data, out, outdata);
  input wire clk;
  input wire in;
  input wire [7:0] data;
  output reg  [7:0] outdata;
  output reg out = 0;
  
  reg fixed = 0;
  
  always @(posedge clk) begin
    if (in == 1 && fixed == 0) begin
      fixed <= 1;
      outdata <= data;
      out <= 1;
    end
    if (fixed == 1) begin
      out <= 0;
    end
    if (in == 0 && fixed == 1) begin
      fixed <= 0;
    end
  end
endmodule
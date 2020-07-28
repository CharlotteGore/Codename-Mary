`ifndef MAJORITY
`define MAJORITY

module MAJORITY(bits, majority);
input wire [7:0] bits;
output wire majority;
assign majority = (bits[0] & bits[1] & bits[2] & bits[3] & bits[4]) ||
    (bits[0] & bits[1] & bits[2] & bits[3] & bits[5]) ||
    (bits[0] & bits[1] & bits[2] & bits[3] & bits[6]) ||
    (bits[0] & bits[1] & bits[2] & bits[3] & bits[7]) ||
    (bits[0] & bits[1] & bits[2] & bits[4] & bits[5]) ||
    (bits[0] & bits[1] & bits[2] & bits[4] & bits[6]) ||
    (bits[0] & bits[1] & bits[2] & bits[4] & bits[7]) ||
    (bits[0] & bits[1] & bits[2] & bits[5] & bits[6]) ||
    (bits[0] & bits[1] & bits[2] & bits[5] & bits[7]) ||
    (bits[0] & bits[1] & bits[2] & bits[6] & bits[7]) ||
    (bits[0] & bits[1] & bits[4] & bits[5] & bits[6]) ||
    (bits[0] & bits[1] & bits[4] & bits[5] & bits[7]) ||
    (bits[0] & bits[1] & bits[4] & bits[6] & bits[7]) ||
    (bits[0] & bits[1] & bits[5] & bits[6] & bits[7]) ||
    (bits[0] & bits[2] & bits[3] & bits[4] & bits[5]) ||
    (bits[0] & bits[2] & bits[3] & bits[4] & bits[6]) ||
    (bits[0] & bits[2] & bits[3] & bits[4] & bits[7]) ||
    (bits[0] & bits[2] & bits[3] & bits[5] & bits[6]) ||
    (bits[0] & bits[2] & bits[3] & bits[5] & bits[7]) ||
    (bits[0] & bits[2] & bits[3] & bits[6] & bits[7]) ||
    (bits[0] & bits[3] & bits[4] & bits[5] & bits[6]) ||
    (bits[0] & bits[3] & bits[4] & bits[5] & bits[7]) ||
    (bits[0] & bits[3] & bits[4] & bits[6] & bits[7]) ||
    (bits[0] & bits[3] & bits[5] & bits[6] & bits[7]) ||
    (bits[0] & bits[4] & bits[5] & bits[6] & bits[7]) ||
    (bits[1] & bits[2] & bits[3] & bits[4] & bits[5]) ||
    (bits[1] & bits[2] & bits[3] & bits[4] & bits[6]) ||
    (bits[1] & bits[2] & bits[3] & bits[4] & bits[7]) ||
    (bits[1] & bits[2] & bits[3] & bits[5] & bits[6]) ||
    (bits[1] & bits[2] & bits[3] & bits[5] & bits[7]) ||
    (bits[1] & bits[2] & bits[3] & bits[6] & bits[7]) ||
    (bits[1] & bits[2] & bits[4] & bits[5] & bits[6]) ||
    (bits[1] & bits[2] & bits[4] & bits[5] & bits[7]) ||
    (bits[1] & bits[2] & bits[4] & bits[6] & bits[7]) ||
    (bits[1] & bits[2] & bits[5] & bits[6] & bits[7]) ||
    (bits[1] & bits[3] & bits[4] & bits[5] & bits[6]) ||
    (bits[1] & bits[3] & bits[4] & bits[5] & bits[7]) ||
    (bits[1] & bits[3] & bits[4] & bits[6] & bits[7]) ||
    (bits[1] & bits[3] & bits[5] & bits[6] & bits[7]) ||
    (bits[1] & bits[4] & bits[5] & bits[6] & bits[7]) ||
    (bits[2] & bits[3] & bits[4] & bits[5] & bits[6]) ||
    (bits[2] & bits[3] & bits[4] & bits[5] & bits[7]) ||
    (bits[2] & bits[3] & bits[4] & bits[6] & bits[7]) ||
    (bits[2] & bits[3] & bits[5] & bits[6] & bits[7]) ||
    (bits[2] & bits[4] & bits[5] & bits[6] & bits[7]) ||
    (bits[3] & bits[4] & bits[5] & bits[6] & bits[7]);

endmodule

`endif
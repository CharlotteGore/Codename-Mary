// Code your design here
`ifndef FIFO
`define FIFO


`define BUF_WIDTH 9
`define BUF_SIZE 1<<`BUF_WIDTH

module FIFO(wclk, rclk, fifo_write_en, fifo_read_en, wdata, rdata, fifo_full, fifo_empty, reset );
    input wire wclk, rclk, fifo_read_en, fifo_write_en, reset;
    output wire fifo_empty, fifo_full;

    reg [`BUF_WIDTH: 0] radd = 0;
    reg [`BUF_WIDTH: 0] wadd = 0;
    input wire [7:0] wdata;
    output reg [7:0] rdata;

    reg [7:0] mem[0:`BUF_SIZE -1];

    wire sysclk;
    
    assign sysclk = (rclk || wclk);

  	assign fifo_empty = (wadd == radd);
  	assign fifo_full = ({~wadd[`BUF_WIDTH],wadd[`BUF_WIDTH -1: 0]} == radd);

    always @( posedge rclk) begin
		if (!fifo_empty)
           rdata <= mem[radd];
    end

    always @( posedge wclk) begin
        if (fifo_write_en && !fifo_full)
            mem[wadd] <= wdata;
    end

    always @( posedge rclk or posedge reset) begin
        if (reset)
            radd <= 0;
        else
        if (!fifo_empty && fifo_read_en) radd <= radd + 1;
        else
            radd <= radd;
    end

    always @( posedge wclk or posedge reset) begin
        if (reset)
            wadd <= 0;
        else
        if (!fifo_full && fifo_write_en) wadd <= wadd + 1;
        else
            wadd <= wadd;
    end


endmodule

`endif
`ifndef UART_RX
`define UART_RX

`include "fifo.v"
`include "majority.v"


module UART_RX(clk, rxclk, rx, rx_en, next_rx, rx_data, rx_rdy, rxing, reset, rx_success  
     );
    input wire clk; // the clock
    input wire rxclk;
    input wire rx; // the input rx wire
    input wire rx_en; // enable receiving remote data
    input wire next_rx; // put the next received byte into rx_data
    output reg [7:0] rx_data; // received bytes go here.

  	input wire reset;
    wire rx_full;
  	wire rx_empty;

  	output wire rx_success;
    output wire rx_rdy; // a received byte is waiting.
    output wire rxing;

    reg rx_byte = 0;
    reg [7:0] rx_buf_data = 0; // incoming bits go here 
    reg [7:0] rx_bit_buf = 0; // incoming sub-bits go here
    wire bitval;

    parameter STATE_WAITING = 4'd0;
    parameter STATE_STARTBIT = 4'd1;
    parameter STATE_RECEIVING = 4'd2;
    parameter STATE_STOPBIT = 4'd3;

    reg [3:0] state = STATE_WAITING;
    reg [3:0] bit_aggregator_count = 0;
    reg [3:0] bit_counter = 0;

    assign rx_rdy = !rx_empty; 
    assign rxing = (state == STATE_RECEIVING);
    assign rx_success = rx_byte;

    // FIFO!
    FIFO rx_buffer(
        .wclk(rxclk),
        .rclk(clk),
        .fifo_write_en(rx_byte),
        .fifo_read_en(next_rx),
        .wdata(rx_buf_data),
        .rdata(rx_data),
        .fifo_full(rx_full),
        .fifo_empty(rx_empty),
        .reset(reset)
    );

    // reduces 8 bits to 1, if more than half of the bits are 1 then you get 1, otherwise 0
    MAJORITY majority(
        .bits(rx_bit_buf),
        .majority(bitval)
    );

    reg startbit;

  always @(posedge clk) begin
    if (rx == 0 && state == STATE_WAITING)
            startbit <= 1;
        else 
            startbit <= 0;
    end

    always @(posedge rxclk) begin
      if (rx_byte == 1)
        rx_byte = 0;
        if (state == STATE_WAITING && startbit == 1) 
            state <= STATE_STARTBIT;
      		bit_aggregator_count <= 0;
        if (state == STATE_STARTBIT) begin
            rx_buf_data <= 0;
            rx_bit_buf <= 0;
            if (bit_aggregator_count < 7) begin
                rx_bit_buf[bit_aggregator_count] <= rx;
                bit_aggregator_count <= bit_aggregator_count + 1;
            end
            else begin
                bit_aggregator_count <= 0;
                if (bitval == 0) begin
                    state <= STATE_RECEIVING;
                  	rx_bit_buf <= 0;
                    bit_counter <= 0;
                end
                else
                    state <= STATE_WAITING;
            end

        end
        else if (state == STATE_STARTBIT && bit_aggregator_count == 7) begin
            if (bitval == 0) begin // successful start bit
                state <= STATE_RECEIVING;
                bit_aggregator_count <= 0;
            end
            else begin
                state <= STATE_WAITING;
                bit_aggregator_count <= 0;
            end
        end
        else if (state == STATE_RECEIVING) begin
            if (bit_counter < 7) begin
                if (bit_aggregator_count < 7) begin
                    rx_bit_buf[bit_aggregator_count] <= rx;
                    bit_aggregator_count <= bit_aggregator_count + 1;
                end
                else begin
                    rx_buf_data[bit_counter] <= bitval;
                    bit_counter <= bit_counter + 1;
                    bit_aggregator_count <= 0;
                end
            end
            else if (bit_counter == 7 && bit_aggregator_count < 7) begin
                rx_bit_buf[bit_aggregator_count] <= rx;
                bit_aggregator_count <= bit_aggregator_count + 1;
            end
            else if (bit_counter == 7 && bit_aggregator_count == 7) begin
                rx_buf_data[bit_counter] <= bitval;
                bit_aggregator_count <= 0;
                bit_counter <= 0;
                state <= STATE_STOPBIT;
            end

        end
        else if (state == STATE_STOPBIT) begin
            if (bit_aggregator_count < 7) begin
                rx_bit_buf[bit_aggregator_count] <= rx;
                bit_aggregator_count <= bit_aggregator_count + 1;
            end
            else begin
                bit_aggregator_count <= 0;
                if (bitval == 1) begin
                    rx_byte <= 1; // latch the input into the fifo
                    bit_counter <= 0;
                    if (rx == 0) // already receiving next byte maybe!!
                        state <= STATE_STARTBIT;
                    else
                        state <= STATE_WAITING;
                end
                else begin
                  	rx_byte <= 0;
                      bit_counter <= 0;
                    if (rx == 0) // already receiving next byte maybe!!
                        state <= STATE_STARTBIT;
                    else 
                        state <= STATE_WAITING;
                end
            end
        end

    end

endmodule



`endif
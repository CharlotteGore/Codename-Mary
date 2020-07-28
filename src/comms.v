`ifndef COMMS
`define COMMS

`include "comms_clock.v"
`include "uart-rx.v"
`include "uart-tx.v"
`include "oneping.v"


module COMMS(sysclk, cpuclk, tx, rx, addr, data_in, data_out, send_out, cpu_rwb, reset);
    input wire sysclk;
    input wire cpuclk;
    output wire tx;
    input wire rx;
    input [15:0] addr;
    input wire [7:0] data_in;
    output reg [7:0] data_out;
    output reg send_out;
    input wire cpu_rwb;
    input wire reset;

    wire txclk;
    wire rxclk;

    reg tx_byte;
    reg tx_byte_once;
    reg next_rx_once;

    wire [7:0] rx_data;
    reg next_rx;

    wire [7:0] rx_buf_dat;
    reg [7:0] tx_data;

    reg rx_en = 1;
    reg tx_en = 1;
    wire rxing;
    wire rx_rdy;
    wire rx_success;
    wire tx_full;
    wire txing;

    wire donext;
    wire dotx;

    assign donext = (cpuclk && next_rx);
    assign dotx = (cpuclk && tx_byte); 


    always @(posedge cpuclk) begin
        if (addr == 16'hff01 && cpu_rwb == 1 && rx_rdy) begin
            send_out <= 1;
            data_out <= rx_data;
            next_rx <= 1;
        end
        else if (addr == 16'hff01 && cpu_rwb == 1 && !rx_rdy) begin
            send_out <= 1;
            data_out <= 8'h4; // ASCII EOT
        end
        else if (addr == 16'hff00 && cpu_rwb == 1) begin
            send_out <= 1;
            data_out <= {rx_en, tx_en, rxing, rx_rdy, rx_success, tx_full, txing, 1'b0};
        end
        // else if (addr == 16'hff00 && cpu_rwb == 0) begin
        //    send_out <= 0;
            // data_out <= 8'bZ;
        //    rx_en <= ~rx_en;
        //    tx_en <= ~tx_en;
        // end
        else if (addr == 16'hff02 && cpu_rwb == 0 && !tx_full) begin
            send_out <= 0;
            tx_data <= data_in;
            // data_out = 8'bZ;
            tx_byte <= 1;
        end
        else
            send_out <= 0;
            tx_byte <= 0;
            next_rx <= 0;
            // data_out = 8'bZ;
    end 

    CLOCK clock(
        .clk(sysclk),
        .txclk(txclk),
        .rxclk(rxclk)
    );

    reg tx_locked = 0;
    always @(posedge sysclk) begin
        if (tx_locked == 0 && dotx == 1) begin
            tx_locked <= 1;
            tx_byte_once <= 1;
        end
        else if (tx_locked == 1 && dotx == 0) begin
            tx_locked <= 0;
            tx_byte_once <= 0;
        end
        else
            tx_byte_once <= 0;
    end

/*
    ONEPING txbyte(
        .clk(sysclk),
      	.in(dotx),
        .data(uart_txbyte),
        //.data(data_in),
        .out(tx_byte_once),
        .outdata(tx_data)
    );
*/
    ONEPING rxbyte(
        .clk(sysclk),
      	.in(donext),
        .data(rx_data),
        .out(next_rx_once),
        .outdata(rx_buf_dat)
    );

    // module UART_RX(clk, rx, rx_en, next_rx, rx_data, rx_rdy, rxing, reset, rx_success);
    UART_RX uartrx(
        .clk(sysclk),
        .rxclk(rxclk),
        .rx(rx),
        .rx_en(rx_en),
        .next_rx(next_rx_once),
        .rx_data(rx_data),
        .rxing(rxing),
        .rx_rdy(rx_rdy),
        .rx_success(rx_success),
        .reset(reset)
    );

    UART_TX uarttx(
        .clk(sysclk),
        .txclk(txclk),
        .tx(tx),
        .tx_en(tx_en),
        .tx_data(tx_data),
        .tx_byte(tx_byte_once),
        .tx_full(tx_full),
        .txing(txing),
        .reset(reset)
    );

endmodule

`endif
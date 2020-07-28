// Code your design here
`ifndef UART_TX
`define UART_TX

`include "fifo.v"


// UART should probably resemble some sort of dual FIFO. Shove transmit data
// into it so long as there's space in the input buffer, pull data out of 
// as long as there's something to pull. 

module UART_TX (clk, txclk, tx_en, tx_data, tx_byte, tx, tx_full, txing, reset);
  input wire clk;
  input wire txclk;
  input wire tx_en; // enables the transmission of data
  input wire tx_byte; // instruction to transmit tx_data's byte
  input wire reset; // reset, clears the output buffers.
  output reg tx = 1; // actual transmission wire
  output wire tx_full; // indicates that the output buffer is full
  output wire txing; // indicates that the system is transmitting
  input wire [7:0] tx_data; // the data being sent.

  reg tx_buf_read = 0; // signal to extract next byte to send
  reg [7:0] tx_buf_data; // 
  wire tx_empty;

  
  assign txing = (state == STATE_TRANSMITTING || state == STATE_STARTBIT || state == STATE_STOPBIT);

  // the write part of the buffer is directly linked to 
  // the inputs, so we don't need to do anything here.

  parameter STATE_IDLE = 4'd0;
  parameter STATE_STARTBIT = 4'd1;
  parameter STATE_TRANSMITTING = 4'd2;
  parameter STATE_STOPBIT = 4'd3;

  reg [3:0] state = STATE_IDLE;
  reg [3:0] bit_counter = 0;

  FIFO tx_buffer(
    .wclk(clk), // system writes in at full speed..
    .rclk(txclk), // tx module pulls out at tx clock speed
    .fifo_write_en(tx_byte),
    .fifo_read_en(tx_buf_read),
    .wdata(tx_data),
    .rdata(tx_buf_data),
    .fifo_full(tx_full),
    .fifo_empty(tx_empty),
    .reset(reset)
  );

  always @(posedge txclk) begin
      if (!tx_en) 
        tx <= 1;
      else
        if ((state == STATE_IDLE || state == STATE_STOPBIT) && !tx_empty) 
          begin
            tx_buf_read <= 1;
            tx <= 1;
            state <= STATE_STARTBIT;
            bit_counter <= 0;
          end
    else if (state == STATE_IDLE || state == STATE_STOPBIT)
      begin
        	state <= STATE_IDLE;
            tx <= 1;
      end
          else if (state == STATE_STARTBIT) 
          begin
              tx_buf_read <= 0;
              tx <= 0;
              state <= STATE_TRANSMITTING;
          end
          else if (state == STATE_TRANSMITTING)
            if(bit_counter == 8)
            begin
                tx <= 1;
                state <= STATE_STOPBIT;
            end
            else
            begin
              tx <= tx_buf_data[bit_counter];
                bit_counter <= bit_counter + 1;
            end
   		 else if (state == STATE_STOPBIT)
      		tx <= 1;
    		

  end

endmodule

`endif
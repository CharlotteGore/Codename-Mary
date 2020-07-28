module CLEANER(
        clk_96mhz, 
        i_cpu_addr,
        i_cpu_data,
        o_cpu_addr,
        o_cpu_data
    );

    input wire clk_96mhz;

    input wire [15:0] i_cpu_addr;
    input wire [7:0] i_cpu_data;

    output reg [15:0] o_cpu_addr;
    output reg [7:0] o_cpu_data; 

    reg [15:0] m_cpu_addr;
    reg [7:0] m_cpu_data;

    always @(posedge clk_96mhz) begin
        m_cpu_addr <= i_cpu_addr;
        m_cpu_data <= i_cpu_data;
        o_cpu_addr <= m_cpu_addr;
        o_cpu_data <= m_cpu_data;
    end

endmodule
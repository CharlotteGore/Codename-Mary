// Code your design here
`ifndef MEMORY
`define MEMORY

module MEMORY_MAP(clk, cpu_clk, cpu_rwb, addr, cs_rom, cs_ram, cs_sid, cs_mary);
  input [15:0] addr;
  input clk;
  input cpu_clk;
  input cpu_rwb;
  output reg cs_rom;
  output reg cs_ram;
  output reg cs_sid;
  output reg cs_mary;

  reg write_ram = 0;
  reg ram_write_en = 0;
  reg read_ram = 0;
  reg writelock = 0;

  always @(posedge cpu_clk) begin
    if (addr < 16'h8000) begin
      cs_sid <= 1;
      cs_rom <= 1;
      cs_mary <= 1;
      if (cpu_rwb == 0) begin // CPU WISHES TO WRITE TO RAM
        write_ram <= 1;
        read_ram <= 0;
      end
      else
        write_ram <= 0;
        read_ram <= 1;
    end
    else if ((addr >= 16'hd400) && (addr < 16'hd800)) begin
      cs_rom <= 1;
      cs_sid <= 0;
      cs_mary <= 1;
      read_ram <= 0;
      write_ram <= 0;
    end
    else if ((addr >= 16'hff00 && addr <= 16'hff02) || (addr >= 16'hd000 && addr < 16'hd400)) begin
      cs_rom <= 1;
      cs_sid <= 1;
      read_ram <= 0;
      write_ram <= 0;

      cs_mary <= 0;
    end
    else begin
      cs_rom <= 0;
      cs_sid <= 1;
      cs_mary <= 1;
      read_ram <= 0;
      write_ram <= 0;
    end
  end

  reg m_write_ram;
  reg s_write_ram;

  reg m_read_ram;
  reg s_read_ram;

  reg m_cpu_rwb;
  reg s_cpu_rwb;

  always @(posedge clk) begin 
    
    // double flip-flopping various signals 
    // associated with the slower clock domain
    // this is to prevent metastability situations.
    m_write_ram <= write_ram;
    s_write_ram <= m_write_ram;

    m_read_ram <= read_ram;
    s_read_ram <= m_read_ram;

    m_cpu_rwb <= cpu_rwb;
    s_cpu_rwb <= m_cpu_rwb;

    if (!s_cpu_rwb)
      cs_ram <= 0;
    else if (s_cpu_rwb) begin
      if (s_write_ram && ram_write_en) 
        cs_ram <= 0;
      else
        cs_ram <= 1;
    end

    if (s_write_ram == 1 && writelock == 0) begin
      ram_write_en <= 1;
      writelock <= 1;
    end
    else if (s_write_ram == 1 && writelock == 1) begin
      ram_write_en <= 0;
    end
    else if (s_write_ram == 0 && writelock == 1) begin
      writelock <= 0;
      ram_write_en <= 0;
    end
  end

endmodule

`endif
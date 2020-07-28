module pll(clock_in, global_clock, locked);

  input clock_in;
  wire g_clock_int;
  wire g_lock_int;
  output global_clock;
  output locked;

  SB_GB clk_gb (
    .GLOBAL_BUFFER_OUTPUT(global_clock),
    .USER_SIGNAL_TO_GLOBAL_BUFFER(g_clock_int)
  );

  SB_GB lck_gb (
    .GLOBAL_BUFFER_OUTPUT(locked),
    .USER_SIGNAL_TO_GLOBAL_BUFFER(g_lock_int)
  );

  SB_PLL40_CORE #(
    .DIVF(7'h3f),
    .DIVQ(3'h3),
    .DIVR(4'h0),
    .FEEDBACK_PATH("SIMPLE"),
    .FILTER_RANGE(3'h1)
  ) uut (
    .BYPASS(1'h0),
    .LOCK(g_lock_int),
    .PLLOUTGLOBAL(g_clock_int),
    .REFERENCECLK(clock_in),
    .RESETB(1'h1)
  );
endmodule



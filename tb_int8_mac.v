`timescale 1ns / 1ps

module tb_int8_mac;

  // 1. Declare signals matching int8_mac
  reg clk;
  reg rst_n;
  reg enable;
  reg clr_acc;
  reg signed [7:0] in_a;
  reg signed [7:0] in_b;

  wire signed [31:0] out_acc;
  wire valid_out;

  // 2. Instantiate Unit Under Test (UUT)
  int8_mac uut (
    .clk(clk),
    .rst_n(rst_n),
    .enable(enable),
    .clr_acc(clr_acc),
    .in_a(in_a),
    .in_b(in_b),
    .out_acc(out_acc),
    .valid_out(valid_out)
  );

  // 3. Clock generation (10ns period)
  always #5 clk = ~clk;

  // 4. Test stimulus block
  initial begin
    $dumpfile("mac_waveform.vcd");
    $dumpvars(0, tb_int8_mac);

    // Initial values (Active-low reset asserted)
    clk = 0;
    rst_n = 0;
    enable = 0;
    clr_acc = 0;
    in_a = 8'sd0;
    in_b = 8'sd0;

    // Release reset
    #20;
    rst_n = 1;
    enable = 1;

    // Test 1: 5 * 4 = 20
    #10;
    in_a = 8'sd5;
    in_b = 8'sd4;

    // Test 2: Accumulate 2 * 3 = 6 (Total: 26)
    #10;
    in_a = 8'sd2;
    in_b = 8'sd3;

    // Test 3: Signed multiplication: -4 * 2 = -8 (Total: 18)
    #10;
    in_a = -8'sd4;
    in_b = 8'sd2;

    // Wait for pipeline stages to complete
    #50;
    $finish;
  end

endmodule
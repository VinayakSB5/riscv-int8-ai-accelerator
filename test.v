module test;
  reg clk;

  initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0, test);

    clk = 0;
    #10 clk = 1;
    #10 clk = 0;
    #10 clk = 1;
    #10 clk = 0;
    #10 $finish;
  end
endmodule
`timescale 1ns / 1ps

module tb_riscv_top;

    reg         clk;
    reg         reset;
    wire [31:0] pc_out;
    wire [31:0] instr_out;
    wire [31:0] alu_result_out;

    // Instantiate Top RISC-V Module
    riscv_top uut (
        .clk(clk),
        .reset(reset),
        .pc_out(pc_out),
        .instr_out(instr_out),
        .alu_result_out(alu_result_out)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("riscv_top_sim.vcd");
        $dumpvars(0, tb_riscv_top);

        clk = 0;
        reset = 1;
        #15 reset = 0;

        // Run simulation for 6 clock cycles
        repeat (6) begin
            #10;
            $display("Time=%0t | PC=0x%h | Instr=0x%h | ALU Result=0x%h", 
                      $time, pc_out, instr_out, alu_result_out);
        end

        $finish;
    end

endmodule
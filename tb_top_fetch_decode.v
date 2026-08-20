`timescale 1ns / 1ps

module tb_top_fetch_decode;

    reg         clk;
    reg         reset;
    reg  [31:0] pc_next;
    reg         pc_write;
    wire [31:0] pc;
    wire [31:0] instr;

    // Instantiate Program Counter
    pc_unit pc_inst (
        .clk(clk),
        .reset(reset),
        .pc_next(pc_next),
        .pc_write(pc_write),
        .pc(pc)
    );

    // Instantiate Instruction Memory
    instruction_memory imem_inst (
        .addr(pc),
        .instr(instr)
    );

    // Clock Generation (100 MHz)
    always #5 clk = ~clk;

    initial begin
        // Waveform file for GTKWave
        $dumpfile("fetch_sim.vcd");
        $dumpvars(0, tb_top_fetch_decode);

        // Initialize Signals
        clk = 0;
        reset = 1;
        pc_write = 1;
        pc_next = 32'h0;

        // Release reset after 15ns
        #15 reset = 0;

        // Fetch 4 consecutive instructions
        repeat (4) begin
            #10;
            $display("Time=%0t | PC=0x%h | Fetched Instruction=0x%h", $time, pc, instr);
            pc_next = pc + 32'd4;
        end

        $finish;
    end

endmodule
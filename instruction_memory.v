`timescale 1ns / 1ps

module instruction_memory (
    input  wire [31:0] addr,
    output wire [31:0] instr
);

    reg [31:0] memory [0:63];
    integer i;

    initial begin
        // 1. Initialize all memory slots with RISC-V NOPs (addi x0, x0, 0)
        for (i = 0; i < 64; i = i + 1) begin
            memory[i] = 32'h00000013;
        end

        // 2. Load input values into registers
        memory[0] = 32'h00500093; // addi x1, x0, 5   (x1 = 5)
        memory[1] = 32'h00400113; // addi x2, x0, 4   (x2 = 4)
        memory[2] = 32'h00300193; // addi x3, x0, 3   (x3 = 3)

        // 3. Custom MAC operations (opcode 7'b0001011 = 0x0B)
        // mac x5, x1, x2 -> acc = (5 * 4) = 20 (stored in x5)
        memory[3] = 32'h0020828b;

        // mac x6, x1, x3 -> acc = 20 + (5 * 3) = 35 (stored in x6)
        memory[4] = 32'h0030830b;

        // 4. Safe NOP completion
        memory[5] = 32'h00000013;
    end

    assign instr = memory[addr[31:2]];

endmodule

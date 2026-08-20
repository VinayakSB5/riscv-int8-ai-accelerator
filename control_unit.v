`timescale 1ns / 1ps

module control_unit (
    input  wire [6:0] opcode,
    input  wire [2:0] funct3,
    input  wire [6:0] funct7,
    output reg        reg_write,
    output reg        alu_src,
    output reg  [3:0] alu_control,
    output reg        mac_en,
    output reg        clr_acc,
    output reg  [1:0] wb_sel
);

    always @(*) begin
        // Safe defaults
        reg_write   = 1'b0;
        alu_src     = 1'b0;
        alu_control = 4'b0000;
        mac_en      = 1'b0;
        clr_acc     = 1'b0;
        wb_sel      = 2'b00;

        case (opcode)
            // I-Type Instructions (ADDI)
            7'b0010011: begin
                reg_write   = 1'b1;
                alu_src     = 1'b1;
                alu_control = 4'b0010; // ADD (4'b0010)
                wb_sel      = 2'b00;
            end

            // R-Type Instructions (ADD, SUB, AND, OR)
            7'b0110011: begin
                reg_write = 1'b1;
                alu_src   = 1'b0;
                wb_sel    = 2'b00;
                case (funct3)
                    3'b000: alu_control = (funct7 == 7'b0100000) ? 4'b0110 : 4'b0010; // SUB (4'b0110) : ADD (4'b0010)
                    3'b111: alu_control = 4'b0000; // AND (4'b0000)
                    3'b110: alu_control = 4'b0001; // OR  (4'b0001)
                    3'b010: alu_control = 4'b0111; // SLT (4'b0111)
                    default: alu_control = 4'b0010;
                endcase
            end

            // Custom-0: INT8 MAC Accelerator
            7'b0001011: begin
                reg_write = 1'b1;
                mac_en    = 1'b1;
                wb_sel    = 2'b01; // Route MAC Accumulator to Register File
                if (funct3 == 3'b001)
                    clr_acc = 1'b1;
            end

            default: ;
        endcase
    end

endmodule
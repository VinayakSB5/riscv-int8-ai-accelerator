// int8_mac.v: Pipelined 8-bit Signed MAC Unit
`timescale 1ns / 1ps

module int8_mac (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        enable,
    input  wire        clr_acc,     // Clears accumulator for a new dot product
    input  wire signed [7:0]  in_a, // Signed 8-bit activation
    input  wire signed [7:0]  in_b, // Signed 8-bit weight
    output reg  signed [31:0] out_acc,
    output reg         valid_out
);

    // Stage 1: Pipeline registers for multiplication
    reg signed [15:0] mult_reg;
    reg               clr_acc_d1;
    reg               en_d1;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mult_reg   <= 16'sd0;
            clr_acc_d1 <= 1'b0;
            en_d1      <= 1'b0;
        end else if (enable) begin
            mult_reg   <= in_a * in_b;
            clr_acc_d1 <= clr_acc;
            en_d1      <= 1'b1;
        end else begin
            en_d1      <= 1'b0;
        end
    end

    // Stage 2: 32-bit Accumulation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            out_acc   <= 32'sd0;
            valid_out <= 1'b0;
        end else if (en_d1) begin
            if (clr_acc_d1) begin
                out_acc <= {{16{mult_reg[15]}}, mult_reg}; // Sign-extended product
            end else begin
                out_acc <= out_acc + {{16{mult_reg[15]}}, mult_reg};
            end
            valid_out <= 1'b1;
        end else begin
            valid_out <= 1'b0;
        end
    end

endmodule
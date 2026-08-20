`timescale 1ns / 1ps

module riscv_top (
    input  wire        clk,
    input  wire        reset,
    output wire [31:0] pc_out,
    output wire [31:0] instr_out,
    output wire [31:0] alu_result_out
);

    // Internal Wires
    wire [31:0] pc;
    wire [31:0] pc_next;
    wire        pc_write;
    wire [31:0] instr;
    wire [31:0] rd_data1;
    wire [31:0] rd_data2;
    wire [31:0] alu_result;
    wire [31:0] wr_data;
    wire [31:0] imm_ext;
    wire [31:0] alu_in_b;
    wire        zero;

    // Control Unit Signals
    wire        reg_write;
    wire        alu_src;
    wire [3:0]  alu_control;
    wire        mac_en;
    wire        clr_acc;
    wire [1:0]  wb_sel;

    // INT8 MAC Unit Signals
    wire signed [31:0] mac_out;
    wire               mac_valid;

    // Program Counter Logic (Sequential PC + 4)
    assign pc_next  = pc + 32'd4;
    assign pc_write = 1'b1;

    // Immediate generation for I-type (sign-extended 12-bit)
    assign imm_ext  = {{20{instr[31]}}, instr[31:20]};

    // Multiplexers
    assign alu_in_b = (alu_src) ? imm_ext : rd_data2;
    assign wr_data  = (wb_sel == 2'b01) ? mac_out : alu_result;

    // Top Level Outputs
    assign pc_out         = pc;
    assign instr_out      = instr;
    assign alu_result_out = wr_data;

    // 1. Program Counter Unit
    pc_unit u_pc (
        .clk(clk),
        .reset(reset),
        .pc_next(pc_next),
        .pc_write(pc_write),
        .pc(pc)
    );

    // 2. Instruction Memory
    instruction_memory u_imem (
        .addr(pc),
        .instr(instr)
    );

    // 3. Control Unit
    control_unit u_control (
        .opcode(instr[6:0]),
        .funct3(instr[14:12]),
        .funct7(instr[31:25]),
        .reg_write(reg_write),
        .alu_src(alu_src),
        .alu_control(alu_control),
        .mac_en(mac_en),
        .clr_acc(clr_acc),
        .wb_sel(wb_sel)
    );

    // 4. Register File
    register_file u_rf (
        .clk(clk),
        .reg_write(reg_write),
        .rs1(instr[19:15]),
        .rs2(instr[24:20]),
        .rd(instr[11:7]),
        .wr_data(wr_data),
        .rd_data1(rd_data1),
        .rd_data2(rd_data2)
    );

    // 5. Arithmetic Logic Unit (ALU)
    alu u_alu (
        .a(rd_data1),
        .b(alu_in_b),
        .alu_control(alu_control),
        .result(alu_result),
        .zero(zero)
    );

    // 6. Integrated INT8 Pipelined MAC Accelerator
    int8_mac u_mac (
        .clk(clk),
        .rst_n(~reset),
        .enable(mac_en),
        .clr_acc(clr_acc),
        .in_a(rd_data1[7:0]),
        .in_b(rd_data2[7:0]),
        .out_acc(mac_out),
        .valid_out(mac_valid)
    );

endmodule
module register_file (
    input  wire        clk,
    input  wire        reg_write,
    input  wire [4:0]  rs1,
    input  wire [4:0]  rs2,
    input  wire [4:0]  rd,
    input  wire [31:0] wr_data,
    output wire [31:0] rd_data1,
    output wire [31:0] rd_data2
);

    reg [31:0] registers [0:31];
    integer i;

    initial begin
        for (i = 0; i < 32; i = i + 1) begin
            registers[i] = 32'h0;
        end
    end

    // Synchronous Write (x0 is hardwired to 0)
    always @(posedge clk) begin
        if (reg_write && (rd != 5'd0)) begin
            registers[rd] <= wr_data;
        end
    end

    // Asynchronous Read
    assign rd_data1 = (rs1 == 5'd0) ? 32'h0 : registers[rs1];
    assign rd_data2 = (rs2 == 5'd0) ? 32'h0 : registers[rs2];

endmodule
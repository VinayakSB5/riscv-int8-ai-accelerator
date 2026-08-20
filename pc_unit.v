module pc_unit (
    input  wire        clk,
    input  wire        reset,
    input  wire [31:0] pc_next,  // Next PC address
    input  wire        pc_write, // Write enable
    output reg  [31:0] pc
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pc <= 32'h0000_0000; // Reset vector
        end else if (pc_write) begin
            pc <= pc_next;
        end
    end

endmodule
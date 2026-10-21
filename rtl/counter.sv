
`timescale 1ns/1ps

module counter (
    input  logic       clk,
    input  logic       rst,
    output logic [3:0] count
);

    logic [3:0] count_reg;

    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            count_reg <= 4'd0;
        else
            count_reg <= count_reg + 4'd1;
    end

    assign count = count_reg;

endmodule

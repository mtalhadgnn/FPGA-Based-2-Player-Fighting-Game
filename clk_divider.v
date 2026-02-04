module clk_divider #(
    parameter DIV = 10
)(
    input clk,
    input rst,
    output reg clk_out
);

    reg [31:0] count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 0;
            clk_out <= 0;
        end else begin
            if (count == (DIV/2 - 1)) begin
                count <= 0;
                clk_out <= ~clk_out;
            end else begin
                count <= count + 1;
            end
        end
    end

endmodule

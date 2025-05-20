`timescale 1ns / 1ps
module sych(
    input clk,
    input sig1,
    output reg sig2
);
reg meta;

always @(posedge clk)begin
    meta<=sig1;
    sig2<= meta;
end
endmodule

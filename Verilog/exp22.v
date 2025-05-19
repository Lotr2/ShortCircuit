`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/15/2025 05:00:36 PM
// Design Name: 
// Module Name: exp2
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module exp22 #(parameter n = 50000000)
(input clk, rst,en, output reg clk_out);
wire [31:0] count;
// Big enough to hold the maximum possible value
// Increment count
exp1new #(32,n) counterMod
(.clk(clk),.en(en), .reset(rst), .count(count));
// Handle the output clock
always @ (posedge clk, posedge rst) begin
if (rst) // Asynchronous Reset
clk_out <= 0;
else if (count == n-1)
clk_out <= ~ clk_out;
end
endmodule

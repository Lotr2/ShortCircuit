`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/18/2025 10:21:00 AM
// Design Name: 
// Module Name: TCMP
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


module TCMP(
    input wire clk, rst, A,
    output reg S
);
    reg Z;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            Z <= 0;
            S <= 0;
        end else begin
            S <= A ^ Z;
            Z <= A | Z;
        end
    end
endmodule
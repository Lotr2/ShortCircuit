`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/06/2025 03:59:42 PM
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


module exp2(
    input clk,X, 
    output Z
    );
    wire clk_out;
    wire Y;
    wire Y2;
    debouncer debo(clk_out,0,X,Y);
    sych syc(clk_out,Y,Y2);
    exp1 edgy(clk_out,0,Y2,Z);
    
endmodule

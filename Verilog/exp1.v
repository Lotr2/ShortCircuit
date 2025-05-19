`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/06/2025 03:38:20 PM
// Design Name: 
// Module Name: exp1
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
//A 00
//B 01
//C 10
module exp1(
input clk, rst, w,
output z
    );
    reg [1:0] state, nextstate;
    parameter [1:0] A=2'b00, B=2'b01, C=2'b10;
    always @ *
    begin
    case (state)
    A: if(w==0) nextstate=A;
    else
    nextstate=B;
    B: if(w==0) nextstate=A;
    else
    nextstate = C;
    C: if(w==0) nextstate=A;
    else
    nextstate = C;
    default: nextstate=A;
    endcase
    end
    always @(posedge clk) begin
    if(rst)
    state<=A;
    else
    state<=nextstate;
    end
    assign z = (rst==0 & state==B );
endmodule

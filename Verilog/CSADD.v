`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/18/2025 10:08:14 AM
// Design Name: 
// Module Name: CSADD
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

module CSADD(
    input wire clk, rst,
    input wire x, y,
    output reg sum
);
    reg sc;
    wire hsum1, car1, sc_next;

    // Combinational logic
    halfAdder hf(y,sc, hsum1,car1);
    assign sc_next = car1 ^ (x & hsum1);

    // Sequential logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sum <= 0;
            sc <= 0;
        end else begin
            sum <= x ^ hsum1;
            sc <= sc_next;
        end
    end
endmodule
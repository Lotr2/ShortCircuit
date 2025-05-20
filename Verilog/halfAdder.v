`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/18/2025 10:14:28 AM
// Design Name: 
// Module Name: halfAdder
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


module halfAdder(
    input wire a,    // First bit
    input wire b,    // Second bit
    output wire sum, // Sum bit
    output wire carry // Carry bit
);

    assign sum = a ^ b;      // XOR for sum
    assign carry = a & b;    // AND for carry

endmodule

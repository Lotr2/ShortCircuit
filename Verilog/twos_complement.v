`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/19/2025 12:29:14 AM
// Design Name: 
// Module Name: twos_complement
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


module twos_complement(
    input [15:0] number,
    output reg [15:0] result
);
always @* begin
    // Check if LSB is 1 (number is odd)
    if(number[15]) begin
        result = ~number + 1;  // Two's complement calculation
    end
    else begin
        result = number;       // Keep original value
    end
end
endmodule
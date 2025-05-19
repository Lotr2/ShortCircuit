//x	
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/18/2025 10:31:31 AM
// Design Name: 
// Module Name: SPMTestBench
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


module SPMTestBench;
    reg clk;
    reg rst;
    reg [7:0] X;
    reg [7:0]Y;
    wire done;
    wire[15:0] fullprod;

    // Instantiate SPM
    SPM uut (
        .clk(clk),
        .rst(rst),
        .x(X),
        .y(Y),
        .done(done),
        .fullprod(fullprod)
    );
initial begin
  $dumpfile("waveform.vcd");     // Name of VCD file to write
  $dumpvars(0, SPMTestBench);    // Dump all variables in this module and below
end
    // Generate a 10ns clock
    always #10 clk = ~clk;

    initial begin

        // Initial values
        clk = 0;
        rst = 1;
        X = 8'b00000000;
        Y = 8'b00000000;

        // Apply reset
        #20 rst = 0;
         X = 8'b00001101; Y = 8'b00100111;

        #600;

        $finish;
    end

endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/18/2025 10:25:32 AM
// Design Name: 
// Module Name: SPM
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


module SPM(
    input clk,
    input rst,
    input [7:0] x,
    input [7:0] y,
    output reg done,
    output reg[15:0] fullprod
  // single-bit output to view waveform
);
// Internal registers
reg [7:0] y_reg;
reg [4:0] count;  // 3-bit counter from 0 to 7
wire prod;
reg [15:0] acc; // temporary accumulator for fullprod

// Intermediate wires
wire pp1, pp2, pp3, pp4, pp5, pp6, pp7;

// Instantiating modules (chain of CSADD + TCMP)
wire csadd_out;
TCMP tcmp(clk, rst, x[7] & y_reg[0], pp7);
CSADD csadd1(clk, rst, x[6] & y_reg[0], pp7, pp6);
CSADD csadd2(clk, rst, x[5] & y_reg[0], pp6, pp5);
CSADD csadd3(clk, rst, x[4] & y_reg[0], pp5, pp4);
CSADD csadd4(clk, rst, x[3] & y_reg[0], pp4, pp3);
CSADD csadd5(clk, rst, x[2] & y_reg[0], pp3, pp2);
CSADD csadd6(clk, rst, x[1] & y_reg[0], pp2, pp1);
CSADD csadd7(clk, rst, x[0] & y_reg[0], pp1, csadd_out);

assign prod = csadd_out;  // Just observe waveform

// Shift y_reg to process next bit each cycle
always @(posedge clk or posedge rst) begin
    if (rst) begin
        y_reg <= y;
        count <= 0;
        fullprod<=0;
        done <=0;
        acc <= 0;
    end 
    else if(count==0)begin
    y_reg<=y;
//    fullprod <= fullprod + prod << count;
            acc <= acc + (prod << count);
    count<=count+1;
    end
     else if(count < 15) begin
        y_reg <= y_reg >> 1;
//        fullprod <= fullprod + (prod << count);
                acc <= acc + (prod << count);

        count <= count + 1;
    end
   else if(count==15) begin
//   fullprod <= fullprod >>2;
           fullprod <= acc >> 2;  // do final adjustment here
   done<=1;
   count <= count+1;
   end
end

endmodule




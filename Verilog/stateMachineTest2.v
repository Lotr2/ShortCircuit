`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/19/2025 05:09:01 AM
// Design Name: 
// Module Name: stateMachineTest2
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


module stateMachineTest2;
// Inputs
  reg clkin = 0;
  reg rst = 0;
  reg [7:0] X = 0;
  reg [7:0] Y = 0;
  reg startMult = 0;
  reg scrLeft = 0;
  reg scrRight = 0;

  // Outputs
  wire [6:0] segments_a_to_g;
  wire [3:0] finanode;

  // Instantiate the DUT
  statemac uut (
    .clkin(clkin),
    .rst(rst),
    .X(X),
    .Y(Y),
    .startMult(startMult),
    .scrLeft(scrLeft),
    .scrRight(scrRight),
    .segments_a_to_g(segments_a_to_g),
    .finanode(finanode)
  );

  // Generate 100MHz clock (10ns period)
  always #5 clkin = ~clkin;

  // Task to simulate button press
  task press_button(input reg btn);
    begin
      case (btn)
        0: begin startMult = 1; #20; startMult = 0; end
        1: begin scrLeft = 1;  #20; scrLeft = 0;  end
        2: begin scrRight = 1; #20; scrRight = 0; end
      endcase
    end
  endtask

  initial begin
    // Initial reset
    $display("Resetting...");
    X=8'd0;
    Y=8'd0;    
    rst = 1;
    #50;
    rst = 0;

    // Load numbers to multiply
    X = 8'd13;
    Y = 8'd5;
    $display("Inputs set: X = %d, Y = %d", X, Y);
    #10
    startMult=1;
    #10000
    startMult=0;
    // Start multiplication
    #100;
    press_button(0); // startMult

    // Wait for multiplication to complete (simulate delay)
    #1000;

    // Scroll through digits
    press_button(1); // scrLeft
    #200;
    press_button(1); // scrLeft
    #200;
    press_button(2); // scrRight
    #200;

    // Run simulation for a while
    #2000;

    $finish;
  end
endmodule

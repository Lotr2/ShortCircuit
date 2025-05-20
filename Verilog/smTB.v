`timescale 1ns/1ps

module tb_statemac();
    reg clk, rst, en;
    reg [7:0] X, Y;
    wire doneSignal;
    wire [15:0] fullprod;
    wire [18:0] bcd;

    // Instantiate DUT
    statemac dut (
        .clk(clk),
        .rst(rst),
        .en(en),
        .X(X),
        .Y(Y),
        .doneSignal(doneSignal),
        .fullprod(fullprod),
        .bcd(bcd)
    );

    // Generate clock
    always #5 clk = ~clk;

    initial begin
        // Initialize signals
        clk = 0;
        rst = 1;
        en = 0;
        X = 0;
        Y = 0;
        
        // Reset sequence
        #20 rst = 0;
        
        // Test 3 × 2 = 6
        X = 8'd3;
        Y = 8'd2;
        en = 1;
        #10 en = 0;
        
        // Wait for completion
        while(!doneSignal) #10;
        #100; // Extra delay for BCD conversion
        
        $display("Test 1: 3*2 = %d (BCD: %h)", fullprod, bcd);
        
        // Test 15 × 15 = 225
        #100;
        X = 8'd15;
        Y = 8'd15;
        en = 1;
        #10 en = 0;
        
        while(!doneSignal) #10;
        #100;
        
        $display("Test 2: 15*15 = %d (BCD: %h)", fullprod, bcd);
        
        // Test 255 × 255 = 65025
        #100;
        X = 8'd10011101;
        Y = 8'd00000001;
        en = 1;
        #10 en = 0;
        
        while(!doneSignal) #10;
        #100;
        
        $display("Test 3: 255*255 = %d (BCD: %h)", fullprod, bcd);
        
        #100 $finish;
    end
endmodule
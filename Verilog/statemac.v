module statemac(
    input clkin, rst,
    input [7:0] X,
    input [7:0] Y,
    input startMult,scrLeft,scrRight,
    output reg[6:0] segments_a_to_g,
    output reg[3:0]finanode
    );
    wire [15:0] fullprod;
    wire clk,doneSignal;
    exp22 #(1) clkDivier(clkin,rst,1,clk);
    wire[18:0] bcd;
    reg [14:0] nodbc;
    reg [1:0] state, nextState;
    wire spm_rst;
    reg[1:0] count;
    wire[1:0] anode;
    reg[3:0] dig1,dig2,dig3;
    exp1new #(2,4) ano(clk,rst,1,anode);
    
    //push detection
//    wire scrLeft,scrRight,rst;
//    exp2 multdetector(clk,multDetector,startMult);
//    exp2 rstdetector(clk,reset,rst);
//    exp2 leftdetector(clk,left,scrLeft);
//    exp2 rightdetector(clk,right,scrRight);
    // State parameters
    localparam [1:0] 
        LOAD     = 2'b00,
        MULTIPLY = 2'b01,
        DONE     = 2'b10;

    // Instantiate SPM and doubledabble
    SPM uut(
        .clk(clk),
        .rst(spm_rst),
        .x(X),
        .y(Y),
        .done(doneSignal),
        .fullprod(fullprod)
    );
    
    doubledabble dd(nodbc, bcd);

    // State transition
    always @(posedge clk or posedge rst) begin
        if (rst) state <= LOAD;
        else state <= nextState;
    end

    // Next state logic
    always @* begin
        case (state)
            LOAD:     nextState = startMult ? MULTIPLY : LOAD; // Wait for enable
            MULTIPLY: nextState = doneSignal ? DONE : MULTIPLY;
            DONE:     nextState = (rst)? LOAD:DONE; // Auto-reset to allow new operations
            default:  nextState = LOAD;
        endcase
    end

    // Control signals and registers
    assign spm_rst = (state == LOAD); // Reset SPM during LOAD

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            nodbc <= 0;
            count <=0;
        end else begin
            if (state == LOAD) 
            begin
            end
            if (state==MULTIPLY)
                begin
                end
                
            if (state == DONE) 
            if(fullprod[15]==0)
                nodbc <= fullprod[14:0]; // Update BCD after multiplication
            else
            nodbc <= ~fullprod[14:0] +1;
        end
    end
    always @(posedge clk)             //scrll still not implemented TODO
    begin
         if(scrLeft && count<2)
        count<=count+1;
         if(scrRight && count>0)
         count<=count-1;                //I want to place sort of a count that cycles through the 5 digit
    end
    
    always @ *begin                 //Cycle through the finanode conditions
    case(anode)
    0:  finanode= 4'b1110;
    1:  finanode= 4'b1101;
    2:  finanode= 4'b1011;
    3:  finanode= 4'b0111;
    default: finanode=4'b0000;
    endcase  
    end
    
    
    always @(count) begin
    case(count)
    2'b00: begin
            dig1<= {2'b00,bcd[18:16]};
            dig2<= bcd[15:12];
            dig3<= bcd[11:8];
            end
    2'b01: begin
            dig1<= bcd[15:12];
            dig2<= bcd[11:8];
            dig3<= bcd[7:4];
            end
    2'b10: begin
            dig1<= bcd[11:8];
            dig2<= bcd[7:4];
            dig3<= bcd[3:0];
    end
        default: begin
            dig1<=0;
            dig2<=0;
            dig3<=0;
            end
    endcase
    end
    always @ * begin
if(finanode==4'b1011)
case(dig1)
4'b0000: segments_a_to_g = 7'b0000001;
4'b0001: segments_a_to_g = 7'b1001111;
4'b0010: segments_a_to_g = 7'b0010010;
4'b0011: segments_a_to_g = 7'b0000110;
4'b0100: segments_a_to_g = 7'b1001100;
4'b0101: segments_a_to_g = 7'b0100100;
4'b0110: segments_a_to_g = 7'b0100000;
4'b0111: segments_a_to_g = 7'b0001111;
4'b1000: segments_a_to_g = 7'b0000000;
4'b1001: segments_a_to_g = 7'b0000100;
default: segments_a_to_g = 7'b1111111;
endcase
else if (finanode==4'b1101)
case(dig2)
4'b0000: segments_a_to_g = 7'b0000001;
4'b0001: segments_a_to_g = 7'b1001111;
4'b0010: segments_a_to_g = 7'b0010010;
4'b0011: segments_a_to_g = 7'b0000110;
4'b0100: segments_a_to_g = 7'b1001100;
4'b0101: segments_a_to_g = 7'b0100100;
4'b0110: segments_a_to_g = 7'b0100000;
4'b0111: segments_a_to_g = 7'b0001111;
4'b1000: segments_a_to_g = 7'b0000000;
4'b1001: segments_a_to_g = 7'b0000100;
default: segments_a_to_g = 7'b0000000;
endcase
else if (finanode==4'b1110)
case(dig3)
4'b0000: segments_a_to_g = 7'b0000001;
4'b0001: segments_a_to_g = 7'b1001111;
4'b0010: segments_a_to_g = 7'b0010010;
4'b0011: segments_a_to_g = 7'b0000110;
4'b0100: segments_a_to_g = 7'b1001100;
4'b0101: segments_a_to_g = 7'b0100100;
4'b0110: segments_a_to_g = 7'b0100000;
4'b0111: segments_a_to_g = 7'b0001111;
4'b1000: segments_a_to_g = 7'b0000000;
4'b1001: segments_a_to_g = 7'b0000100;
default: segments_a_to_g = 7'b1111111;

endcase
else if (finanode==4'b0111)
case(fullprod[15])
1'b0: segments_a_to_g = 7'b1111111;
1'b1: segments_a_to_g = 7'b1111110





;
default: segments_a_to_g = 7'b00000000;
endcase
end
endmodule
`timescale 1ns / 1ps

module synch(
    input clk,
    input rst,
    input s,
    output reg s1
);

    reg m;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            m <= 0;
            s1 <= 0;
        end else begin
            m <= s;
            s1 <= m;
        end
    end
endmodule

module debouncer(
    input clk,
    input rst,
    input in,
    output out
);

    reg q1, q2, q3;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            q1 <= 0;
            q2 <= 0;
            q3 <= 0;
        end else begin
            q1 <= in;
            q2 <= q1;
            q3 <= q2;
        end
    end

    assign out = (rst) ? 0 : q1 & q2 & q3;
endmodule

module fsm(
    input clk,
    input rst,
    input w,
    output reg z
);

    reg [1:0] state, next_state;
    localparam A = 2'b00, B = 2'b01, C = 2'b10;

    always @(w or state) begin
        case (state)
            A: next_state = w ? B : A;
            B: next_state = w ? C : A;
            C: next_state = w ? C : A;
            default: next_state = A;
        endcase
    end

    always @(posedge clk or posedge rst) begin
        if (rst)
            state <= A;
        else
            state <= next_state;
    end

    always @(*) begin
        z = (state == B) ? 1'b1 : 1'b0;
    end
endmodule

module push_button(
    input clk,
    input rst,
    input x,
    output reg na
);

    wire unbounce, synced, between;

    debouncer db(.clk(clk), .rst(rst), .in(x), .out(unbounce));
    synch sync_inst(.clk(clk), .rst(rst), .s(unbounce), .s1(synced));
    fsm fsm_inst(.clk(clk), .rst(rst), .w(synced), .z(between));

    always @(*) begin
        na = between;
    end
endmodule
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

module control_unit(
    input clk,
    input rst,
    input clr,
    input btn_center,
    input btn_left,
    input btn_right,
    input load_done,
    input start_mult,
    output scroll_left,
    output scroll_right,
    input mult_done,
    output mult_active,
    output reg load_data
);

    wire scroll_left, scroll_right;

    push_button btn_left_inst(.clk(clk), .rst(rst), .x(btn_left), .na(scroll_left));
    push_button btn_right_inst(.clk(clk), .rst(rst), .x(btn_right), .na(scroll_right));

    reg [2:0] state, next_state;
    localparam IDLE = 3'b000, LOAD = 3'b001, MULT = 3'b010, DONE = 3'b011;

    always @(posedge clk) begin
        if (rst || clr)
            state <= IDLE;
        else
            state <= next_state;
    end

    always @(*) begin
        case (state)
            IDLE: next_state = start_mult ? LOAD : IDLE;
            LOAD: next_state = load_done ? MULT : LOAD;
            MULT: next_state = mult_done ? DONE : MULT;
            DONE: next_state = start_mult ? LOAD : DONE;
            default: next_state = IDLE;
        endcase
    end

    always @(*) begin
        load_data = (state == LOAD);
    end

    assign mult_active = (state == MULT);
endmodule
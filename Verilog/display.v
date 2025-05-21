`timescale 1ns / 1ps

module double_dabble(
    input signed [15:0] binary,
    output reg [19:0] bcd,
    output reg sign
);
    integer i;
    reg [15:0] abs_val;
    reg [35:0] shift_reg;

    always @(*) begin
        if (binary < 0) begin
            sign = 1;
            abs_val = -binary;
        end else begin
            sign = 0;
            abs_val = binary;
        end

        shift_reg = 36'd0;
        shift_reg[15:0] = abs_val;

        for (i = 0; i < 16; i = i + 1) begin
            if (shift_reg[19:16] >= 5)
                shift_reg[19:16] = shift_reg[19:16] + 3;
            if (shift_reg[23:20] >= 5)
                shift_reg[23:20] = shift_reg[23:20] + 3;
            if (shift_reg[27:24] >= 5)
                shift_reg[27:24] = shift_reg[27:24] + 3;
            if (shift_reg[31:28] >= 5)
                shift_reg[31:28] = shift_reg[31:28] + 3;
            if (shift_reg[35:32] >= 5)
                shift_reg[35:32] = shift_reg[35:32] + 3;

            shift_reg = shift_reg << 1;
        end

        bcd = shift_reg[35:16];
    end
endmodule

module seven_seg(
    input rst,
    input [1:0] en,
    input [3:0] num,
    output reg [0:6] segments,
    output reg [3:0] anode
);

    always @(*) begin
        if (rst)
            segments = 7'b0000001;
        else case (num)
            4'd0: segments = 7'b0000001;
            4'd1: segments = 7'b1001111;
            4'd2: segments = 7'b0010010;
            4'd3: segments = 7'b0000110;
            4'd4: segments = 7'b1001100;
            4'd5: segments = 7'b0100100;
            4'd6: segments = 7'b0100000;
            4'd7: segments = 7'b0001111;
            4'd8: segments = 7'b0000000;
            4'd9: segments = 7'b0001100;
            4'd14: segments = 7'b1111111;
            4'd15: segments = 7'b1111110;
            default: segments = 7'b1111111;
        endcase

        case (en)
            2'b00: anode = 4'b1110;
            2'b01: anode = 4'b1101;
            2'b10: anode = 4'b1011;
            2'b11: anode = 4'b0111;
            default: anode = 4'b1111;
        endcase
    end
endmodule

module clk_divider #(parameter DIV = 50000000)(
    input clk,
    input rst,
    output reg clk_out
);

    reg [31:0] count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 0;
            clk_out <= 0;
        end else begin
            if (count == DIV-1) begin
                count <= 0;
                clk_out <= ~clk_out;
            end else
                count <= count + 1;
        end
    end
endmodule

module counter #(parameter BITS = 4, parameter MAX_COUNT = 15)(
    input clk,
    input rst,
    input en,
    output reg [BITS-1:0] count,
    output reg done
);

    always @(posedge clk or posedge rst) begin
        if (rst)
            count <= {BITS{1'b0}};
        else if (en) begin
            if (count == MAX_COUNT)
                count <= {BITS{1'b0}};
            else
                count <= count + 1'b1;
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst)
            done <= 0;
        else if (en && count == MAX_COUNT)
            done <= 1;
        else
            done <= 0;
    end
endmodule

module display(
    input scroll_right,
    input scroll_left,
    input clk,
    input rst,
    input clr,
    input [15:0] binary,
    output [0:6] segments,
    output [3:0] anode
);

    wire [19:0] bcd;
    wire sign;
    double_dabble dd(binary, bcd, sign);

    wire clk_out;
    clk_divider #(250000) clk_div(clk, rst, clk_out);

    wire done;
    wire [1:0] count;
    counter #(2, 3) cnt(clk_out, rst, 1'b1, count, done);

    wire [3:0] ones, tens, hundreds, thousands, ten_thousands;
    assign {ten_thousands, thousands, hundreds, tens, ones} = (rst) ? 0 : bcd;

    reg [3:0] digit0, digit1, digit2;
    reg [1:0] offset;
    localparam MAX_OFFSET = 2'd2;

    always @(posedge clk_out or posedge rst) begin
        if (rst || clr) begin
            offset <= 2'd0;
        end else if (scroll_left && offset < MAX_OFFSET) begin
            offset <= offset + 1;
        end else if (scroll_right && offset > 0) begin
            offset <= offset - 1;
        end
    end

    always @(binary) begin
        if (rst) begin
            digit0 = 0;
            digit1 = 0;
            digit2 = 0;
        end
        case (offset)
            2'b00: begin
                digit0 = ones;
                digit1 = tens;
                digit2 = hundreds;
            end
            2'b01: begin
                digit0 = tens;
                digit1 = hundreds;
                digit2 = thousands;
            end
            2'b10: begin
                digit0 = hundreds;
                digit1 = thousands;
                digit2 = ten_thousands;
            end
            default: begin
                digit0 = 0;
                digit1 = 0;
                digit2 = 0;
            end
        endcase
    end

    wire [4:0] sign_code = (sign == 1) ? 15 : 14;

    reg [3:0] num;
    always @(posedge clk_out) begin
        if (rst || clr)
            num <= 14;
        case (count)
            2'b11: num <= sign_code;
            2'b00: num <= digit0;
            2'b01: num <= digit1;
            2'b10: num <= digit2;
        endcase
    end

    seven_seg seg_display(rst, count, num, segments, anode);
endmodule
`timescale 1ns / 1ps

module complement(
    input clk,
    input rst,
    input clr,
    input data_in,
    output reg data_out
);

    always @(posedge clk or posedge rst) begin
        if (rst || clr) begin
            data_out <= 1'b0;
        end else begin
            data_out <= data_in;
        end
    end
endmodule

module csa(
    input clk,
    input rst,
    input clr,
    input x,
    input y,
    output reg sum
);

    reg carry;

    wire sum1, carry1;
    assign sum1 = y ^ carry;
    assign carry1 = y & carry;

    wire sum2, carry2;
    assign sum2 = x ^ sum1;
    assign carry2 = x & sum1;

    always @(posedge clk or posedge rst) begin
        if (rst || clr) begin
            sum <= 1'b0;
            carry <= 1'b0;
        end else begin
            sum <= sum2;
            carry <= carry1 ^ carry2;
        end
    end
endmodule

module sipo #(parameter WIDTH = 8)(
    input clk,
    input rst,
    input clr,
    input shift_en,
    input data_in,
    output reg [WIDTH-1:0] q
);

    always @(posedge clk or posedge rst) begin
        if (rst || clr)
            q <= 0;
        else if (shift_en)
            q <= {data_in, q[WIDTH-1:1]};
        else
            q <= q;
    end
endmodule

module spm(
    input clk,
    input rst,
    input clr,
    input [7:0] x,
    input y,
    output p
);

    wire [7:1] pp;

    csa csa0(.clk(clk), .rst(rst), .clr(clr), .x(x[0] & y), .y(pp[1]), .sum(p));

    genvar i;
    generate
        for (i = 1; i < 7; i = i + 1) begin
            csa csa_inst(.clk(clk), .rst(rst), .clr(clr), .x(x[i] & y), .y(pp[i+1]), .sum(pp[i]));
        end
    endgenerate

    complement cmp(.clk(clk), .rst(rst), .clr(clr), .data_in(x[7] & y), .data_out(pp[7]));
endmodule
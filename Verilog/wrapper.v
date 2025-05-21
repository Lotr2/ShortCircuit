`timescale 1ns / 1ps

module shift_register #(parameter WIDTH = 8)(
    input clk,
    input rst,
    input clr,
    input shift_en,
    input extend,
    input load,
    input [WIDTH-1:0] data_in,
    output reg [WIDTH-1:0] q
);

    initial begin
        q = {WIDTH{1'b0}};
    end

    always @(posedge clk or posedge rst) begin
        if (rst || clr) begin
            q <= {WIDTH{1'b0}};
        end else if (load) begin
            q <= data_in;
        end else if (shift_en) begin
            if (extend)
                q <= {q[WIDTH-1], q[WIDTH-1:1]};
            else
                q <= {1'b0, q[WIDTH-1:1]};
        end
    end
endmodule

module parallel_register #(parameter WIDTH = 8)(
    input clk,
    input rst,
    input load,
    input [WIDTH-1:0] data_in,
    output reg [WIDTH-1:0] q
);

    always @(posedge clk or posedge rst) begin
        if (rst)
            q <= {WIDTH{1'b0}};
        else if (load)
            q <= data_in;
        else
            q <= q;
    end
endmodule

module wrapper(
    input clk,
    input rst,
    input clr,
    input btn_center,
    input btn_left,
    input btn_right,
    input [7:0] multiplicand,
    input [7:0] multiplier,
    output [0:6] segments,
    output [3:0] anode
);

    wire start;
    push_button btn_center_inst(.clk(clk_out), .rst(rst), .x(btn_center), .na(start));

    wire clk_out;
    clk_divider #(200000) clk_div(.clk(clk), .rst(rst), .clk_out(clk_out));

    wire load_done, mult_active, load_data, mult_done;
    wire [7:0] multiplicand_reg, multiplier_reg;
    wire scroll_left, scroll_right;

    wire [3:0] load_count;
    counter #(4, 6) load_counter(.clk(clk_out), .rst(rst), .en(load_data), .count(load_count), .done(load_done));

    control_unit cu(
        .clk(clk_out),
        .rst(rst),
        .clr(clr),
        .btn_center(btn_center),
        .btn_left(btn_left),
        .btn_right(btn_right),
        .load_done(load_done),
        .load_data(load_data),
        .start_mult(start),
        .scroll_left(scroll_left),
        .scroll_right(scroll_right),
        .mult_done(mult_done),
        .mult_active(mult_active)
    );

    parallel_register #(8) multiplicand_reg_inst(
        .clk(clk_out),
        .rst(rst),
        .load(start),
        .data_in(multiplicand),
        .q(multiplicand_reg)
    );

    shift_register #(8) multiplier_reg_inst(
        .clk(clk_out),
        .rst(rst),
        .clr(clr),
        .shift_en(1'b1),
        .extend(1'b1),
        .load(load_data),
        .data_in(multiplier),
        .q(multiplier_reg)
    );

    wire [4:0] mult_count;
    counter #(5, 15) mult_counter(
        .clk(clk_out),
        .rst(rst),
        .en(mult_active),
        .count(mult_count),
        .done(mult_done)
    );

    wire prod_bit;
    spm multiplier_inst(
        .clk(clk_out),
        .rst(rst),
        .clr(clr || load_data),
        .x(multiplicand_reg),
        .y(multiplier_reg[0]),
        .p(prod_bit)
    );

    wire [15:0] product;
    sipo #(16) product_reg(
        .clk(clk_out),
        .rst(rst),
        .clr(load_data),
        .shift_en(mult_active),
        .data_in(prod_bit),
        .q(product)
    );

    display disp(
        .scroll_right(scroll_right),
        .scroll_left(scroll_left),
        .clk(clk),
        .rst(rst),
        .clr(clr),
        .binary(product),
        .segments(segments),
        .anode(anode)
    );
endmodule
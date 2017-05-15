`timescale 1ns / 1ps

module top_DP(input en_x, en_y, go_calc, go_div, go_mult, sel_h, en_out_h, en_out_l, clk, rst,
              input[1:0] sel_l, op_calc,
              input[3:0] x,y,
              output done_calc, done_div, done_mult,
              output[3:0] out_h, out_l);
wire[3:0] x_out, y_out;
wire[3:0] CS;
wire errorFlag, done;

Reg x0(.clk(clk),.rst(rst),.en(en_x),.d(x),.q(x_out));
Reg y0(.clk(clk),.rst(rst),.en(en_y),.d(y),.q(y_out));

small_calc_top dp0(.go_calc(go_calc),.clk(clk),.rst(rst),.op(op_calc),.x(x_out),.y(y_out),
                   .done(done_calc),.out(out_l),.CS(CS));
div_top dp1(.rst(rst),.clk(clk),.go(go_div),.x(x_out),.y(y_out),.r(out_h),.q(out_l),
            .CS(CS),.error(errorFlag),.done(done_div));
multiplier_pipeline dp2(.A_in(x_out),.B_in(y_out),.clk100MHz(clk),.rst(rst),.en(go_mult),
                        .Product({out_h,out_l}),.done(done_mult));
endmodule

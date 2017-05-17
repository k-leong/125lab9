`timescale 1ns / 1ps

module top_DP(input en_x, en_y, go_calc, go_div, go_mult, sel_h, en_out_h, en_out_l, clk, rst,
              input[1:0] sel_l, op_calc,
              input[3:0] x,y,
              output done_calc, done_div,
              output[3:0] out_h, out_l);
wire[3:0] x_out, y_out;
wire[3:0] CS;
wire errorFlag, done;
wire[1:0] s1_calc,wa,raa,rab,c;
wire we, rea, reb,s2_calc;

wire udCE,udLD,udUD,s0_div,s1_div,s2_div,rLD,rSL,rSR,xLD,xSL,xRightIn,yLD;
wire[3:0] n, R_lt_Y,cnt_out;

Reg x0(.clk(clk),.rst(rst),.en(en_x),.d(x),.q(x_out));
Reg y0(.clk(clk),.rst(rst),.en(en_y),.d(y),.q(y_out));

calc_dp dp0(.in1(x_out),.in2(y_out),.s1(s1_calc),.clk(clk),.wa(wa),.we(we), 
            .raa(raa),.rea(rea),.rab(rab),.reb(reb),.c(c),.s2(s2_calc),.out(out_l),.done(done_calc));
div_dp dp1(.rst(rst),.clk(clk),.udCE(udCE),.udLD(udLD),.udUD(udUD),.s0(s0_div),.s1(s1_div),.s2(s2_div),.rLD(rLD),
           .rSL(rSL),.rSR(rSR),.xLD(xLD),.xSL(xSL),.xRightIn(xRightIn),.yLD(yLD),.n(n),.x(x_out),.y(y_out),
           .R_lt_Y(R_lt_Y),.cnt_out(cnt_out),.r(out_h),.q(out_l),.error(errorFlag),.done(done_div));
multiplier_pipeline dp2(.A_in(x_out),.B_in(y_out),.clk100MHz(clk),.rst(rst),.en(go_mult),
                        .Product({out_h,out_l}));
endmodule

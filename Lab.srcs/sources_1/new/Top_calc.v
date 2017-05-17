`timescale 1ns / 1ps

module Top_calc(input clk, rst, go,
                input[3:0] x,y,
                input[2:0] F,
                output done, error,
                output[3:0] out_h, out_l);
wire en_f, en_x, en_y, go_calc, go_div, go_mult, sel_h, en_out_h, en_out_l, div_by_zero;
wire[1:0] sel_l;
wire[2:0] op_calc;
wire[3:0] Dout, x_out, y_out;
wire[3:0] calc_out, mult_h, mult_l, r,q, out_H, out_L,CS;

Reg #(3)f(.clk(clk),.rst(rst),.en(en_f),.d(F),.q(Dout));
/*Reg X(.clk(clk),.rst(rst),.en(en_x),.d(x),.q(x_out));
Reg Y(.clk(clk),.rst(rst),.en(en_y),.d(y),.q(y_out));*/
top_DP calcDP(.en_x(en_x),.en_y(en_y),.go_calc(go_calc),.go_div(go_div),.go_mult(go_mult),.sel_h(sel_h),
              .en_out_h(en_out_h),.en_out_l(en_out_l),.clk(clk),.rst(rst),.sel_l(sel_l),.op_calc(op_calc),
              .x(x_out),.y(y_out),.done_calc(done),.done_div(done),.out_h(out_h),.out_l(out_l));
CU calcCU(.clk(clk), .rst(rst), .go(go), .done_calc(done_calc), .done_div(done_div), .div_by_zero(div_by_zer),
          .F(Dout),.en_f(en_f), .en_x(en_x), .en_y(en_y), .go_calc(go_calc), .go_div(go_div), .go_mult(go_mult), 
          .sel_h(sel_h),.en_out_h(en_out_h),.en_out_l(en_out_l),.done(done),.errorFlag(error),.op_calc(op_calc),
          .sel_l(sel_l),.CS(CS));
endmodule

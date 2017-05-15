`timescale 1ns / 1ps

module top_DP_tb;
reg en_x, en_y, go_calc, go_div, go_mult, sel_h, en_out_h, en_out_l, clk, rst;
reg[1:0] sel_l, op_calc;
reg[3:0] x,y;
reg[12:0] ctrl;
wire done_calc, done_div, done_mult;
wire[3:0] out_h, out_l;
reg[3:0] expected_h, expected_l;

top_DP top(en_x, en_y, go_calc, go_div, go_mult, sel_h, 
       en_out_h, en_out_l, clk, rst, sel_l, op_calc,x,y,done_calc, done_div, done_mult,out_h, out_l);

always@(ctrl) {en_x, en_y, go_calc, go_div, go_mult, sel_h, en_out_h, en_out_l,sel_l, op_calc}= ctrl;

task clock;
begin
clk=0;
#5;
clk=1;
#5;
end
endtask

parameter   load =      12'b1_1_0_0_0_0_0_0_00_00,
            add =       12'b0_0_1_0_0_0_0_0_00_00,
            sub =       12'b0_0_1_0_0_0_0_0_00_01,
            And =       12'b0_0_1_0_0_0_0_0_00_10,
            Xor =       12'b0_0_1_0_0_0_0_0_00_11,
            calc =      12'b0_0_0_0_0_0_0_0_01_00,
            div =       12'b0_0_0_1_0_0_0_0_00_00,
            mul =       12'b0_0_0_0_1_0_0_0_00_00,
            mux_calc =  12'b0_0_0_0_0_0_0_0_01_00,
            mux_div =   12'b0_0_0_0_0_1_0_0_11_00,
            mux_mul =   12'b0_0_0_0_0_0_0_0_10_00,
            out_d_m =   12'b0_0_0_0_0_0_1_1_00_00,
            out_calc =  12'b0_0_0_0_0_0_0_1_00_00;
            
initial begin
    clock; rst = 1;
    clock; rst = 0;
    x = 4'b1110; y = 4'b0011;
    clock; ctrl = load;
    clock; ctrl = add;
    clock; ctrl = mux_calc;
    clock; ctrl = out_calc;
    clock; expected_l = x + y;
    clock;
    if(expected_l != out_l) $stop;
   
    clock; rst = 1;
    clock; rst = 0;
    x = 4'b1110; y = 4'b0000;
    clock; ctrl = load;
    clock; ctrl = div;
    clock; ctrl = mux_div;
    clock; ctrl = out_d_m;
    clock; {expected_h, expected_l} = x/y;
    clock; if((expected_l != out_l) && (expected_h != out_h)) $stop;
    $display("success");
    $finish;
end
endmodule

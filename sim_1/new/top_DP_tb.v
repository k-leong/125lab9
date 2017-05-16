`timescale 1ns / 1ps

module top_DP_tb;
reg en_x, en_y, go_calc, go_div, go_mult, sel_h, en_out_h, en_out_l, clk, rst;
reg[1:0] sel_l;
reg [2:0] op_calc; //this was changed from 2-bits to 3-bits
reg[3:0] x,y;
reg[11:0] ctrl;
wire done_calc, done_div;
wire[3:0] out_h, out_l;
reg[3:0] expected_h, expected_l;

top_DP top(en_x, en_y, go_calc, go_div, go_mult, sel_h, en_out_h, en_out_l, clk, rst,sel_l, op_calc,x,y,
            done_calc, done_div,out_h, out_l);

always@(ctrl) {en_x, en_y, go_calc, go_div, go_mult, sel_h, en_out_h, en_out_l,sel_l, op_calc}= ctrl;

task clock; begin clk=0; #5; clk=1; #5;end endtask

parameter   idle =      13'b0_0_0_0_0_0_0_0_00_000, //changed control size to 13 from 12
            load =      13'b1_1_0_0_0_0_0_0_00_000,
            add =       13'b0_0_1_0_0_0_0_0_00_000,
            sub =       13'b0_0_1_0_0_0_0_0_00_001,
            And =       13'b0_0_1_0_0_0_0_0_00_010,
            Xor =       13'b0_0_1_0_0_0_0_0_00_011,
            div =       13'b0_0_0_1_0_0_0_0_00_100,
            mul =       13'b0_0_0_0_1_0_0_0_00_101,
            passA =     13'b0_0_0_0_0_0_0_0_00_110, 
            passB =     13'b0_0_0_0_0_0_0_0_00_111,
            mux_calc =  13'b0_0_0_0_0_0_0_0_01_000,
            mux_div =   13'b0_0_0_0_0_1_0_0_11_000,
            mux_mul =   13'b0_0_0_0_0_0_0_0_10_000,
            out_d_m =   13'b0_0_0_0_0_0_1_1_00_000,
            out_calc =  13'b0_0_0_0_0_0_0_1_00_000;  //out pass and calc
task check0; begin
    if(y == 4'b0000)begin
        ctrl = out_d_m;
        clock;
        clock; ctrl = idle;
        $stop;
    end
end
endtask            
initial begin
    clock; rst = 1;
    ctrl = idle;
    clock; rst = 0;
    x = 4'b1110; y = 4'b0011;
    check0;
    clock; ctrl = load;
    clock; ctrl = add;
    clock; ctrl = mux_calc;
    clock; ctrl = out_calc;
    clock; expected_l = x + y;
   
    clock; rst = 1;
    ctrl = idle;
    clock; rst = 0;
    clock; x = 4'b1110; y = 4'b0101;
    check0;
    clock; ctrl = load;
    clock; ctrl = div; clock; clock; clock;clock; clock;
    clock; ctrl = mux_div;
    clock; ctrl = out_d_m;
    clock; expected_l = x/y; expected_h = x%y;
    clock;
    
    clock; rst = 1;
    ctrl = idle;
    clock; rst = 0; 
    clock; x = 4'b1110; y = 4'b0101;
    check0;
    clock; ctrl = load;
    clock; ctrl = mul;
    clock; ctrl = mux_mul;
    clock; ctrl = out_d_m;
    clock; {expected_h, expected_l} = x*y;
    clock;
    
    clock; rst = 1; ctrl = idle;
    clock; rst = 0;
    clock; x = 4'b1001; y = 4'b1001;
    check0;
    clock; ctrl = load;
    clock; ctrl = passA;
    clock; ctrl = out_calc;
    clock; expected_l = x;
    clock;
    $display("success");
    $finish;
end
endmodule

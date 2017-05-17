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
integer i, j;
task clock; begin clk=0; #5; clk=1; #5;end endtask

parameter   idle =      13'b0_0_0_0_0_0_0_0_00_000, //changed control size to 13 from 12
            load =      13'b1_1_0_0_0_0_0_0_00_000,
            add =       13'b0_0_1_0_0_0_0_0_00_000, //0
            sub =       13'b0_0_1_0_0_0_0_0_00_001,//1
            And =       13'b0_0_1_0_0_0_0_0_00_010,//2
            Xor =       13'b0_0_1_0_0_0_0_0_00_011,//3
            div =       13'b0_0_0_1_0_0_0_0_00_100,//4
            mul =       13'b0_0_0_0_1_0_0_0_00_101,//5
            passA =     13'b0_0_0_0_0_0_0_0_00_110, //6
            passB =     13'b0_0_0_0_0_0_0_0_00_111,//7
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
    clock; rst = 1; //done_calc=0; done_div = 0;
    ctrl = idle;
    clock; rst = 0;
    x = 4'b1110; y = 4'b0011;
    for(i = 0; i < 8;i = i+1)begin
        for(j = 0; j <8; j = j+1)begin
            clock; ctrl = load;
            if(j == 0)begin
                ctrl = add;
                clock; ctrl = mux_calc;
                clock; ctrl = out_calc;
                clock; expected_l = x + y;
                clock;
            end
            else if(j == 1)begin
                ctrl = sub;
                clock; ctrl = mux_calc;
                clock; ctrl = out_calc;
                clock; expected_l = x-y;
                clock;
            end
            else if(j == 2)begin
                ctrl = And;
                clock; ctrl = mux_calc;
                clock; ctrl = out_calc;
                clock; expected_l = x&y;
                clock;
            end
            else if(j == 3)begin
                ctrl = Xor;
                clock; ctrl = mux_calc;
                clock; ctrl = out_calc;
                clock; expected_l = x^y;
                clock;
            end
            else if(j == 4)begin
                check0;
                ctrl = div;
                clock; clock; clock; clock; clock;
                clock; ctrl = mux_div;
                clock; ctrl = out_d_m;
                clock; expected_l = x/y; expected_h = x%y;
                clock;
            end
            else if(j == 5)begin
                ctrl = mul;
                clock; ctrl = mux_mul;
                clock; ctrl= out_d_m;
                clock; {expected_h, expected_l} = x*y;
                clock;
            end
            else if(j == 6)begin
                ctrl = passA;
                clock; ctrl = out_calc;
                clock; expected_l = x;
                clock;
            end
            else if(j == 7)begin
                ctrl = passB;
                clock; ctrl = out_calc;
                clock; expected_l = x;
                clock;
            end
            y = y-1'b1;
        end
        x= x+1'b1;
    end
 
    $display("success");
    $finish;
end
endmodule

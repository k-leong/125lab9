`timescale 1ns / 1ps

module CU_tb;
reg clk, rst, go, done_calc, done_div, done_mult, div_by_zero;
reg [2:0] F;
wire en_f, en_x, en_y, go_calc, go_div, go_mult, sel_h, en_out_h, en_out_l, done, errorFlag;
wire[1:0] op_calc, sel_l;
wire[3:0] CS;

wire[12:0] ctrl;

assign ctrl = {en_f, en_x, en_y, go_calc, op_calc, go_div, go_mult, sel_h, sel_l, en_out_h, en_out_l};
parameter
            sIDLE = 4'b0000,sLOAD = 4'b0001,sADD = 4'b0010,sSUB = 4'b0011,sAND = 4'b0100,
            sXOR = 4'b0101,sDIV = 4'b0110,sMUL = 4'b0111,sPASS = 4'b1000,sDONE_CALC = 4'b1001,
            sDONE_DIV = 4'b1010, sDONE_MUL = 4'b1011, sOUT_CALC = 4'b1100, sOUT_D_M = 4'b1101,
            IDLE = 13'b0_0_0_0_00_0_0_0_00_0_0,
            LOAD = 13'b1_1_1_0_00_0_0_0_00_0_0,
            GO_ADD = 13'b0_0_0_1_00_0_0_0_00_0_0,
            GO_SUB = 13'b0_0_0_1_01_0_0_0_00_0_0,
            GO_AND = 13'b0_0_0_1_10_0_0_0_00_0_0,
            GO_XOR = 13'b0_0_0_1_11_0_0_0_00_0_0,
            GO_DIV = 13'b0_0_0_0_00_1_0_0_00_0_0,
            GO_MULT = 13'b0_0_0_0_00_0_1_0_00_0_0,
            PASS = 13'b0_0_0_0_00_0_0_0_00_0_1,
            DONE_CALC = 13'b0_0_0_0_00_0_0_0_01_0_0,
            DONE_DIV = 13'b0_0_0_0_00_0_0_1_11_0_0,
            DONE_MULT = 13'b0_0_0_0_00_0_0_0_10_0_0,
            OUT_CALC = 13'b0_0_0_0_00_0_0_0_00_0_1,
            OUT_DIV_MULT = 13'b0_0_0_0_01_0_0_0_00_1_1;

CU DUT0(clk, rst, go, done_calc, done_div, div_by_zero, //done_mult,
        F, en_f, en_x, en_y, go_calc, go_div, go_mult, sel_h, en_out_h, en_out_l, done, errorFlag, op_calc, sel_l, CS);
task clock; begin clk = 0; #5; clk = ~clk; #5; end endtask

initial begin
    clock; rst = 1; go = 0; done_calc = 0; done_div = 0; div_by_zero = 0;
    clock; rst = 0; 
    clock; go = 0; 
    clock; if(ctrl != IDLE) $stop;
    clock; go = 1;
    clock; F = 3'b000;go = 0; if(ctrl != LOAD) $stop;
    clock; if(ctrl != GO_ADD) $stop;
    done_calc = 1;
    clock; if(ctrl != DONE_CALC) $stop;
    clock; if(ctrl != OUT_CALC) $stop;
    clock; if(ctrl != IDLE) $stop;
    
    clock; rst = 1; go = 0; done_calc = 0; done_div = 0; div_by_zero = 0;
    clock; rst = 0;
    clock; if(ctrl != IDLE) $stop;
    F= 3'b100;
    clock; go = 1;
    clock; div_by_zero = 1; go = 0; if(ctrl != LOAD) $stop;
    //clock; if(ctrl != GO_DIV) $stop;
    clock; if(ctrl != OUT_DIV_MULT)begin $display("error");$stop; end
    clock; if(ctrl != IDLE) $stop;
    
    clock; rst= 1; go = 0; done_calc = 0; done_div = 0; div_by_zero = 0;
    clock; rst = 0;
    clock; if(ctrl != IDLE) $stop;
    F= 3'b101;
    clock; go = 1;
    clock; go =0; if(ctrl!= LOAD) $stop;
    clock; if(ctrl != GO_MULT) $stop;
    clock; if(ctrl != DONE_MULT) $stop;
    clock; if(ctrl != OUT_DIV_MULT) $stop;
    clock; if(ctrl != IDLE) $stop;
    clock;
    $display("success");
    $finish;
end
endmodule

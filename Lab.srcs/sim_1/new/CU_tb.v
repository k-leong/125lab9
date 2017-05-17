`timescale 1ns / 1ps

module CU_tb;
reg clk, rst, go, done_calc, done_div, div_by_zero, errorflag;
reg [2:0] F;
wire en_f, en_x, en_y, go_calc, go_div, go_mult, sel_h, en_out_h, en_out_l, done, errorFlag;
wire[1:0] op_calc, sel_l;
wire[4:0] CS;

wire[12:0] ctrl;
integer i,j;
assign ctrl = {en_f, en_x, en_y, go_calc, op_calc, go_div, go_mult, sel_h, sel_l, en_out_h, en_out_l};
parameter
            sIDLE = 5'b00000,sLOAD = 5'b00001,sADD = 5'b00010,sSUB = 5'b00011,sAND = 5'b00100,
sXOR = 5'b00101,sDIV = 5'b00110,sMUL = 5'b00111,sPASS = 5'b01000,sDONE_CALC = 5'b01001,
sDONE_DIV = 5'b01010, sDONE_MUL = 5'b01011, sOUT_CALC = 5'b01100, sOUT_D_M = 5'b01101,
sWAIT = 5'b01110, sSHIFT1 = 5'b10000, sWAIT1 = 5'b10001, sCNT1 = 5'b10010, sLOAD2 = 5'b10011,
sSHIFT2= 5'b10100,sSHIFT3= 5'b10101,sSHIFT4= 5'b10110,sDONE  = 5'b10111,sWAIT2 = 5'b11000,
                IDLE =      13'b0_0_0_0_00_0_0_0_00_0_0,
                LOAD =      13'b1_1_1_0_00_0_0_0_00_0_0,
                GO_ADD =    13'b0_0_0_1_00_0_0_0_00_0_0,
                GO_SUB =    13'b0_0_0_1_01_0_0_0_00_0_0,
                GO_AND =    13'b0_0_0_1_10_0_0_0_00_0_0,
                GO_XOR =    13'b0_0_0_1_11_0_0_0_00_0_0,
                GO_DIV =    13'b0_0_0_0_00_1_0_0_00_0_0,
                GO_MULT =   13'b0_0_0_0_00_0_1_0_00_0_0,
                PASS =      13'b0_0_0_0_00_0_0_0_00_0_1,
                DONE_CALC = 13'b0_0_0_0_00_0_0_0_01_0_0,
                DONE_DIV =  13'b0_0_0_0_00_0_0_1_11_0_0,
                DONE_MULT = 13'b0_0_0_0_00_0_0_0_10_0_0,
                OUT_CALC =  13'b0_0_0_0_00_0_0_0_00_0_1,
             OUT_DIV_MULT = 13'b0_0_0_0_00_0_0_0_00_1_1;

CU DUT0(clk, rst, go, done_calc, done_div, div_by_zero, errorflag,//done_mult,
        F, en_f, en_x, en_y, go_calc, go_div, go_mult, sel_h, en_out_h, en_out_l, done, errorFlag, op_calc, sel_l, CS);
task clock; begin clk = 0; #5; clk = ~clk; #5; end endtask
task check0; begin
    if(div_by_zero == 1)
        if(ctrl != OUT_DIV_MULT) $stop;
end
endtask
initial begin
    clock; rst = 1; go = 0; done_calc = 0; done_div = 0; div_by_zero = 0; errorflag = 0;
    clock; rst = 0;if(ctrl!=IDLE) $stop;
    clock; go = 1;
    clock; go = 0; F = 3'b000; if(ctrl != LOAD) $stop;
    for(i = 0; i < 8; i = i+1)begin
    clock;
        if(i == 0)begin
            if(ctrl != GO_ADD) $stop;
            done_calc = 1;
            clock; if(ctrl != DONE_CALC) $stop;
            clock; if(ctrl != OUT_CALC) $stop;
            clock; if(ctrl != IDLE) $stop;
        end
        if(i == 1)begin
            if(ctrl != GO_SUB) $stop;
            done_calc = 1;
            clock; if(ctrl != DONE_CALC) $stop;
            clock; if(ctrl != OUT_CALC) $stop;
            clock; if(ctrl != IDLE) $stop;
        end
        if(i == 2)begin
            if(ctrl != GO_AND) $stop;
            done_calc = 1;
            clock; if(ctrl != DONE_CALC) $stop;
            clock; if(ctrl != OUT_CALC) $stop;
            clock; if(ctrl != IDLE) $stop;
        end
        if(i == 3)begin
            if(ctrl != GO_XOR) $stop;
            done_calc = 1;
            clock; if(ctrl != DONE_CALC) $stop;
            clock; if(ctrl != OUT_CALC) $stop;
            clock; if(ctrl != IDLE) $stop;
        end
        if(i == 4)begin
            check0;
            if(div_by_zero == 1)begin
                errorflag = 1;
                clock; if(ctrl != OUT_DIV_MULT) $stop;
                clock; if(ctrl != IDLE) $stop;
            end
            else begin
                if(ctrl != GO_DIV) $stop;
                clock;
                for(j = 0; j < 6; j=j+1)begin
                    clock; if(ctrl != DONE_DIV) $stop;
                    clock; if(ctrl != GO_DIV) $stop;
                end
                done_div = 1;
                clock; if(ctrl != DONE_DIV) $stop;
                clock; if(ctrl != OUT_DIV_MULT) $stop;
                clock; if(ctrl != IDLE) $stop;
            end
        end
        if(i == 5)begin
            if(ctrl != GO_MULT) $stop;
            //done_calc = 1;
            clock; if(ctrl != DONE_MULT) $stop;
            clock; if(ctrl != OUT_DIV_MULT) $stop;
            clock; if(ctrl != IDLE) $stop;
        end
        if(i == 6)begin
            if(ctrl != PASS) $stop;
            //done_calc = 1;
            //clock; if(ctrl != DONE_CALC) $stop;
            clock; if(ctrl != OUT_CALC) $stop;
            clock; if(ctrl != IDLE) $stop;
        end
        if(i == 7)begin
            if(ctrl != PASS) $stop;
            //done_calc = 1;
            //clock; if(ctrl != DONE_CALC) $stop;
            clock; if(ctrl != OUT_CALC) $stop;
            clock; if(ctrl != IDLE) $stop;
        end
        clock; rst = 1; go = 0; done_calc = 0; done_div = 0; div_by_zero = 0; 
        clock; rst = 0;
        clock; if(ctrl != IDLE) $stop;
        F = F +1'b1; clock; go = 1;
        clock; go = 0; if(ctrl != LOAD) $stop;
    end
    
    $display("success");
    $finish;
end
endmodule

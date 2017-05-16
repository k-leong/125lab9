`timescale 1ns / 1ps

module div_top(input rst,clk, go,
input[3:0] x,y,
output[3:0] r,q,CS,
output error, done);
wire errorFlag,R_lt_Y,udCE,udLD,udUD,s0,s1,s2,rLD,rSL,rSR,xLD,xSL,xRightIn,yLD;
wire [3:0]cnt_out;

div_CU cu(rst,clk, go,errorFlag, R_lt_Y,cnt_out,error,done, udCE, udLD, udUD, s0, s1, s2, rLD, rSL, rSR, xLD, xSL, xRightIn, yLD,CS);

div_dp dp(rst,clk,udCE,udLD,udUD,s0,s1,s2,rLD,rSL,rSR,xLD,xSL,xRightIn,yLD,4'b0100,x,y,R_lt_Y,cnt_out,r,q,errorFlag);

endmodule

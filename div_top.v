`timescale 1ns / 1ps

module div_top(input rst,clk, go, 
input[3:0] x,y,
output[3:0] r,q,CS,
output error, done);
wire errorFlag,udCE,udLD,udUD,s0,s1,s2,rLD,rSL,rSR,xLD,xSL,xRightIn,yLD;
wire [3:0]cnt_out, R_lt_y;

div_CU cu(.rst(rst),.clk(clk),.go(go),.errorFlag(errorFlag),.R_lt_Y(R_lt_Y),.cnt(cnt_out),
          .error(error),.done(done),.udCE(udCE), .udLD(udLD), .udUD(udUD),.s0(s0),.s1(s1),.s2(s2), .rLD(rLD),
          .rSL(rSL), .rSR(rSR), .xLD(xLD), .xSL(xSL), .xRightIn(xRightIn), .yLD(yLD),.CS(CS));
           
div_dp dp(RST,CLK,udCE,udLD,udUD,s0,s1,s2,rLD,rSL,rSR,
          xLD,xSL,xRightIn,yLD,4'b0100,x,y,R_lt_Y,cnt_out,r,q,errorFlag);

endmodule

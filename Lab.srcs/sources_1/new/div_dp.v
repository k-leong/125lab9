`timescale 1ns / 1ps

module div_dp(
input rst,clk,udCE,udLD,udUD,s0,s1,s2,rLD,rSL,rSR,xLD,xSL,xRightIn,yLD,
input[3:0] n,x,y,
output[3:0] R_lt_Y,cnt_out,r,q,
output error, done
);
wire[4:0] d0,Mout,Sout;
wire[3:0] d1,d2,Uout;
wire Cout;

shift_register#(5) R(Mout,rLD,rSL,rSR,'b0,d1[3],d0,CLK,RST);
shift_register X(x,xLD,xSL,'b0,'b0,xRightIn,d1,CLK,RST);
shift_register Y(y,yLD,'b0,'b0,'b0,'b0,d2,CLK,RST);
div_mux#(5) m0(Sout,'b0,s0,Mout);
div_mux m1(d0[3:0],'b0,s1,r);
div_mux m2(d1,'b0,s2,q);
comparator c(d0,{1'b0,d2},Cout);
subtractor s(d0,{1'b0,d2},Sout);
ud_counter u(n,udCE,udLD,udUD,Uout,CLK,RST);
assign R_lt_Y=Cout;
assign cnt_out=Uout;
Nor N(d2,'b0,error);
endmodule

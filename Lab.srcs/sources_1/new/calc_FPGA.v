`timescale 1ns / 1ps

module calc_FPGA(
    input rst, clk100MHz, button,go,
    input[3:0] x,y,
    input[2:0]F,
    output done,error,
    output[7:0] LEDSEL,LEDOUT);
wire[3:0] CS,out_h,out_l;
wire clk_4sec,clk_5KHz,dbutton;
supply1[7:0] vcc;
wire[7:0] s,w;
assign s[7]=1'b1;
assign w[7]=1'b1;
clk_gen c(clk100MHz,rst,clk_4sec,clk_5KHz);
button_debouncer d(clk_5KHz,button,dbutton);
Top_calc calc(.clk(dbutton),.rst(rst),.go(go),.x(x),.y(y),.F(F),.done(done),.error(error));
hex_to_7seg h({'b0,out_h},s[0],s[1],s[2],s[3],s[4],s[5],s[6]);
hex_to_7seg l({'b0,out_l},w[0],w[1],w[2],w[3],w[4],w[5],w[6]);
led_mux m0(clk_5KHz, rst, vcc, vcc, vcc, vcc, vcc, vcc,out_h,out_l, LEDOUT, LEDSEL);
endmodule

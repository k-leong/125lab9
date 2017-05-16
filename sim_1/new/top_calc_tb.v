`timescale 1ns / 1ps

module top_calc_tb( );
reg clk, rst, go;
reg[3:0] x,y;
reg[2:0] F;
wire done, error;
wire[3:0] out_h, out_l, CS;

Top_calc DUT(clk, rst, go,x, y,F,done,error, out_h, out_l);

//integer i,j,k;
task clock; begin clk = 0; #5; clk = 1; #5; end endtask
 integer temp1;
 reg[7:0] out_value;

initial begin
   
    clock; rst = 1; go = 0;
    clock; rst = 0;
    clock; x = 4'b1010; y = 4'b0011;
    for(temp1=0; temp1<8; temp1=temp1+1)
    begin
    clock; go = 1;
    clock; go = 0;
    F=temp1;// enter load state
    clock;//go signal should be sent
    clock;//done state? 
    clock;// out_value={out_h, out_l};//out state?
    /*clock; rst =1;
    clock; rst = 0;*/

    end
    $finish;
end
endmodule

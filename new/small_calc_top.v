`timescale 1ns / 1ps

module small_calc_top(input go_calc, clk, rst,
                      input [1:0] op,
                      input[3:0] x,y,
                      output done,
                      output[3:0] out, CS);
wire[1:0] s1,wa,raa,rab,c;
wire we, rea, reb,s2;
              
calc_CU calc(.go(go_calc),.clk(clk),.rst(rst),.done_calc(done),.op(op),
                .s1(s1),.wa(wa),.raa(raa),.rab(rab),.c(c),.we(we), .rea(rea), .reb(reb),.s2(s2),.CS(CS));
calc_dp calc1(.in1(x),.in2(y),.s1(s1),.wa(wa),.raa(raa),.rab(rab),.c(c),.we(we),.rea(rea),.reb(reb),.s2(s2),.out(out),.done_calc(done));
endmodule

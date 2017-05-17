`timescale 1ns / 1ps

module small_calc_top(input go_calc, clk, rst,
                      input [1:0] op,
                      input[3:0] x,y,
                      output done,
                      output[3:0] out, CS);
wire[1:0] s1,wa,raa,rab,c;
wire we, rea, reb,s2;
              
calc_CU calc(.clk(clk), .go(go), .rst(rst),.Op(op),.CS(CS),.s1(s1), .wa(wa), .raa(raa), .rab(rab), .c(c), 
              .we(we), .rea(rea), .reb(reb), .s2(s2), .d_flag(done));
calc_dp calc1(.in1(x), .in2(y), .s1(s1), .clk(clk), .wa(wa), .we(we), 
              .raa(raa), .rea(rea), .rab(rab), .reb(reb), .c(c), .s2(s2), .out(out));
endmodule

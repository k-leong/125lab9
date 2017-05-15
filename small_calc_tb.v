`timescale 1ns / 1ps

module small_calc_tb;
reg go_calc, clk, rst;
reg [1:0] op;
reg[3:0] x,y;
wire done;
wire [3:0] out, CS;

small_calc_top DUT(go_calc, clk, rst, op, x,y,done, out, CS);

task clock; begin clk = 0; #5; clk = 1; #5; end endtask

always@(CS,op)begin

end

endmodule

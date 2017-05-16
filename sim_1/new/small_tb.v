`timescale 1ns / 1ps

module small_tb;
reg clk, rst, go;
reg[1:0] op;
reg[3:0] x,y;
wire done;
wire[3:0] out;

task clock; begin clk = 0; #5; clk = 1; #5; end endtask


endmodule

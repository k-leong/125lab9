`timescale 1ns / 1ps

module Reg #(parameter WIDTH = 4)
(input wire clk, rst, en, input wire [WIDTH-1:0] d, output reg [WIDTH-1:0] q);
// asynchronous, active HIGH reset w. enable input
    always @(posedge clk, posedge rst)
        if (rst) q <= 0;
        //else if (!en) q <= 0;
        else if (en) q <= d;
        else q <= q;
endmodule
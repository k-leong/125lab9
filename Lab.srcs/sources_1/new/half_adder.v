`timescale 1ns / 1ps

module half_adder(input a, b, output sum, c_out);

assign sum = a ^ b; // This part can be coded as
assign c_out = a & b; // assign {c_out, sum} = a + b;
endmodule

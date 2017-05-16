`timescale 1ns / 1ps

module calc_mux2(in1, in2, s2, m2out);
input [3:0] in1, in2;
input s2;
output reg [3:0] m2out;
always @ (in1, in2, s2)
begin
if (s2)
m2out = in1;
else
m2out = in2;
end
endmodule

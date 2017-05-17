`timescale 1ns / 1ps

module CLA_gen(
input [3:0] P, G,
input Cin,
output [4:0] Sum
);
assign Sum[0] = Cin;
assign Sum[1] = G[0]  | (P[0] & Cin);
assign Sum[2] = G[1]  | (P[1] & (G[0]  | (P[0] & Cin)));
assign Sum[3] = G[2]  | (P[2] &  (G[1]  | (P[1] & (G[0]  | (P[0] & Cin)))));
assign Sum[4] = G[3]  | (P[3] & (G[2]  | (P[2] &  (G[1]  | (P[1] & (G[0]  | (P[0] & Cin)))))));
endmodule

`timescale 1ns / 1ps

module CLA(
    input [3:0] A, B,
    input Cin,
    output [3:0]Sum,
    output C
    );
    
    wire [3:0] CLA_XOR,P,G;
    integer i;
    half_adder u0(A[0], B[0], P[0], G[0]);
    half_adder u1(A[1], B[1], P[1], G[1]);
    half_adder u2(A[2], B[2], P[2], G[2]);
    half_adder u3(A[3], B[3], P[3], G[3]);
    
    CLA_gen u4(P, G, Cin, {C, CLA_XOR});
    
    assign Sum = P ^ CLA_XOR;

endmodule

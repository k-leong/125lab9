`timescale 1ns / 1ps

module multiplier_pipeline(
                    input [3:0] A_in, B_in,
                    input clk100MHz,rst,en, //go_mult
                    output [7:0] Product,
                    output done
                    );
    wire Cout1, Cout2, Cout3, Cout4, Cout5, Cout6;
    wire [3:0] A, B, PP1, PP2, PP3, PP4;
    wire [7:0] P8_1, P8_2, P8_3, P8_4, Upper_in, Lower_in, Upper, Lower, Product_in;
    
    flopenr u7(clk100MHz, rst, en, {A_in[3:0], B_in[3:0]}, 
   {A[3:0], B[3:0]});
    
    p_generator u0( A, B, PP1, PP2, PP3, PP4);
    // Low
    assign P8_1 = {4'b0, PP1};
    assign P8_2 = {3'b0, PP2, 1'b0};
    // High
    assign P8_3 = {2'b0, PP3, 2'b0};
    assign P8_4 = {1'b0, PP4, 3'b0};
    
    CLA u1(P8_1[3:0], {P8_2[3:1], 1'b0}, 1'b0, Lower_in[3:0], 
 Cout1);
    CLA u2(4'b0, {3'b0, P8_2[4]}, Cout1, Lower_in[7:4], Cout2);
    CLA u3({P8_3[3:2], 2'b0}, {P8_4[3], 3'b0}, 1'b0, 
 Upper_in[3:0], Cout3);
    CLA u4({2'b0, P8_3[5:4]}, {1'b0, P8_4[6:4]}, Cout3, 
 Upper_in[7:4], Cout4);
    
    flopenr u8(clk100MHz, rst, en, Lower_in, Lower);
    flopenr u9(clk100MHz, rst, en, Upper_in, Upper);
    
    CLA u5(Lower[3:0], Upper[3:0], 1'b0, Product_in[3:0], 
 		 Cout5);
    CLA u6(Lower[7:4], Upper[7:4], Cout5, Product_in[7:4], 
 Cout6);

    flopenr u10(clk100MHz, rst, en, Product_in, Product);
endmodule

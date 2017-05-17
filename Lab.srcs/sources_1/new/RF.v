`timescale 1ns / 1ps

module RF(clk, rst, rea, reb, raa, rab, we, wa, din, douta, doutb);
input clk, rst, rea, reb, we;
input [1:0] raa, rab, wa;
input [3:0] din;
output reg [3:0] douta, doutb;
reg [3:0] RegFile [3:0];
always @(rea, reb, raa, rab)begin
    if (rea)
        douta = RegFile[raa];
    else douta = 4'b0000;
    if (reb)
        doutb = RegFile[rab];
    else doutb = 4'b0000;
end
always@(posedge clk)begin
    if (we)
    RegFile[wa] = din;
    else
    RegFile[wa] = RegFile[wa];
end
always@(posedge clk, posedge rst)begin
    if(rst)begin
        douta = 4'b0000;
        doutb = 4'b0000;
    end
    else begin
        douta = RegFile[raa];
        doutb = RegFile[rab];
    end
end
endmodule

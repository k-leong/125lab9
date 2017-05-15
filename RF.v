`timescale 1ns / 1ps

module RF(clk, rea, reb, raa, rab, we, wa, din, douta, doutb);
input clk, rea, reb, we;
input [1:0] raa, rab, wa;
input [3:0] din;
output reg [3:0] douta, doutb;
reg [3:0] RegFile [3:0];
always @(rea, reb, raa, rab)
begin
if (rea)
douta = RegFile[raa];
else douta = 4'b0000;
if (reb)
doutb = RegFile[rab];
else doutb = 4'b0000;
end
always@(posedge clk)
begin
if (we)
RegFile[wa] = din;
else
RegFile[wa] = RegFile[wa];
end
endmodule

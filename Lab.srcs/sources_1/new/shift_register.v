`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/14/2017 06:04:02 PM
// Design Name: 
// Module Name: shift_register
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module shift_register #(parameter Data_width = 4)(
input [Data_width-1:0] D,
input LD,SL,SR,LeftIn,RightIn,
output reg [Data_width-1:0] Q,
input CLK,
input RST
);
always @(posedge CLK ,posedge RST)
begin
  if (RST)Q <= 0;   
  else if(LD) Q<=D;
  else if(SL) Q<={Q[Data_width-2:0],RightIn};
  else if(SR) Q<={LeftIn,Q[Data_width-1:1]};
  else Q<=Q;
end
endmodule


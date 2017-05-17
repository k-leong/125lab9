`timescale 1ns / 1ps

module ud_counter#(parameter Data_width = 4)(
input [Data_width-1:0] D,
input CE,LD,UD,
output reg [Data_width-1:0] Q,
input CLK,
input RST
);
always @(posedge CLK ,posedge RST)
begin
  if (RST)Q <= 0;   
  else if(!CE) Q <= Q;
  else if(LD) Q<=D;
  else if(!UD) Q<=Q-1'b1;
  else Q<=Q+1'b1;
end

endmodule

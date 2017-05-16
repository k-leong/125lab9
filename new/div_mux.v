`timescale 1ns / 1ps

module div_mux #(parameter Data_width = 4)(
input[Data_width-1:0] in1, in2, 
input s2,
output reg[Data_width-1:0] m2out);

always @ (in1, in2, s2)
begin
if (s2)  
    m2out = in1;
else
    m2out = in2;
end

endmodule 


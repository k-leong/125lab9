`timescale 1ns / 1ps

module shift_zero_pad(
    input [3:0] in,
    output [3:0] out,
    output lost
    );
    
    assign out= {{in[2:0]}, 1'b0};
    assign lost= in[3];
endmodule

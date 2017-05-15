`timescale 1ns / 1ps

module p_generator(
    input [3:0]a,
    input [3:0]b,
    output [3:0]p0, p1, p2, p3
    );
    
    
    assign p0 = {{a[3:0]&b[0]}};
    assign p1 = {{a[3:0]&b[1]}}; //might need a shifter
    assign p2 = {{a[3:0]&b[2]}};
    assign p3 = {{a[3:0]&b[3]}};
    
endmodule

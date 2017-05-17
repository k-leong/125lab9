`timescale 1ns / 1ps

module small_calc_tb;
reg go_calc, clk, rst;
reg [1:0] op;
reg[3:0] x,y;
wire done;
wire [3:0] out, CS;
reg [3:0]expected_out;

integer i, j, k;
small_calc_top DUT(go_calc, clk, rst, op, x,y,done, out, CS);

task clock; begin clk = 0; #5; clk = 1; #5; end endtask
initial
begin
    clock; rst = 0;
    clock; rst = 1;
    clock; rst = 0; 
    clock; op=0; x=4'b1100; y=4'b0010;
    for(i=0;i<8;i=i+1)begin
        for(j=0;j<8;j=j+1)
        begin
           for(k=0;k<4;k=k+1)
           begin
                clock; go_calc=1;
                clock; go_calc=0;
                clock; op=op+1'b1;
           end
           clock; y=y+1'b1; 
        end
        clock; x=x+1'b1;
    end
    #10 $display("Success");
    $finish;
end

always @(posedge CS) begin     
    #1 if(CS==3)begin
    if(done!=1) $stop;
    else if(op==2'b11 && out!=x+y) $stop;        
    else if(op==2'b10 && out!=x-y) $stop;
    else if(op==2'b01 && out!=(x&y)) $stop;                                   
    else if(op==2'b00 && out!=(x^y)) $stop;     
    end 
end 
 
endmodule
/*always begin clk = 0; #5; clk = 1; #5; end

initial begin
    #5; rst = 1; go_calc = 0;
    #5; rst = 0;
    for(i = 0; i < 16; i = i+1)
        for(j = 0; j < 16; j = j+1)
            for(k = 0; k < 4; k = k +1)begin
                #5; x = i; y = j; op = k;
                #5; go_calc = 1;
                #5; go_calc = 0;
            end
    $display("success");
    $finish;
end
endmodule*/


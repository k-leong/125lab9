`timescale 1ns / 1ps

module div_tb;
reg clk_tb, rst_tb, go_tb;
reg [3:0] x_tb, y_tb;
wire done_tb, error_tb;
wire [3:0] CS,r_tb, q_tb;

integer i,j;
div_top DUT(.RST(rst_tb),.CLK(clk_tb), .go(go_tb), .x(x_tb), .y(y_tb),
            .r(r_tb), .q(q_tb), .CS(CS), .error(error_tb), .done(done_tb));
always #5 clk_tb=~clk_tb;
initial begin
    rst_tb=1;#10 rst_tb=0;
    clk_tb=0; go_tb=0; rst_tb=0;
    for(i=7;i<16;i=i+1)begin
        x_tb=i;
        for(j=4;j<16;j=j+1)begin
            y_tb=j;
            #10 go_tb=1;
            #10 go_tb=0;
            #200;
        end
    end
    $display("============= Success ========================");
    $stop;
end
always@(CS)begin
    #2 if(CS==8)begin
        if(y_tb==0 && error_tb!=1) $stop;
        else begin
            if(y_tb!=0 && q_tb!=x_tb/y_tb && r_tb!=x_tb%y_tb) $stop;
            end
        end
    end
endmodule

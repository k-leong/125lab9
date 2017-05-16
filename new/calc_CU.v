`timescale 1ns / 1ps

module calc_CU(
input clk, go, rst,
input[1:0] op,
output reg done_calc,we,rea,reb,s2,
output reg[1:0] s1,wa,raa,rab,c,
output reg[3:0] CS
);
parameter Idle=2'b00,Load1=2'b01,Load2=2'b10,Load3=2'b11;

reg[3:0] NS;

always@(posedge clk, posedge rst)begin
    if(rst) CS <= Idle;
    else CS <= NS;
end
always @(CS,go,op)
begin
    case(CS)
        Idle:begin
                rea=0;
                reb=0;
                if(!go) 
                begin
                    s2=0;
                    done_calc=0;
                    NS=Idle;
                end
                else begin
                    c=~op;
                    NS=Load1;
                end
            end
        Load1:begin
                we=1;
                wa=2'b01;
                s1=2'b11;
                NS=Load2;
            end
        Load2:begin
                wa=2'b10;
                s1=2'b10;
                NS=Load3;
            end
        Load3:begin
                wa=2'b11;
                s1=2'b00;
                rea=1;
                reb=1;
                s2=1;
                done_calc=1;
                if(!go)
                NS=Idle;
            end
        default:begin
                raa=2'b01;
                rab=2'b10;
                done_calc=0;
                NS=Idle;
            end
     endcase
end

always @(posedge clk) CS<=NS; 

endmodule

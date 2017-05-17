`timescale 1ns / 1ps
module div_CU(
input rst, clk, go,errorFlag, R_lt_Y,
input[3:0] cnt,
output reg error,done, udCE, udLD, udUD, s0, s1, s2, rLD, rSL, rSR, xLD, xSL, xRightIn, yLD,
output reg[3:0] CS
);
reg[3:0] NS;
reg[12:0] ctrl;

parameter
    cIDLE  = 4'b0000, 
    cLOAD1 = 4'b0001, 
    cSHIFT1= 4'b0010,
    cCNT1  = 4'b0011,
    cLOAD2 = 4'b0100,
    cSHIFT2= 4'b0101,
    cSHIFT3= 4'b0110,
    cSHIFT4= 4'b0111,
    cDONE  = 4'b1000,
    cWAIT1 = 4'b1001,
    cWAIT2 = 4'b1010,
    IDLE  = 13'b000_000_000_000_0, 
    LOAD1 = 13'b110_000_100_100_1, 
    SHIFT1= 13'b000_000_010_010_0,
    CNT1  = 13'b100_000_000_000_0,
    LOAD2 = 13'b000_100_100_000_0,
    SHIFT2= 13'b000_000_010_011_0,
    SHIFT3= 13'b000_000_010_010_0,
    SHIFT4= 13'b000_000_001_000_0,
    DONE  = 13'b000_011_000_000_0,
    WAIT  = 13'b000_100_000_000_0;
  
always @(posedge clk, posedge rst)
begin  
    if(rst && clk) CS<=IDLE;
    else CS<=NS;
end

always@(ctrl) {udCE, udLD, udUD, s0, s1, s2, rLD, rSL, rSR, xLD, xSL, xRightIn, yLD} = ctrl;

always@(CS,go)
begin
    case(CS)
        cIDLE:begin 
            ctrl=IDLE;
            done=0;
            error=0;
            if(go) NS=cLOAD1;
            else NS=cIDLE;
            end
        cLOAD1:begin 
            ctrl=LOAD1;
            NS=cSHIFT1;
            end
        cSHIFT1:begin
            ctrl=SHIFT1;
            NS=cWAIT1;
            end
        cWAIT1:begin
            ctrl=WAIT;
            if(errorFlag) begin error=1;NS=cDONE; end
            else NS=cCNT1;
            end
        cCNT1:begin 
            ctrl=CNT1;
            if(!R_lt_Y) NS=cLOAD2;
            else NS=cSHIFT3;
            end
        cLOAD2:begin 
            ctrl=LOAD2;
            NS=cSHIFT2;
            end
        cSHIFT2:begin 
            ctrl=SHIFT2;
            NS=cWAIT2;
            end
        cSHIFT3:begin 
            ctrl=SHIFT3;
            NS=cWAIT2;
            end
        cWAIT2: begin
            ctrl=WAIT;
            if(cnt!=0) NS=cCNT1;
            else NS=cSHIFT4;
            end
        cSHIFT4:begin 
            ctrl=SHIFT4;
            NS=cDONE;
            end
        cDONE:begin 
            ctrl=DONE;
            done=1;
            NS=cIDLE;
            end
        default: begin NS=IDLE; end
    endcase
end

endmodule


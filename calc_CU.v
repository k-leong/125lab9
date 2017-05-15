`timescale 1ns / 1ps

module calc_CU(input go, clk, rst, done_calc,
               input[1:0] op,
               output reg[1:0] s1,wa,raa,rab,c, done_calcFlag,
               output reg we, rea, reb,s2,
               output reg[3:0] CS);
reg[3:0] NS;
reg[13:0] ctrl;
parameter   IDLE =  14'b00_00_0_00_0_00_0_00_0,
            LOADA = 14'b01_00_1_00_0_00_0_00_0,
            LOADB = 14'b11_01_1_00_0_00_0_00_0,
            WAIT =  14'b10_10_1_00_0_00_0_00_0,
            ADD =   14'b00_11_1_01_1_10_1_00_0,
            SUB =   14'b00_11_1_01_1_10_1_01_0,
            AND =   14'b00_11_1_01_1_10_1_10_0,
            XOR =   14'b00_11_1_01_1_10_1_11_0,
            done =  14'b01_00_0_11_1_11_1_10_1,
            sIDLE =     4'b0000,
            sLOADA =    4'b0001,
            sLOADB =    4'b0010,
            sWAIT =     4'b0011,
            sADD =      4'b0100,
            sSUB =      4'b0101,
            sAND =      4'b0110,
            sXOR =      4'b0111,
            sDONE =     4'b1000;
always@(posedge clk, posedge rst)begin
    if(rst)begin CS <= IDLE; done_calcFlag = 0;end
    else CS <= NS;
end
always@(ctrl) {s1, wa, we, raa, rea, rab, reb, c, s2} = ctrl;
always@(CS, go, op)begin
    case(CS)
        sIDLE:begin
            ctrl = IDLE;
            done_calcFlag = 0;
            if(go) NS = sLOADA;
            else NS = sIDLE;
        end
        sLOADA:begin ctrl = LOADA; NS = sLOADB; end
        sLOADB:begin ctrl= LOADB; NS = sWAIT; end
        sWAIT:begin
            ctrl = WAIT;
            case(op)
                2'b00:begin ctrl = ADD; NS = sADD; end
                2'b01:begin ctrl = SUB; NS = sSUB; end
                2'b10:begin ctrl = AND; NS = sAND; end
                2'b11:begin ctrl = XOR; NS = sXOR; end
            endcase
        end
        sADD:begin ctrl = done; NS = sDONE; end
        sSUB:begin ctrl = done; NS = sDONE; end
        sAND:begin ctrl = done; NS = sDONE; end
        sXOR:begin ctrl = done; NS = sDONE; end
        done:begin 
            if(done_calc)begin
                ctrl = IDLE; done_calcFlag = 1; NS = sIDLE; 
            end
        end
        default: NS = sIDLE;
    endcase
end

always@(posedge clk) CS <= NS;
endmodule

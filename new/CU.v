`timescale 1ns / 1ps

module CU(input clk, rst, go, done_calc, done_div, div_by_zero, //done_mult,
          input [2:0] F,
          output reg en_f, en_x, en_y, go_calc, go_div, go_mult, sel_h, en_out_h, en_out_l, done, errorFlag,
          output reg[1:0] op_calc, sel_l,
          output reg[3:0] CS);
reg[12:0] ctrl;
reg[3:0] NS;

parameter
            sIDLE = 4'b0000,sLOAD = 4'b0001,sADD = 4'b0010,sSUB = 4'b0011,sAND = 4'b0100,
            sXOR = 4'b0101,sDIV = 4'b0110,sMUL = 4'b0111,sPASS = 4'b1000,sDONE_CALC = 4'b1001,
            sDONE_DIV = 4'b1010, sDONE_MUL = 4'b1011, sOUT_CALC = 4'b1100, sOUT_D_M = 4'b1101,
            IDLE =      13'b0_0_0_0_00_0_0_0_00_0_0,
            LOAD1 =     13'b1_1_1_0_00_0_0_0_00_0_0,
            GO_ADD =    13'b0_0_0_1_00_0_0_0_00_0_0,
            GO_SUB =    13'b0_0_0_1_01_0_0_0_00_0_0,
            GO_AND =    13'b0_0_0_1_10_0_0_0_00_0_0,
            GO_XOR =    13'b0_0_0_1_11_0_0_0_00_0_0,
            GO_DIV =    13'b0_0_0_0_00_1_0_0_00_0_0,
            GO_MULT =   13'b0_0_0_0_00_0_1_0_00_0_0,
            PASS =      13'b0_0_0_0_00_0_0_0_00_0_1,
            DONE_CALC = 13'b0_0_0_0_00_0_0_0_01_0_0,
            DONE_DIV =  13'b0_0_0_0_00_0_0_1_11_0_0,
            DONE_MULT = 13'b0_0_0_0_00_0_0_0_10_0_0,
            OUT_CALC =  13'b0_0_0_0_00_0_0_0_00_0_1,
            OUT_DIV_MULT = 13'b0_0_0_0_01_0_0_0_00_1_1;
            
always@(posedge clk, posedge rst)begin
    if(rst) CS <= IDLE;
    else CS <= NS;
end
always@(ctrl) {en_f, en_x, en_y, go_calc, op_calc, go_div, go_mult, sel_h, sel_l, en_out_h, en_out_l} = ctrl;
always@(CS, go)begin //might need to take out q
    case(CS)
        sIDLE:begin
            ctrl = IDLE;
            done = 0;
            errorFlag = 0;
            if(go) NS = sLOAD;
            else NS = sIDLE;
        end
        sLOAD:begin
            ctrl = LOAD1;
            case(F) //F
                3'b000:NS = sADD;
                3'b001:NS = sSUB;
                3'b010:NS = sAND;
                3'b011:NS = sXOR;
                3'b100:begin 
                    if(div_by_zero == 0)begin
                        errorFlag = 0;
                        NS = sDIV;
                    end
                    else begin
                        errorFlag = 1;
                        NS = sOUT_D_M;
                    end
                end
                3'b101:NS = sMUL;
                3'b110:NS = sPASS;
                3'b111:NS = sPASS;
                default: NS = sPASS;
            endcase
        end
        sADD:begin
            ctrl = GO_ADD;
            NS = sDONE_CALC;
        end
        sSUB:begin
            ctrl = GO_SUB;
            NS = sDONE_CALC;
        end
        sAND:begin
            ctrl = GO_AND;
            NS = sDONE_CALC;
        end
        sXOR:begin
            ctrl = GO_XOR;
            NS = sDONE_CALC;
        end
        sDIV:begin
            ctrl = GO_DIV;
            NS = sDONE_DIV;
        end
        sMUL:begin
            ctrl = GO_MULT;
            NS = sDONE_MUL;
        end
        sPASS:begin
            ctrl = PASS;
            NS = sIDLE;
        end
        sDONE_CALC:begin
            ctrl = DONE_CALC;
            if(done_calc)
                NS = sOUT_CALC;
            else
                case(F)
                    3'b000:NS = sADD;
                    3'b001:NS = sSUB;
                    3'b010:NS = sAND;
                    3'b011:NS = sXOR;
                    default:NS = sIDLE;
                endcase
        end
        sDONE_DIV:begin
            ctrl = DONE_DIV;
            if(done_div)
                NS = sOUT_D_M;
            else
                NS = sDIV;
        end
        sDONE_MUL:begin
            ctrl = DONE_MULT;
            /*if(done_mult)
                NS = sOUT_D_M;
            else*/
                NS = sOUT_D_M;
        end
        sOUT_CALC:begin
            ctrl = OUT_CALC;
            done = 1;
            NS = sIDLE;
        end
        sOUT_D_M:begin
            ctrl = OUT_DIV_MULT;
            done = 1;
            NS = sIDLE;
        end
        default: NS = sIDLE;
    endcase
end
endmodule

`timescale 1ns / 1ps

module CU(input clk, rst, go, done_calc, done_div, div_by_zero, errorflag,
          input [2:0] F,
          output reg en_f, en_x, en_y, go_calc, go_div, go_mult, sel_h, en_out_h, en_out_l, done, errorFlag,
          output reg[1:0] op_calc, sel_l,
          output reg[4:0] CS);
wire [1:0] s1_calc, wa, raa, rab, c; 
wire we, rea, reb, s2_calc, d_flag;
wire[3:0] cnt;
wire[3:0] CS_calc, CS_div;
reg err;
wire R_lt_Y, error, udCE, udLD, udUD, s0_div, s1_div, s2_div, rLD, rSL, rSR, xLD, xSL, xRightIn, yLD;
reg[12:0] ctrl;
reg[3:0] NS;
integer y;
calc_CU c0(.clk(clk),.go(go_calc),.rst(rst),.Op(op_calc),.CS(CS_calc),.s1(s1_calc),.wa(wa),.raa(raa),.rab(rab),.c(c),
           .we(we),.rea(rea),.reb(reb),.s2(s2_calc),.d_flag(d_flag));
div_CU c1(.rst(rst),.clk(clk),.go(go_div),.errorFlag(error),.R_lt_Y(R_lt_Y),.cnt(cnt),.error(errorflag),
       .done(done_div),.udCE(udCE),.udLD(udLD), .udUD(udUD), .s0(s0_div), .s1(s1_div), .s2(s2_div), .rLD(rLD), 
       .rSL(rSL), .rSR(rSR), .xLD(xLD), .xSL(xSL), .xRightIn(xRightIn), .yLD(yLD), .CS(CS_div));

parameter
            sIDLE = 5'b00000,sLOAD = 5'b00001,sADD = 5'b00010,sSUB = 5'b00011,sAND = 5'b00100,
            sXOR = 5'b00101,sDIV = 5'b00110,sMUL = 5'b00111,sPASS = 5'b01000,sDONE_CALC = 5'b01001,
            sDONE_DIV = 5'b01010, sDONE_MUL = 5'b01011, sOUT_CALC = 5'b01100, sOUT_D_M = 5'b01101,
            sWAIT = 5'b01110, sSHIFT1 = 5'b10000, sWAIT1 = 5'b10001, sCNT1 = 5'b10010, sLOAD2 = 5'b10011,
            sSHIFT2= 5'b10100,sSHIFT3= 5'b10101,sSHIFT4= 5'b10110,sDONE  = 5'b10111,sWAIT2 = 5'b11000,
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
    if(rst && clk) CS <= IDLE;
    else CS <= NS;
end
always@(ctrl) {en_f, en_x, en_y, go_calc, op_calc, go_div, go_mult, sel_h, sel_l, en_out_h, en_out_l} = ctrl;
always@(CS, go, F)begin //might need to take out q
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
            NS = sSHIFT1;
        end
/*        sSHIFT1:begin
//                    ctrl=SHIFT1;
                    NS=sWAIT1;
                    end
                sWAIT1:begin
   //                 ctrl=WAIT;
                    if(errorFlag) begin err=1;NS=sDONE; end
                    else NS=sCNT1;
                    end
                sCNT1:begin 
   //                 ctrl=CNT1;
                    if(!R_lt_Y) NS=sLOAD2;
                    else NS=sSHIFT3;
                    end
                sLOAD2:begin 
            //        ctrl=LOAD2;
                    NS=sSHIFT2;
                    end
                sSHIFT2:begin 
             //       ctrl=SHIFT2;
                    NS=sWAIT2;
                    end
                sSHIFT3:begin 
            //        ctrl=SHIFT3;
                    NS=sWAIT2;
                    end
                sWAIT2: begin
            //        ctrl=WAIT;
                    if(cnt!=0) NS=sCNT1;
                    else NS=sSHIFT4;
                    end
                sSHIFT4:begin 
           //         ctrl=SHIFT4;
                    NS=sDONE;
                    end*/
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
                   // default:NS = sIDLE;
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

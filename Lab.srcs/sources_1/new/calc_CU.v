`timescale 1ns / 1ps

module calc_CU(
            input clk, go, rst,
            input [1:0] Op,
            output reg [4:0] CS,
            output reg [1:0] s1, wa, raa, rab, c, 
            output reg we, rea, reb, s2, d_flag
            );
reg [14:0] ctrl;
reg [4:0] NS;

parameter
        L1 =        15'b11_01_1_00_0_00_0_00_0_0,
        L2 =        15'b10_10_1_00_0_00_0_00_0_0,
        Add =       15'b00_11_1_01_1_10_1_00_1_0,
        Subtract =  15'b00_11_1_01_1_10_1_01_1_0,
        And =       15'b00_11_1_01_1_10_1_10_1_0,
        Xor =       15'b00_11_1_01_1_10_1_11_1_0,
        Done =      15'b00_00_0_11_1_11_1_11_1_1,
        Idle =      15'b00_00_0_00_0_00_0_00_0_0;

parameter
        ADD =       5'b00000,
        SUBTRACT =  5'b00001,
        AND =       5'b00010,
        XOR =       5'b00011,
        LOAD1 =     5'b00100,
        LOAD2 =     5'b00101,
        DONE =      5'b00110,
        IDLE =      5'b00111;
        
always@(ctrl) {s1, wa, we, raa, rea, rab, reb, c, s2, d_flag} = ctrl;

always@(posedge clk)
begin
    CS <= NS;
end
always@(posedge clk, posedge rst)begin
    if(rst && clk) CS<=Idle;
    else CS <=NS;
end
always@(CS, go, Op)
begin
    case(CS)
        LOAD1:      NS = LOAD2;
        LOAD2:      NS = {2'b0, Op};
        ADD:        NS = DONE;
        SUBTRACT:   NS = DONE;
        AND:        NS = DONE;
        XOR:        NS = DONE;
        DONE:       NS = IDLE;
        IDLE:       
            begin
                if(go) NS = LOAD1;
                else NS = IDLE;
            end
    default: NS = IDLE;
    endcase
end

always@(CS)
begin
    case(CS)
        LOAD1:      begin 
                        ctrl = L1;
                    end
        LOAD2:      begin
                        ctrl = L2;
                    end
        ADD:        begin 
                        ctrl = Add;
                        NS = DONE;
                    end
        SUBTRACT:   begin 
                        ctrl = Subtract;
                         NS = DONE;
                    end
        AND:        begin 
                        ctrl = And;
                         NS = DONE;
                    end
        XOR:        begin 
                        ctrl = Xor;
                        NS = DONE; 
                    end
        DONE:       begin 
                        ctrl = Done;
                        NS = IDLE;
                    end
        IDLE:       begin 
                        ctrl = Idle;
                    end
        default: ctrl = Idle;
    endcase
end

endmodule

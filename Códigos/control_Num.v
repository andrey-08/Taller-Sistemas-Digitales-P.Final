`timescale 1ns / 1ps

module control_Num(
    input [3:0] segundo1, segundo2,
    input [3:0] minuto1, minuto2,
    input [3:0] hora1, hora2,
    input [2:0] refreshcounter,
    output reg [3:0] ONE_Digit =0
    );
    
    always @(refreshcounter)
        begin
            case (refreshcounter)
                3'b000:
                     ONE_Digit= segundo1; 
                3'b001:
                     ONE_Digit= segundo2; 
                3'b010:
                     ONE_Digit= minuto1;
                3'b011:
                     ONE_Digit= minuto2; 
                3'b100:
                     ONE_Digit= hora1; 
                3'b101:
                     ONE_Digit= hora2;
                default ONE_Digit = 4'bxxxx;  
            endcase   
        end
endmodule

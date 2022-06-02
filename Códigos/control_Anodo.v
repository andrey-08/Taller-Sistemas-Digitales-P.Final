`timescale 1ns / 1ps

module control_Anodo(
    input [2:0] cont_anodo,
    output reg [7:0] anodo_on
    );
    
    always@(cont_anodo)
    begin
        case(cont_anodo)
            3'b000:
                 anodo_on= 8'b11111110; //seg1
            3'b001:
                 anodo_on= 8'b11111101; //seg2
            3'b010:
                 anodo_on= 8'b11111011; //min1
            3'b011:
                 anodo_on= 8'b11110111; //min2
            3'b100:
                 anodo_on= 8'b11101111; //hora1
            3'b101:
                 anodo_on= 8'b11011111; //hora2     
            default : anodo_on <= 8'bxxxxxxxx;
    endcase
    end
endmodule

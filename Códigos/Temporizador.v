`timescale 1ns / 1ps

module Temporizador(
    input [4:0] T_selec,
    input [4:0] seleccion, 
    output reg [4:0] num
    );
    
    always @(seleccion)
        begin
            case(seleccion)
                5'b10000: num <= T_selec; //tiempo definido por boton
                5'b01000: num <= 20;  //Descongelar
                5'b00100: num <= 10; //Palomitas
                5'b00010: num <= 5; //Mantequilla
                5'b00001: num <= 15; //Pizza
                5'b00000: num <= 0; //Standby
                
                default : num = 5'bxxxxx;
            endcase
        end
endmodule

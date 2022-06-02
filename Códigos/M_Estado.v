`timescale 1ns / 1ps

module M_Estado(
    input Clk,
    input reset,
    input Ajust,Calent, 
    output reg [3:0] Estado
    );
    
    parameter inicio =      4'b0000,
              ajuste =      4'b0001,
              seleccionar = 4'b0010,
              calentar =    4'b0100;
    
    reg [3:0] actual, siguiente;
    always @(posedge Clk, posedge reset)
    begin
        if(reset)
            actual<=inicio;
        else
            actual<= siguiente;
    end
    
    always @(actual, Ajust)
     begin
            Estado=0;
            case(actual)
               inicio:
                    if(Ajust==1)
                        begin
                        siguiente = ajuste;
                        Estado = ajuste;
                        end
                        
                    else if(Calent==1)
                        begin
                        siguiente = calentar;
                        Estado= calentar;
                        end
                        
                    else
                        begin
                        siguiente = inicio;
                        Estado = inicio;
                        end
                        
               ajuste:
                    if(Ajust==1)
                        begin
                        siguiente = ajuste;
                        Estado = ajuste;
                        end
                    else
                        begin
                        siguiente = inicio;
                        Estado = inicio;
                        end
                            
               calentar:
                  if(Calent ==1)
                      begin
                      siguiente=calentar;
                      Estado=calentar;
                      end
                  else
                        begin
                        siguiente = inicio;
                        Estado = inicio;
                        end         
            endcase
    end
endmodule

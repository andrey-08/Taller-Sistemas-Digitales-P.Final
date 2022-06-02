`timescale 1ns / 1ps

module FFDhour(
    input clockM,
    input enableC,
    input Dd,
    output reg Qq=0
    );
    
    always @ (posedge clockM) begin
    if (enableC==1)
        Qq <= Dd;  
    end 
endmodule

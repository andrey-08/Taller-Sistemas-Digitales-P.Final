`timescale 1ns / 1ps

module FFDtime(
    input reloj_p, 
    input en_Clk,
    input ent,
    output reg outF=0
    );
    
    always @ (posedge reloj_p) begin
    if (en_Clk==1)
        outF <= ent;   
    end
    
endmodule

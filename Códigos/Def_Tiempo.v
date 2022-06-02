`timescale 1ns / 1ps

module Def_Tiempo(
    input clk,
    input btn_centro,
    input switchB,
    output reg [4:0] tiempoOut=0
    );
    
    reg [26:0] cuenta=0;
    wire  reloj_Slow;
    wire FF_0,FF_1, FF_2, FF_3, FF_2bar;
    wire btnC;
    wire [4:0] wireDef;
    reg [4:0] tiempoDef=0;
    
    always @(posedge clk)
    begin
        cuenta<= (cuenta>=249999)? 0 : cuenta+1;  
    end
    assign reloj_Slow = (cuenta==249999) ? 1'b1 : 1'b0;
    
    FFDtime FT1 (.reloj_p(clk), .en_Clk(reloj_Slow), .ent(btn_centro), .outF(FF_0));
    FFDtime FT2 (.reloj_p(clk), .en_Clk(reloj_Slow), .ent(FF_0), .outF(FF_1));
    FFDtime FT3 (.reloj_p(clk), .en_Clk(reloj_Slow), .ent(FF_1), .outF(FF_2));
    
    assign FF_2bar = ~FF_2;
    assign btnC = FF_1 & FF_2bar & reloj_Slow;
    
    always @( posedge clk )
    begin
        if (btnC==1'b1)
            if(tiempoDef== 5'd20) tiempoDef<=0;
            else if(switchB==0) tiempoDef<=0;
            else tiempoDef <= tiempoDef + 1'd1;
    end
    
    assign wireDef = tiempoDef;
    
    always @( posedge clk)
    begin
        case(switchB)
            1'b1: tiempoOut = wireDef;
            1'b0: tiempoOut = 0;
        endcase
    end
    
endmodule

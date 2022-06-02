`timescale 1ns / 1ps

module AjusteHoras(
    input mainClk,
    input cambioH,
    input switchB,
    output reg [5:0] horasChange
    );
    
    wire enable_slow;  
    wire q1,q2,q2_bar, q0;  
    wire btnL; 
    reg [5:0] outhour=0;
    wire [5:0] wirehour;
    
    Div_DHour SC (.main(mainClk), .C_en(enable_slow));
    FFDhour FH1 (.clockM(mainClk), .enableC(enable_slow), .Dd(cambioH), .Qq(q0));
    FFDhour FH2 (.clockM(mainClk), .enableC(enable_slow), .Dd(q0), .Qq(q1));
    FFDhour FH3 (.clockM(mainClk), .enableC(enable_slow), .Dd(q1), .Qq(q2));
    
    assign q2_bar= ~q2;
    assign btnL= q1 & q2_bar & enable_slow;
    
    always @(posedge mainClk)
    begin
        if(btnL==1'b1)
            if(outhour==6'd23) outhour <= 0; 
            else outhour <= outhour + 1;
    end
    
    assign wirehour = outhour;
    
    always @(posedge mainClk)
    begin
        case(switchB)
            1'b1: horasChange = wirehour;
            1'b0: horasChange = 0;
        endcase
    end
    
endmodule

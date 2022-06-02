`timescale 1ns / 1ps

module Div_DHour(
    input main,
    output C_en
    );
    
    reg [26:0]counter1=0;
    always @(posedge main)
    begin
        counter1<= (counter1>=249999)? 0 : counter1+1;  
    end
    assign C_en = (counter1==249999) ? 1'b1 : 1'b0;
endmodule

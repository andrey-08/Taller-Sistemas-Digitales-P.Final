`timescale 1ns / 1ps

module FFDmin(
    input clk_M,
    input clock_enable,
    input D,
    output reg Q=0
    );
    
    always @ (posedge clk_M) begin
    if (clock_enable==1)
        Q <= D;   
    end
    
endmodule

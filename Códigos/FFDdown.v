`timescale 1ns / 1ps

module FFDdown(
    input clk_m,
    input clock_e,
    input in,
    output reg out=0
    );
    
    always @ (posedge clk_m) begin
    if (clock_e==1)
        out <= in;   
    end
endmodule

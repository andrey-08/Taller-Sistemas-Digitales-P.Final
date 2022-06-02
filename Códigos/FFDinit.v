`timescale 1ns / 1ps

module FFDinit(
    input clk_m1, clock_e1, in1,
    output reg out1=0
    );
    
    always @ (posedge clk_m1) begin
    if (clock_e1==1)
        out1 <= in1;   
    end
endmodule

`timescale 1ns / 1ps

module DebounceDown(
    input clkDB,
    input btn_in,
    output btn_out
    );
    
    wire slow_clock_en;
    wire out0, out1, out2, out2_bar;
    
    reg [26:0]count=0;
    always @(posedge clkDB)
    begin
        count<= (count>=249999)? 0 : count+1;  
    end
    assign slow_clock_en = (count==249999) ? 1'b1 : 1'b0;
    
    FFDdown ff1 (.clk_m(clkDB),.clock_e(slow_clock_en), .in(btn_in), .out(out0));
    FFDdown ff2 (.clk_m(clkDB),.clock_e(slow_clock_en), .in(out0), .out(out1));
    FFDdown ff3 (.clk_m(clkDB),.clock_e(slow_clock_en), .in(out1), .out(out2));
    
    assign out2_bar = ~out2;
    assign btn_out = out1 & out2_bar & slow_clock_en;
    
endmodule

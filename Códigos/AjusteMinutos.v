`timescale 1ns / 1ps

module AjusteMinutos(
    input clkS,
    input cambioM,
    input switch,
    output reg [5:0] minChange
    );
    
    wire slow_clk_en;
    wire Q1,Q2,Q2_bar, Q0;
    wire btnU;
    reg [5:0] outMin;
    wire [5:0] wireMin;
    reg [26:0]counterD=0;
    
    always @(posedge clkS)
    begin
        counterD<= (counterD>=249999)? 0 : counterD+1;  
    end
    assign slow_clk_en = (counterD==249999) ? 1'b1 : 1'b0;
    
    FFDmin FF1 (.clk_M(clkS),.clock_enable(slow_clk_en), .D(cambioM), .Q(Q0));
    FFDmin FF2 (.clk_M(clkS),.clock_enable(slow_clk_en),  .D(Q0), .Q(Q1));
    FFDmin FF3 (.clk_M(clkS),.clock_enable(slow_clk_en),  .D(Q1), .Q(Q2));
    
    assign Q2_bar = ~Q2;
    assign btnU = Q1 & Q2_bar & slow_clk_en;
    
    always @ (posedge clkS)begin
        if (btnU==1'b1)
            if(outMin== 6'd59) outMin<=0;
            else outMin <= outMin + 1'd1; 
    end	
    
    assign wireMin = outMin;
    
    always @(posedge clkS)
    begin
        case(switch)
            1'b1: minChange = wireMin;
            1'b0: minChange = 0;
        endcase
    end
    			
endmodule

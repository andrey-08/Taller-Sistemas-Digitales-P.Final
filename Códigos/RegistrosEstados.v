`timescale 1ns / 1ps


module RegistrosEstados(
    input clk,
    input reset_E,
    input Est_B,
    input Est_D,
    output outB,
    output outD
    );
    ////////////////EstadoB///////////////////
    reg state_B;
    always @(posedge clk) begin      
        if(reset_E == 1)
            state_B <= 0;
        else if (Est_B == 1) 
            state_B <=1 ;      
    end  
    assign outB = state_B;
    ////////////////////////////////////////////
    
//     ////////////////EstadoC///////////////////
//    reg state_C;
//    always @(posedge clk) begin      
//        if(reset_E == 1)
//            state_C <= 0;
//        else if (Est_C == 1) 
//            state_C <=1 ;      
//    end  
//    assign outC = state_C;
//    ////////////////////////////////////////////
    
    
    ////////////////EstadoD///////////////////
    reg state_D;
    always @(posedge clk) begin      
        if(reset_E == 1)
            state_D <= 0;
        else if (Est_D == 1) 
            state_D <=1 ;      
    end  
    assign outD = state_D;
    ////////////////////////////////////////////
endmodule

`timescale 1ns / 1ps

module calentar(
    input clk,
    input [4:0] numero, // numero seleccionado para resta
    input inicio,       //boton de inicio para calentar
    output reg [4:0] resta_out,
    output reg alarma =0,
    output reg finish 
    );
    
    reg [4:0] Numselec=0;
    reg [4:0] numresta=0;
    reg estado;
    wire [4:0] numR;
    
    //////////////////////// Deteccion de botón inicio//////////////////
    wire slow_clock_en1;
    wire out_0, out_1, out_2, out2_bar1;
    wire btn_out1;
    
    reg [26:0]contadorB=0;
    always @(posedge clk)
    begin
        contadorB<= (contadorB>=249999)? 0 : contadorB+1;  
    end
    assign slow_clock_en1 = (contadorB==249999) ? 1'b1 : 1'b0;
    
    FFDinit f1 (.clk_m1(clk),.clock_e1(slow_clock_en1), .in1(inicio), .out1(out_0));
    FFDinit f2 (.clk_m1(clk),.clock_e1(slow_clock_en1), .in1(out_0), .out1(out_1));
    FFDinit f3 (.clk_m1(clk),.clock_e1(slow_clock_en1), .in1(out_1), .out1(out_2));
    
    assign out2_bar1 = ~out_2;
    assign btn_out1 = out_1 & out2_bar1 & slow_clock_en1;
    //////////////////////////////////////////////////////////////////////
    
    assign numR=numresta;
    
    /////////////////Operacion de resta para 1 seg//////////////////////
    
    localparam div_v1=99999999;
    integer counter_v1=0;
    always @(posedge clk)
    begin 
        if (counter_v1==div_v1 || btn_out1==1)
            counter_v1 <= 0; // resetea el contador 
        else
            counter_v1 <= counter_v1 +1;
     
    end
    
    always @(posedge clk) begin
        if (counter_v1==div_v1) begin /// si ya pasó 1 segundo
            if(numR>0)
                numresta= numR-1;
            else 
                numresta=0;
        end
        else if (btn_out1==1) 
                numresta=numero;                  
    end
    
    //////////////////////////////////////////////////////
    
    //////////////////////Alarma//////////////////////////
    localparam div_Alarm=99999999;
    integer counter_Alarm=0;
    integer tempAlarm=0;
    always @(posedge clk)
    begin 
       
        if (counter_Alarm==div_Alarm ) 
            counter_Alarm <= 0; // resetea el contador
            
        else
            counter_Alarm <= counter_Alarm +1;   
    end
    
    always @(posedge clk) 
    begin
            
        if (counter_Alarm==div_Alarm ) begin
            if(numR==0 && tempAlarm<5)
                tempAlarm <= tempAlarm +1; 
        end
        
        else if (btn_out1==1)
            tempAlarm <= 0;
    
    end
     
    always @( posedge clk)
    begin
        if(numR==0 && tempAlarm<4)
            alarma = 1;
        else 
            alarma = 0;
    end
    
    always @ (posedge clk) begin
        if (tempAlarm==3)
            finish=1;
        else
            finish=0;
    end
    
    ////////////// Máquina de Estado//////////////////////
    
     parameter estadoA= 1'b0, //StandBy
              estadoB= 1'b1; //Restar
    
    reg estado_actual, estado_siguiente=0;
    always @(posedge clk)
    begin
        if(finish==1)
            estado_actual<= estadoA;
        else
            estado_actual<= estado_siguiente;
    end
    always @(btn_out1, estado_actual)
        begin
            estado = 0;
            case(estado_actual)
               estadoA:
                    if(btn_out1==1)
                        begin
                        estado_siguiente=estadoB;
                        estado= estadoB;
                        end
                    else
                        begin
                        estado_siguiente=estadoA;
                        estado=estadoA;
                        end
               estadoB:
                    if(btn_out1==1)
                        begin
                        estado_siguiente=estadoB;
                        estado=estadoB;
                        end
                    else
                        begin
                        estado_siguiente=estadoB;
                        estado=estadoB;
                        end
              endcase  
        end        
    ///////////////////////////////////////////////////////
    
    /////////// Escoge que mostrar en la salida///////////
    always @(posedge clk) begin
        case(estado)
            1'b0: resta_out<=numero;
            
            1'b1: 
                  resta_out<=numR;         
        endcase
    end
    
endmodule

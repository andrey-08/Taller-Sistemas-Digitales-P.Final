`timescale 1ns / 1ps

module Top(
    input clk,
    input botonIz,      ///ajuste de hora
    input botonUp,     /// ajuste de minutos
    input botonDown,   /// Cargar ajuste
    input botonDer,    ///Inicia opcion de calentar
    input botonCentro, ///Aumenta la seleccion de 0-20
    input EstadoB, EstadoD,
    input S_reset,     //// Switch reset R5
    input [4:0]num,
    output [6:0] catodoP,
    output [7:0] anodoP,
    output reg alarm
    );
    
    wire [3:0]State;             // Salida de maquina de estados
    wire reset;
    wire S_B, S_D;                   //Salildas de registros
    reg [5:0] ShowM, ShowH, ShowS;  //Valores Seleccionados para mostrar display
    reg fin;                    // Salir de estado B despues de cargar
    wire [4:0] segundoTemp;    // salida del tiempo predefinido seleccionado 
    wire [4:0] resta;         // Salida del modulo calentar
    wire finish1;            /// Salir de estado D despues de la alarma
    wire [4:0] timeSelect;
    wire LedAlarma;
    
    assign reset= S_reset | fin | finish1; //reset para estados y registros
    
    ////////////////////////////// Ajuste de reloj (EstadoB)/////////////////////////////
    wire [5:0] Aj_H, Aj_M;
    wire btn;
    AjusteHoras Ajuste_Hora(.mainClk(clk), .cambioH(botonIz), .switchB(S_B), .horasChange(Aj_H));
    
    AjusteMinutos Ajuste_Min(.clkS(clk), .cambioM(botonUp), .switch(S_B), .minChange(Aj_M));
    
    DebounceDown DDown(.clkDB(clk), .btn_in(botonDown), .btn_out(btn));
    
    ////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////Registro de estado//////////////////////////////////////
    
    RegistrosEstados RE (.clk(clk), .reset_E(reset), .Est_B(EstadoB), .Est_D(EstadoD), .outB(S_B), .outD(S_D));
   
    /////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////Maquina  de estado//////////////////////////////////////
    
    M_Estado maquinaP (.Clk(clk), .reset(reset), .Ajust(S_B), .Calent(S_D), .Estado(State));
    
    /////////////////////////////////////////////////////////////////////////////////
    //////////////////////// Definir tiempo de calentar///////////////////////////
    
    Def_Tiempo DefT(.clk(clk), .btn_centro(botonCentro), .switchB(S_D), .tiempoOut(timeSelect));
    
    /////////////////////////////////////////////////////////////////////////////////
    //////////////////////// Tiempo predefinido y calentar///////////////////////////
    Temporizador temp( .T_selec(timeSelect), .seleccion(num), .num(segundoTemp));
    
    calentar C1( .clk(clk), .numero(segundoTemp), .inicio(botonDer), .resta_out(resta), .alarma(LedAlarma), .finish(finish1));
    
    /////////////////////////////////////////////////////////////////////////////////
    //////////////////////////// Divisor segundo/////////////////////////////////////
 
    localparam div_valor=99999999; //1 seg => ((100x10^6)/frecDeseada)-1
    integer counter_valor=0;
    always @(posedge clk)
    begin
        if(btn == 1 && S_B == 1) 
            counter_valor <= 0;
        if (counter_valor==div_valor)
            counter_valor <= 0; // resetea el contador
        else
            counter_valor <= counter_valor +1;   
    end
    
    reg clkSeg=0;
    localparam div=49999999; //1 seg => ((100x10^6)/2*frecDeseada)-1
    integer contador=0;
    always @(posedge clk)
    begin 
        if(btn == 1 && S_B == 1)
            contador <= 0;
        if (contador==div)
            contador <= 0; // resetea el contador
        else
            contador <= contador +1;   
    end
    
    always @(posedge clk)
    begin 
        if (contador==div)
            clkSeg <= ~clkSeg; // resetea el contador
        else
            clkSeg <= clkSeg;   
    end
    ///////////////////////////////////////////////////////////////////////////
    
    ///////////////////////////////Reloj //////////////////////////////////////
    reg [5:0] SegTemp=58;
    reg [5:0] MinTemp=58;
    reg [5:0] HorasTemp=23;
    reg [5:0] hora_r, minuto_r, segundo_r;
    
    always @(posedge clk)
    begin
        if (btn==1 && S_B==1)
            fin <= 1;
        else
            fin <= 0;
    end
     
    always @(posedge clk)
    begin
         if(counter_valor==div_valor)begin 
            if (SegTemp == 59) begin
                SegTemp = 0;
                MinTemp = MinTemp + 1;
                if (MinTemp == 60) begin
                    MinTemp = 0;
                    HorasTemp = HorasTemp + 1;
                    if(HorasTemp == 24)
                        HorasTemp = 0;               
                end      
            end
            else
                SegTemp= SegTemp + 1;
        end 
        else if(btn == 1 && S_B == 1) begin
            SegTemp=0;
            MinTemp = Aj_M;
            HorasTemp = Aj_H;
        end  
    end
    
    
     always @(posedge clkSeg)
     begin
         hora_r = HorasTemp;
         minuto_r= MinTemp;
         segundo_r= SegTemp;
     end
    //////////////////////////////////////////////////////////////////////////////
    
    always @(posedge clk)
    begin
        case(State)
            4'b0000: begin //reloj
                     ShowS=segundo_r;
                     ShowM=minuto_r;
                     ShowH=hora_r;
                     alarm=0;
                     end
            4'b0001: begin //ajuste
                     ShowS=0;
                     ShowM=Aj_M;
                     ShowH=Aj_H;
                     alarm=0;
                     end
             4'b0100:begin //calentamiento
                    ShowS=resta;
                    ShowM=0;
                    ShowH=0;
                    alarm=LedAlarma;
                    end
            default : begin
                     ShowS= 5'bxxxxx;
                     ShowM= 5'bxxxxx;
                     ShowH= 5'bxxxxx;
                     end            
        endcase
    end
    ////////////////////////Controlador 7 segmentos /////////////////////////////                      
    Controller_7Seg controller(.clk_c(clk), .segundos(ShowS), .minutos(ShowM), .horas(ShowH), .catodo(catodoP), .anodo(anodoP));
    
endmodule

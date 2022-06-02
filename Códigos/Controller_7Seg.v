`timescale 1ns / 1ps

module Controller_7Seg(
    input clk_c,
    input [5:0] segundos,
    input [5:0] minutos,
    input [5:0] horas,
    output [6:0] catodo,
    output [7:0] anodo
    );
                     ///////////////////////   
                     //Frecuencia Refresco//
                     ///////////////////////
    localparam valor_d=1; //10KHz => ((100x10^6)/2*frecDeseada)-1 4165
    integer counter=0;
    always @(posedge clk_c)
    begin 
        if (counter==valor_d)
            counter<= 0; // resetea el contador
        else
            counter <= counter +1;   
    end
    
    reg clkRefresh=0;
    always @(posedge clk_c)
    begin
        if (counter==valor_d)
            clkRefresh <=~clkRefresh;
        else
            clkRefresh <= clkRefresh;
    end
    
                /////////////////////////////////////////
               ////Decodificador Bin- BCD de segundos///
               /////////////////////////////////////////
    reg [3:0] i=0;
    reg [13:0] desplazamiento=0;
    reg [3:0] temp_unidad=0;
    reg [3:0] temp_decena=0;
    reg [5:0] Old_seg=0;
    reg [3:0] decena=0, unidad=0;
    wire [3:0] seg1, seg2;
    
    always @(posedge clkRefresh)
    begin
        if(i==0 & (Old_seg != segundos))
        begin
	    desplazamiento = 14'd0;
            Old_seg = segundos;
            desplazamiento[5:0]= segundos[5:0];
            temp_decena= desplazamiento[13:10];
            temp_unidad= desplazamiento[9:6];
            i=i+1;
        end
        if (i<7 & i>0) begin
  
           if (temp_decena>=5) temp_decena=temp_decena+3; 
           if (temp_unidad>=5) temp_unidad=temp_unidad+3;
           desplazamiento[13:6]= {temp_decena,temp_unidad };
           desplazamiento= desplazamiento<<1;
           
           temp_decena= desplazamiento[13:10];
           temp_unidad= desplazamiento[9:6];
        
           i=i+1;
           
        end
        
        if (i==7) begin
            i=0;
            decena= temp_decena;
            unidad=  temp_unidad;
        end
    end
    assign seg1= unidad;
    assign seg2= decena;
    
                    /////////////////////////////////////////
                   ////Decodificador Bin- BCD de minutos////
                   /////////////////////////////////////////
    
    reg [3:0] j=0;
    reg [13:0] desplazM=0;
    reg [3:0] temp_unitM=0;
    reg [3:0] temp_decM=0;
    reg [5:0] Old_Min=0;
    reg [3:0] decenaMin=0;
    reg [3:0] unidadMin=0;
    wire [3:0] min1, min2;
    
    always @(posedge clkRefresh)
    begin
        if(j==0 & (Old_Min != minutos))
        begin
	    desplazM = 14'd0;
            Old_Min = minutos;
            desplazM[5:0]= minutos[5:0];
            temp_decM= desplazM[13:10];
            temp_unitM= desplazM[9:6];
            j=j+1;
        end
        if (j<7 & j>0) begin
  
           if (temp_decM>=5) temp_decM=temp_decM+3; 
           if (temp_unitM>=5) temp_unitM=temp_unitM+3;
           desplazM[13:6]= {temp_decM,temp_unitM};
           desplazM= desplazM<<1;
           
           temp_decM= desplazM[13:10];
           temp_unitM= desplazM[9:6];
        
           j=j+1;
           
        end
        
        if (j==7) begin
            j=0;
            decenaMin= temp_decM;
            unidadMin=  temp_unitM;
        end
    end
    assign min1=unidadMin;
    assign min2=decenaMin;
    
                      /////////////////////////////////////////
                      ////Decodificador Bin- BCD de horas//////
                      /////////////////////////////////////////  
    reg [3:0] h=0;
    reg [13:0] desplazH=0;
    reg [3:0] temp_unitH=0;
    reg [3:0] temp_decH=0;
    reg [5:0] Old_Hora=0;
    reg [3:0] decenaHora=0;
    reg [3:0] unidadHora=0;
    wire [3:0] hora1, hora2;
    always @(posedge clkRefresh)
    begin
        if(h==0 & (Old_Hora != horas))
        begin
	    desplazH = 14'd0;
            Old_Hora = horas;
            desplazH[5:0]= horas[5:0];
            temp_decH= desplazH[13:10];
            temp_unitH= desplazH[9:6];
            h=h+1;
        end
        if (h<7 & h>0) begin
  
           if (temp_decH>=5) temp_decH=temp_decH+3; 
           if (temp_unitH>=5) temp_unitH=temp_unitH+3;
           desplazH[13:6]= {temp_decH,temp_unitH};
           desplazH= desplazH<<1;
           
           temp_decH= desplazH[13:10];
           temp_unitH= desplazH[9:6];
        
           h=h+1;
           
        end
        
        if (h==7) begin
            h=0;
            decenaHora= temp_decH;
            unidadHora=  temp_unitH;
        end
    end
    assign hora1=unidadHora;
    assign hora2=decenaHora;  
                     
                       /////////////////////////////////////////
                      ////Refresca el # del digito a mostrar////
                      /////////////////////////////////////////
    reg [2:0] refresh_count=0;
    wire [2:0] refreshcount;
    always @(posedge clkRefresh)
    begin
           if(refresh_count==5)
                refresh_count<=0;
           else
                refresh_count <= refresh_count +1;
    end                  
    assign refreshcount = refresh_count;
    
                    /////////////////////////////////////////
                             ////control anodo////
                  /////////////////////////////////////////
    control_Anodo CA (.cont_anodo(refreshcount), .anodo_on(anodo));
    
                  /////////////////////////////////////////
                       ////control numero a mostrar////
                  /////////////////////////////////////////
    wire [3:0] Digito;
    control_Num CN (
        .segundo1(seg1), 
        .segundo2(seg2), 
        .minuto1(min1), 
        .minuto2(min2),
        .hora1(hora1), 
        .hora2(hora2),
        .refreshcounter(refreshcount),
        .ONE_Digit(Digito));
                   /////////////////////////////////////////
                       ////Decodificador BCD_7Seg////
                  /////////////////////////////////////////
   BCD_7seg BS (.entrada(Digito), .segmentos(catodo));               
                       
endmodule

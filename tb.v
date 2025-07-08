`timescale 1ns/1ps

module tb();

reg clk;
reg rst_n;
reg start;
wire [3:0] state;

maquina_maluca dut (
    .clk   (clk),
    .rst_n (rst_n),
    .start (start),
    .state (state)
);

    initial clk = 0;
    always  #5  clk = ~clk;

    localparam  IDLE                = 4'd1,
                LIGAR_MAQUINA       = 4'd2,
                VERIFICAR_AGUA      = 4'd3,
                ENCHER_RESERVATORIO = 4'd4,
                MOER_CAFE           = 4'd5,
                COLOCAR_NO_FILTRO   = 4'd6,
                PASSAR_AGITADOR     = 4'd7,
                TAMPEAR             = 4'd8,
                REALIZAR_EXTRACAO   = 4'd9;

    reg [3:0] estado [0:9];
    integer   i;

    initial begin
 
        rst_n = 0; 
        start = 0; 
        #5;
        rst_n = 1;         
        #2;
        start = 1;

        estado[0] = LIGAR_MAQUINA;
        estado[1] = VERIFICAR_AGUA;
        estado[2] = ENCHER_RESERVATORIO;
        estado[3] = VERIFICAR_AGUA;
        estado[4] = MOER_CAFE;
        estado[5] = COLOCAR_NO_FILTRO;
        estado[6] = PASSAR_AGITADOR;
        estado[7] = TAMPEAR;
        estado[8] = REALIZAR_EXTRACAO;
        estado[9] = IDLE;

        for(i = 0; i < 10; i = i + 1) 
        begin
            @(posedge clk);   
            #1;             
            if(state === estado[i])
            begin
                $display("OK   : estado[%0d] -> state[%0d]", i, state);
            end
            else
            begin
                $display("ERRO : estado[%0d] -> state[%0d]", estado[i], state);
            end
        end

        $finish;
    end

endmodule

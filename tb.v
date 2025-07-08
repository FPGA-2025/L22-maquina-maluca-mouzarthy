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


// Clock
    always #5 clk = ~clk;

    // Sequência esperada de estados:
    // IDLE -> LIGAR_MAQUINA -> VERIFICAR_AGUA -> ENCHER_RESERVATORIO -> VERIFICAR_AGUA
    // -> MOER_CAFE -> COLOCAR_NO_FILTRO -> PASSAR_AGITADOR -> TAMPEAR -> REALIZAR_EXTRACAO -> IDLE
    reg [3:0] expected_states[0:10];
    integer i;
    reg erro_detectado;

    initial begin

        clk     = 0;
        rst_n   = 0;
        start   = 0;
        erro_detectado = 0;

        expected_states[0]  = 4'd1; // IDLE
        expected_states[1]  = 4'd2; // LIGAR_MAQUINA
        expected_states[2]  = 4'd3; // VERIFICAR_AGUA
        expected_states[3]  = 4'd4; // ENCHER_RESERVATORIO
        expected_states[4]  = 4'd3; // VERIFICAR_AGUA
        expected_states[5]  = 4'd5; // MOER_CAFE
        expected_states[6]  = 4'd6; // COLOCAR_NO_FILTRO
        expected_states[7]  = 4'd7; // PASSAR_AGITADOR
        expected_states[8]  = 4'd8; // TAMPEAR
        expected_states[9]  = 4'd9; // REALIZAR_EXTRACAO
        expected_states[10] = 4'd1; // IDLE

        // Aplica reset
        #12 rst_n = 1;

        // Aguarda estado IDLE inicial
        wait (state == 4'd1);

        // Envia start
        #10 start = 1;
        #10 start = 0;

        // Verifica a sequência de estados esperados
        for (i = 1; i <= 10; i = i + 1) begin
            wait (state == expected_states[i]);
            if (state !== expected_states[i]) begin
                erro_detectado = 1;
            end
            @(posedge clk); // espera estabilização
        end

        // Resultado
        if (erro_detectado)
            $display("ERRO");
        else
            $display("OK");

        $finish;
    end

endmodule

module Sequencia (
    input wire clk,
    input wire rst_n,

    input wire setar_palavra,
    input wire [7:0] palavra,

    input wire start,
    input wire bit_in,

    output reg encontrado
);
reg [7:0] pattern_reg;
    reg [7:0] shift_reg;
    // sinal interno que indica "estou recebendo bits"
    reg       recebendo;

    always @(posedge clk) begin
        if (!rst_n) begin
            // reset síncrono: limpa tudo
            pattern_reg <= 8'b0;
            shift_reg   <= 8'b0;
            encontrado  <= 1'b0;
            recebendo   <= 1'b0;
        end
        else begin
            if (setar_palavra) begin
                // carrega nova palavra e zera flags/buffer
                pattern_reg <= palavra;
                shift_reg   <= 8'b0;
                encontrado  <= 1'b0;
                recebendo   <= 1'b0;
            end
            else if (start) begin
                // captura pulso de start: inicia recepção
                recebendo   <= 1'b1;
                shift_reg   <= 8'b0;  // opcional: limpa buffer no início
                encontrado  <= 1'b0;  // garante que recomeça a busca
            end
            else if (recebendo && !encontrado) begin
                // enquanto recebendo e sem ter encontrado:
                // faz o shift serial e compara na hora
                shift_reg <= { shift_reg[6:0], bit_in };
                if ({ shift_reg[6:0], bit_in } == pattern_reg)
                    encontrado <= 1'b1;
            end
            // caso contrário: mantém tudo como está
        end
    end


endmodule

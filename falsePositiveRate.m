function FPR = falsePositiveRate(m, k, n)
    % Calcula a taxa de falsos positivos num Bloom Filter
    % INPUT
    % m -> tamanho do array
    % k -> número de funções hash
    % n -> número de elementos inseridos
    % OUTPUT
    % FPR -> taxa de falsos positivos

    
    % Calcular a probabilidade de um bit ser 1
    p = 1 - exp(-k * n / m);
    
    % Calcular a taxa de falsos positivos
    FPR = (1 - p)^k;
end

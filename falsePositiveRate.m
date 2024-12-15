function [FPRT, FPRE] = falsePositiveRate(m, k, n,FP,TN)
    % Calcula a taxa de falsos positivos num Bloom Filter
    % INPUT
    % m -> tamanho do array
    % k -> número de funções hash
    % n -> número de elementos inseridos
    % OUTPUT
    % FPR -> taxa de falsos positivos

    
    % Calcular a probabilidade de um bit ser 1
    p = 1 - exp(-k * n / m);
    
    % Calcular a taxa de falsos positivos teórica
    FPRT = (1 - p)^k;
    
    % Calcular a taxa de falsos positivos teórica
    FPRE = FP/(FP+TN);
end

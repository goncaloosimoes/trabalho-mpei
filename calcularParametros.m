function [m, k] = calcularParametros(filename, falsePositiveRate)
    % calcularParametros calcula os parâmetros ideais para o bloom filter
    % INPUT
    % filename -> nome do ficheiro de dados
    % falsePositiveRate -> taxa de falsos positivos
    % OUTPUT
    % m -> tamanho ideal do array binário
    % k -> número ideal de funções hash

    % Carregar dados do ficheiro
    data = readtable(filename);
    
    % Número de elementos (linhas da tabela)
    n = height(data);

    % Calcular o tamanho ideal do vetor binário (m)
    m = - (n * log(falsePositiveRate)) / (log(2)^2);
    m = round(m); % Passar de notação científica para int

    % Calcular o número ideal de funções hash (k)
    k = (m / n) * log(2);
    k = ceil(k); % Passar de decimal para o próximo inteiro

    % Exibir os resultados
    fprintf('Número de elementos (n): %d\n', n);
    fprintf('Taxa de falso positivo desejada: %.2f%%\n', falsePositiveRate * 100);
    fprintf('Tamanho ideal do vetor binário (m): %.0f\n', m);
    fprintf('Número ideal de funções hash (k): %.0f\n', k);
end
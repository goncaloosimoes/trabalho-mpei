clear;
clc;

% Parâmetros do Bloom Filter
size = 5000000;      % Tamanho do vetor binário
hashCount = 3;    % Número de funções hash

% Criar o Bloom Filter
bloomFilter = InitializeBF(size);

% Carregar Dados
data = readtable('data_table.csv');

disp('Adicionando transações conhecidas ao Bloom Filter...');
for i = 1:height(data)
    % Garantir que cada coluna é convertida para string antes da concatenação
    % Verificar e converter para string se necessário
    if ischar(data.age{i}) || isstring(data.age{i})
        ageStr = char(data.age{i}); % Se já for string, usamos diretamente
    else
        ageStr = num2str(data.age{i}); % Caso contrário, convertemos para string
    end

    if ischar(data.gender{i}) || isstring(data.gender{i})
        genderStr = char(data.gender{i});
    else
        genderStr = num2str(data.gender{i});
    end
    
    % Criar identificador único usando concatenação de strings
    % Converter o índice "i" para string antes de concatenar
    transactionID = strcat(ageStr, genderStr, num2str(i)); % Usando num2str(i)
    % Remover as aspas do transactionID
    transactionID = strrep(transactionID, '''', '');
    disp(transactionID)

    % Adicionar ao Bloom Filter
    bloomFilter = addBF(bloomFilter, transactionID, hashCount);
end
disp('Adição completa.');

% Verificar se novas transações são conhecidas ou suspeitas
newTransactions = {'transacao_1001', '2M188781', '2F188458', '2M123456', 'transacao_2000','5M30'};

disp('Verificando novas transações:');
for i = 1:length(newTransactions)
    transactionID = newTransactions{i};
    isPresent = checkBF(bloomFilter, transactionID, hashCount);
    
    if isPresent
        fprintf('A transação "%s" PODE ser conhecida (ou falso positivo).\n', transactionID);
    else
        fprintf('A transação "%s" NÃO é conhecida.\n', transactionID);
    end
end

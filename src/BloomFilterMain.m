%% INICIALIZAÇÃO
clear;
clc;

FILENAME = 'data_table.csv';

[SIZE, HASHCOUNT] = calcularParametros('data_table.csv', 0.01);
input('Pressione ENTER para continuar... ')

%% BLOOM FILTER
% Verificar se o Bloom Filter já existe e carregar, se possível
if exist('bloomFilter.mat', 'file') == 2
    % Carregar o filtro Bloom existente
    load('bloomFilter.mat', 'bloomFilter');
    fprintf('Filtro Bloom carregado com sucesso.\n');
    
    % Carregar as transações conhecidas
    if exist('knownTransactions.mat', 'file') == 2
        load('knownTransactions.mat', 'knownTransactions');
        fprintf('Transações conhecidas carregadas com sucesso.\n');
    else
        knownTransactions = {};  % Se não existir, inicializa vazio
    end
    
    data = readtable(FILENAME);
    n = height(data);  % Número de linhas no ficheiro para calcular FPR
else
    % Criar o Bloom Filter
    bloomFilter = InitializeBF(SIZE);

    % Carregar Dados
    data = readtable(FILENAME);
    n = height(data); % número de linhas no ficheiro para calcular FPR

    % Verificar existência dos dados
    requiredFields = {'age', 'gender'};
    if ~all(ismember(requiredFields, data.Properties.VariableNames))
        error('As colunas necessárias estão ausentes no arquivo CSV.');
    end

    % Remover linhas com dados ausentes
    data = rmmissing(data);
    
    % Preparar set para guardar algumas transações conhecidas pelo filtro
    knownTransactions = {};  % Inicializa vazio

    % Salvar IDs das transações num ficheiro para testes futuros
    allTransactionsFile = 'allTransactionIDs.txt';
    fraudTransactionsFile = 'fraudTransactionIDs.txt';

    % Abrir os ficheiros no modo de escrita
    allFileID = fopen(allTransactionsFile, 'w'); % arquivo para todos os IDs
    fraudFileID = fopen(fraudTransactionsFile, 'w'); % arquivo para IDs de transações fraudulentas

    % Adicionar dados ao Bloom Filter
    fprintf("A adicionar transações conhecidas ao Bloom Filter e a guardar os IDs em %s e %s\n", allTransactionsFile, fraudTransactionsFile);

    tic; % Início do cronômetro para medir performance
    
    %% Divisão dos dados em treino (95%) e teste (5%)
    cv = cvpartition(height(data), 'HoldOut', 0.05);  % 5% para teste, 95% para treino

    % Indices dos dados de treino e teste
    trainData = data(training(cv), :);  % Dados de treino (95%)
    testData = data(test(cv), :);  % Dados de teste (5%)

    % Mostrar a quantidade de dados de treino e teste
    fprintf('Dados de treino: %d\n', height(trainData));
    fprintf('Dados de teste: %d\n', height(testData));

    % Adicionar transações de treino ao Bloom Filter
    for i = 1:height(trainData)
        ageStr = toString(trainData.age{i});
        genderStr = toString(trainData.gender{i});

        % Incluir indicador se é fraude ou não
        if trainData.fraud(i) == true
            fraudIndicator = "IF"; % indicador de fraude
        else
            fraudIndicator = "NF"; % não é fraude
        end

        % Construir o ID com base nos dados obtidos
        transactionID = sprintf('%s%s%d%s', ageStr, genderStr, i, fraudIndicator);
        transactionID = erase(transactionID, "'"); % retirar aspas do ID

        % adicionar ID da transação ao filtro
        if trainData.fraud(i) == true
            bloomFilter = addBF(bloomFilter, transactionID, HASHCOUNT);
        end

        % Salvar todos os IDs no arquivo correspondente
        fprintf(allFileID, '%s\n', transactionID); % Salva todos os IDs
        if trainData.fraud(i) == true
            fprintf(fraudFileID, '%s\n', transactionID); % Salva apenas IDs de fraude
        end

        if mod(i,10000) == 0
            % Mensagem de atualização
            fprintf('Adicionadas %d transações ao Bloom Filter...\n', i);
        end

        if mod(i, 100000) == 0
            % Adiciona transações específicas ao conjunto conhecido
            knownTransactions{end+1} = transactionID; %#ok<AGROW>
        end
    end
    toc; % Fim do cronômetro

    fclose(allFileID); % fechar o ficheiro de IDs
    fclose(fraudFileID); % fechar o ficheiro de IDs fraudulentos
    disp('IDs de transações salvos nos arquivos "allTransactionsIDs.txt" e "fraudTransactionIDs.txt"');

    disp('Adição completa.');

    % Salvar o Bloom Filter e as transações conhecidas
    save('bloomFilter.mat', 'bloomFilter');
    save('knownTransactions.mat', 'knownTransactions');
    fprintf('5 Transações conhecidas salvas no arquivo.\n');
end

%% TESTES

disp('Preparando transações para teste...');
% Criar 3 IDs que não foram adicionados ao Bloom Filter
unknownTransactions = {};
for i = 1:3
    randomAge = randi([0, 6]); % Idade aleatória
    % note-se que as idades correspondem a um intervalo
    % isto é: 0 -> menor de 18
    % 1 -> 18 - 26
    % 2 -> 26 - 35 e assim em diante...

    randomGenderNum = randi([0, 1]); % Gênero aleatório (0 ou 1)
    
    randomGender = 'M'; % género default
    if randomGenderNum == 1
        randomGender = 'F';
    end

    randomFraud = randi([0, 1]); % Fraude aleatória (0 ou 1)
    fraudIndicator = "IF";
    if randomFraud == 0
        fraudIndicator = "NF";
    end

    randomIndex = randi([n*10, n*20]); % Índice aleatório fora do intervalo usado
    unknownTransactions{end+1} = sprintf('%d%s%d%s', randomAge, toString(randomGender), randomIndex, fraudIndicator); %#ok<AGROW>
end

% Combinar valores conhecidos e desconhecidos
newTransactions = [knownTransactions, unknownTransactions];

% Verificar se novas transações são conhecidas ou suspeitas
disp('Verificando novas transações:');
disp('Deve indicar 5 conhecidas e no máximo 3 desconhecidas...')

for i = 1:length(newTransactions)
    transactionID = newTransactions{i};
    isPresent = checkBF(bloomFilter, transactionID, HASHCOUNT);

    resultMsg = 'NÃO é conhecida como fraude';
    if isPresent
        resultMsg = 'PODE ser conhecida como fraude (ou falso positivo)';
    end
    fprintf('A transação "%s" %s.\n', transactionID, resultMsg);
end

% Ler IDs salvos em 'transactionIDs.txt' e testar no Bloom Filter
disp('Carregando IDs salvos e testando no Bloom Filter...');
transactionFile = 'allTransactionIDs.txt';

if exist(transactionFile, 'file') == 2
    fileID = fopen(transactionFile, 'r');
    savedIDs = textscan(fileID, '%s'); % Ler todos os IDs
    fclose(fileID);
    
    savedIDs = savedIDs{1}; % Converter para array de células

    % Testar cada ID no Bloom Filter
    for i = 1:length(savedIDs)
        transactionID = savedIDs{i};
        isPresent = checkBF(bloomFilter, transactionID, HASHCOUNT);

        % Verificar presença no filtro
        resultMsg = 'NÃO é conhecida';
        if isPresent
            resultMsg = 'PODE ser conhecida (ou falso positivo)';
        end
        fprintf('A transação "%s" %s.\n', transactionID, resultMsg);
    end
else
    disp('Arquivo de IDs de transações não encontrado!');
end

%%
% User input

% Entrada de ID pelo usuário (com loop até pressionar Enter sem nada)
while true
    userID = input('Insira um ID de transação para verificar (exemplo: 3F200000NF), ou pressione Enter para sair: ', 's');
    
    % Se o usuário pressionar Enter sem digitar nada, sai do loop
    if isempty(userID)
        disp('Saindo...');
        break;
    end

    % Verificar se o ID existe diretamente no Bloom Filter
    isPresent = checkBF(bloomFilter, userID, HASHCOUNT);

    % Se o ID terminar com "IF" e não for encontrado no Bloom Filter, considera como fraude
    if endsWith(userID, 'IF') && ~isPresent
        fprintf('O ID "%s" é considerado fraude (não encontrado no Bloom Filter, mas termina com "IF").\n', userID);
    elseif isPresent
        fprintf('A transação "%s" pode ser conhecida (ou falso positivo).\n', userID);
    else
        % Caso não seja encontrado, verificar a similaridade com IDs conhecidos
        [isFraud, closestMatch] = verificarSemelhancaTransferencias(userID, knownTransactions);
        
        if isFraud
            fprintf('O ID "%s" é semelhante a um ID de fraude (ID mais próximo: %s).\n', userID, closestMatch);
        else
            fprintf('O ID "%s" não corresponde a nenhuma fraude conhecida.\n', userID);
        end
    end
end

%% ESTATÍSTICAS DO FILTRO

% Calcular verdadeiros e falsos positivos/negativos presentes
[TP, FN, FP, TN] = analyzeBloomFilterPerformance(bloomFilter, HASHCOUNT);

% Exibir resultados
fprintf('\nResultados da análise do Bloom filter:\n');
fprintf('True Positives (TP): %d\n', TP);
fprintf('False Negatives (FN): %d\n', FN);
fprintf('False Positives (FP): %d\n', FP);
fprintf('True Negatives (TN): %d\n', TN);

% Calcular taxa de falsos positivos
[FPRT, FPRE] = falsePositiveRate(SIZE, HASHCOUNT, n,FP,TN);
disp("Taxa de falsos positivos téorica no Bloom Filter: " + FPRT);
disp("Taxa de falsos positivos empírica no Bloom Filter: " + FPRE);

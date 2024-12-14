function [TP, FN, FP, TN] = analyzeBloomFilterPerformance(bloomFilter, HASHCOUNT)
    % Arquivos contendo os IDs
    allTransactionsFile = 'allTransactionIDs.txt';
    fraudTransactionsFile = 'fraudTransactionIDs.txt';
    
    % Ler todos os IDs de transações
    if exist(allTransactionsFile, 'file') ~= 2 || exist(fraudTransactionsFile, 'file') ~= 2
        error('Arquivos com IDs de transações não encontrados.');
    end
    
    allFileID = fopen(allTransactionsFile, 'r');
    allIDs = textscan(allFileID, '%s'); % Ler todos os IDs
    fclose(allFileID);
    allIDs = allIDs{1}; % Converter para array de células
    
    fraudFileID = fopen(fraudTransactionsFile, 'r');
    fraudIDs = textscan(fraudFileID, '%s'); % Ler IDs de fraudes
    fclose(fraudFileID);
    fraudIDs = fraudIDs{1}; % Converter para array de células

    % Inicializar contadores
    TP = 0; % True Positives
    FN = 0; % False Negatives
    FP = 0; % False Positives
    TN = 0; % True Negatives

    % Criar um conjunto de IDs fraudulentos para facilitar a verificação
    fraudSet = containers.Map(fraudIDs, num2cell(true(1, length(fraudIDs)))); % Valores correspondem às chaves

    % Verificar cada ID no Bloom Filter
    for i = 1:length(allIDs)
        transactionID = allIDs{i};
        isPresent = checkBF(bloomFilter, transactionID, HASHCOUNT); % Verifica no filtro
        isFraud = isKey(fraudSet, transactionID); % Verifica se é fraude

        % Classificar o resultado
        if isPresent && isFraud
            TP = TP + 1; % True Positive: Está no filtro e é fraude
        elseif ~isPresent && isFraud
            FN = FN + 1; % False Negative: Não está no filtro, mas é fraude
        elseif isPresent && ~isFraud
            FP = FP + 1; % False Positive: Está no filtro, mas não é fraude
            %fprintf("FALSE POSITIVE:::: \n" + transactionID);
        elseif ~isPresent && ~isFraud
            TN = TN + 1; % True Negative: Não está no filtro e não é fraude
        end
    end
end

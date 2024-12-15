% Função para verificar similaridade de prefixo ou sufixo
function [isFraud, closestMatch] = verificarSemelhancaTransferencias(transactionID, knownTransactions)
    isFraud = false;
    closestMatch = '';
    minPrefixLength = 3; % Define o tamanho mínimo do prefixo a ser comparado
    minSuffixLength = 3; % Define o tamanho mínimo do sufixo a ser comparado

    for i = 1:length(knownTransactions)
        knownID = knownTransactions{i};

        % Verifica prefixo e sufixo comuns
        prefixCommon = strncmp(transactionID, knownID, minPrefixLength);
        suffixCommon = strcmp(transactionID(end-minSuffixLength+1:end), knownID(end-minSuffixLength+1:end));
        
        if prefixCommon || suffixCommon
            closestMatch = knownID;
            isFraud = contains(knownID, "IF");  % Se "IF" estiver no ID, é fraude
            return;  % Retorna imediatamente após encontrar um match
        end
    end
end
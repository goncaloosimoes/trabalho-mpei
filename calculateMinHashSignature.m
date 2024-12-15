function signature = calculateMinHashSignature(transaction, numHashes)
    % transaction: vetor representando a transação
    % numHashes: número de funções hash a serem usadas

    numElements = length(transaction);
    signature = inf(numHashes, 1);
    
    for i = 1:numHashes
        for k = 1:numElements
            if transaction(k) ~= 0 % Considerar elementos não nulos
                h = mod((k + i), numElements) + 1; % Função hash baseada em mod
                signature(i) = min(signature(i), h);
            end
        end
    end
end
function signature = calculateMinHashSignature(transaction, numHashes)
    % transaction: vetor representando a transação
    % numHashes: número de funções hash a serem usadas

    numElements = length(transaction);
    primeNumber = 101; % Número primo para dispersão hash
    signature = inf(numHashes, 1);
    
    for i = 1:numHashes
        for k = 1:numElements
            if transaction(k) ~= 0 % Considerar elementos não nulos
                % Nova função hash baseada no valor de cada elemento
                h = mod((k * i + transaction(k)), primeNumber) + 1;
                signature(i) = min(signature(i), h);
            end
        end
    end
end
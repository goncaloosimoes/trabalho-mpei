function signature = calculateMinHashSignature(transaction, numHashes)
    % transaction: vetor representando a transação
    % numHashes: número de funções hash a serem usadas

    numElements = length(transaction);
    primeNumber1 = 101; % Número primo para dispersão hash
    primeNumber2 = 503; % Número primo para dispersão hash
    signature = inf(numHashes, 1);
    
    for i = 1:numHashes
        for k = 1:numElements
            if transaction(k) ~= 0 % Considerar elementos não nulos
                % Nova função hash baseada no valor de cada elemento
                h1 = mod((k * i + transaction(k)), primeNumber1) + 1;
                h2 = mod((k + transaction(k) * i), primeNumber2) + 1;
                signature(i) = min([h1, h2, signature(i)]);
            end
        end
    end
end
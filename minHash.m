function signature = minHash(data, numHashes)
    % data: matriz binária onde cada linha representa um conjunto
    % numHashes: número de funções hash a serem usadas

    [numRows, numCols] = size(data);
    signature = inf(numHashes, numCols);

    for i = 1:numHashes
        perm = randperm(numRows); % Gera uma permutação aleatória das linhas
        for j = 1:numCols
            col = data(:, j);
            for k = 1:numRows
                if col(perm(k)) == 1
                    signature(i, j) = min(signature(i, j), perm(k));
                    break;
                end
            end
        end
    end
end
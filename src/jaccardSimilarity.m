function similarity = jaccardSimilarity(sig1, sig2)
    % Calcula a similaridade de Jaccard entre duas assinaturas de MinHash
    similarity = sum(sig1 == sig2) / length(sig1);
end

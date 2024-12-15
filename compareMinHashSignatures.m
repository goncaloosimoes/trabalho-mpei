function similarity = compareMinHashSignatures(signature1, signature2)
    % signature1: assinatura Min-Hash da primeira transação
    % signature2: assinatura Min-Hash da segunda transação

    similarity = sum(signature1 == signature2) / length(signature1);
end
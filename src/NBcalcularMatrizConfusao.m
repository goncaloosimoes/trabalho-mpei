function confMat = NBcalcularMatrizConfusao(yTest, yPred)
    % Calcular a matriz de confusão
    confMat = zeros(2, 2);  % Inicializa uma matriz 2x2
    
    % Preencher a matriz de confusão
    for i = 1:length(yTest)
        confMat(yTest(i) + 1, yPred(i) + 1) = confMat(yTest(i) + 1, yPred(i) + 1) + 1;
    end
end

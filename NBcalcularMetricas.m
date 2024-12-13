function [accuracy, precision, recall, f1, fpr, fnr] = NBcalcularMetricas(confMat)
    % Extrair valores da matriz de confusão
    tp = confMat(1, 1);  % True Positives
    fp = confMat(1, 2);  % False Positives
    fn = confMat(2, 1);  % False Negatives
    tn = confMat(2, 2);  % True Negatives
    
    % Calcular métricas
    accuracy = (tp + tn) / (tp + tn + fp + fn);
    precision = tp / (tp + fp);
    recall = tp / (tp + fn);
    f1 = 2 * precision * recall / (precision + recall);
    
    % Calcular taxas de erro
    fpr = fp / (fp + tn);  % False Positive Rate
    fnr = fn / (fn + tp);  % False Negative Rate
end

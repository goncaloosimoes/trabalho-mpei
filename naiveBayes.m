clear;
clc;

% 1. Carregar os Dados
data = readtable('data_table.csv');

% 2. Pré-processamento
% Remover colunas irrelevantes (customer, merchant, zipcodeOri, zipMerchant)
data.step = [];
data.customer = [];
data.merchant = [];
data.zipcodeOri = [];
data.zipMerchant = [];

% Converter colunas categóricas para valores numéricos
data.age = grp2idx(categorical(data.age));       % Converte 'age' para número
data.gender = grp2idx(categorical(data.gender)); % Converte 'gender' para número
data.category = grp2idx(categorical(data.category)); % Converte 'category' para número

varfun(@class,data) % tabela das classes de cada coluna

% Separar features (X) e alvo (y)
X = data{:, 1:end-1}; % Todas as colunas menos a última
y = data.fraud;       % Última coluna como alvo (se é fraude ou não)

% Dividir em conjunto de treino e teste
cv = cvpartition(height(data), 'HoldOut', 0.3);
% 70% dos dados servem para treino, 30% para teste

XTrain = X(training(cv), :);
yTrain = y(training(cv), :);
XTest = X(test(cv), :);
yTest = y(test(cv), :);

% 3. Treinar o Modelo Naive Bayes
model = fitcnb(XTrain, yTrain);

% 4. Fazer previsões
yPred = predict(model, XTest);

% 5. Calcular a Matriz de Confusão usando a função personalizada
confMat = NBcalcularMatrizConfusao(yTest, yPred);

% Visualizar Matriz de Confusão
figure;
confusionchart(yTest, yPred);
title('Matriz de Confusão - Naive Bayes');

% Matriz de confusão
disp('Matriz de Confusão:');
disp(confMat);
disp("-----------------------------");

tp = confMat(1, 1);  % True Positives
fp = confMat(1, 2);  % False Positives
fn = confMat(2, 1);  % False Negatives
tn = confMat(2, 2);  % True Negatives

disp("True positives: " + tp);
disp("False positives: " + fp);
disp("False negatives: " + fn);
disp("True negatives: " + tn);


disp("-----------------------------");
% Calcular métricas usando a função personalizada
[accuracy, precision, recall, f1, fpr, fnr] = NBcalcularMetricas(confMat);

% Exibir as métricas
disp("Accuracy: " + accuracy);
disp("Precision: " + precision);
disp("Recall: " + recall);
disp("F1: " + f1);

disp("-----------------------------");
disp("False Positive Rate: " + fpr);
disp("False Negative Rate: " + fnr);

% Análise de balanceamento de classes
summary(data);
figure;
histogram(data.fraud); % Para verificar se os dados estão desbalanceados
title("Comparação entre não fraude e fraude");

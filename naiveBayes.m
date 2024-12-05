clear
clc

% 1. Carregar os Dados
data = readtable('data_table.csv');

% 2. Pré-processamento
% Remover colunas irrelevantes (customer, merchant, zipcodeOri, zipMerchant)
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
XTrain = X(training(cv), :);
yTrain = y(training(cv), :);
XTest = X(test(cv), :);
yTest = y(test(cv), :);

% 3. Treinar o Modelo Naive Bayes
model = fitcnb(XTrain, yTrain);

% 4. Fazer previsões
yPred = predict(model, XTest);

% 5. Avaliar o Modelo
confMat = confusionmat(yTest, yPred);
% Matriz de confusão
disp('Matriz de Confusão:');
disp(confMat);
disp("-----------------------------")

tp = confMat(1,1);
fp = confMat(1,2);
fn = confMat(2,1);
tn = confMat(2,2);

disp("True positives: " + tp)
disp("False positives: " + fp)
disp("True negatives: " + tn)
disp("False negatives: " + fn)
disp("-----------------------------")

accuracy = (tp + tn) / (tp + tn + fp + fn);
precision = tp / (tp + fp);
recall = tp / (tp + fn);
f1 = 2*precision*recall/(precision+recall);

disp("Accuracy: " + accuracy)
disp("Precision: " + precision)
disp("Recall: " + recall)
disp("F1: " + f1)


clear;
clc;

% 1. Carregar os Dados
disp("Bem-vindo ao sistema de análise de fraudes!");
disp("Carregando os dados do arquivo 'data_table.csv'...");
try
    data = readtable('data_table.csv');
    disp("Dados carregados com sucesso!");
catch
    error("Erro ao carregar o arquivo 'data_table.csv'. Verifique se ele existe e está no mesmo diretório.");
end

% 2. Pré-processamento
disp("Pré-processando os dados...");

% Remover colunas irrelevantes (se existirem no conjunto de dados)
disp("Removendo colunas irrelevantes...");
if ismember({'step', 'customer', 'merchant', 'zipcodeOri', 'zipMerchant'}, data.Properties.VariableNames)
    data.step = [];
    data.customer = [];
    data.merchant = [];
    data.zipcodeOri = [];
    data.zipMerchant = [];
end

% Converter colunas categóricas para valores numéricos
disp("Convertendo colunas categóricas para numéricas...");
if ismember('age', data.Properties.VariableNames)
    data.age = grp2idx(categorical(data.age)); 
end
if ismember('gender', data.Properties.VariableNames)
    data.gender = grp2idx(categorical(data.gender)); 
end
if ismember('category', data.Properties.VariableNames)
    data.category = grp2idx(categorical(data.category));
end

disp("Pré-processamento concluído!");

% Visualizar as classes das colunas (opcional para o usuário)
mostrarClasses = input("Deseja visualizar as classes de cada coluna? (S/N): ", 's');
if strcmpi(mostrarClasses, 'S')
    disp("Classes das colunas:");
    varfun(@class, data)
end

% Separar features (X) e alvo (y)
X = data{:, 1:end-1}; % Todas as colunas menos a última
y = data.fraud;       % Última coluna como alvo (se é fraude ou não)

% Dividir em conjunto de treino e teste
disp("Dividindo os dados em conjunto de treino (70%) e teste (30%)...");
cv = cvpartition(height(data), 'HoldOut', 0.3);

XTrain = X(training(cv), :);
yTrain = y(training(cv), :);
XTest = X(test(cv), :);
yTest = y(test(cv), :);

% 3. Treinar o Modelo Naive Bayes
disp("Treinando o modelo Naive Bayes...");
model = fitcnb(XTrain, yTrain);

% 4. Fazer previsões
disp("Fazendo previsões...");
yPred = predict(model, XTest);

% 5. Calcular a Matriz de Confusão usando a função personalizada
disp("Calculando a matriz de confusão...");
confMat = NBcalcularMatrizConfusao(yTest, yPred);

% Visualizar Matriz de Confusão
figure;
confusionchart(yTest, yPred);
title('Matriz de Confusão - Naive Bayes');

% Exibir Matriz de Confusão
disp("Matriz de Confusão:");
disp(confMat);
disp("-----------------------------");

% Exibir valores individuais
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
disp("Métricas de Avaliação do Modelo:");
disp("Accuracy: " + accuracy);
disp("Precision: " + precision);
disp("Recall: " + recall);
disp("F1 Score: " + f1);

disp("-----------------------------");
disp("False Positive Rate: " + fpr);
disp("False Negative Rate: " + fnr);

% Análise de balanceamento de classes
disp("Analisando o balanceamento das classes no conjunto de dados...");
summary(data);
figure;
histogram(data.fraud); % Para verificar se os dados estão desbalanceados
title("Comparação entre não fraude e fraude");
disp("Análise concluída!");

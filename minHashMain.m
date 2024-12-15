clear;
clc;

% Carregar os Dados
data = readtable('data_table.csv');

% Pré-processamento
% Remover colunas irrelevantes (customer, merchant, zipcodeOri, zipMerchant)
data.step = [];
data.customer = [];
data.merchant = [];
data.zipcodeOri = [];
data.zipMerchant = [];

% Normalizar valores contínuos (exemplo: amount)
data.amount = (data.amount - min(data.amount)) / (max(data.amount) - min(data.amount));

% Converter colunas categóricas para valores numéricos
data.age = grp2idx(categorical(data.age));       % Converte 'age' para número
data.gender = grp2idx(categorical(data.gender)); % Converte 'gender' para número
data.category = grp2idx(categorical(data.category)); % Converte 'category' para número

% Selecionar duas transações para comparar
transaction1 = data(1, :); % Primeira transação
transaction2 = data(300, :); % Segunda transação

% Converter transações para vetores categóricos e contínuos
categoricalData1 = [transaction1.age, transaction1.gender, transaction1.category, transaction1.fraud];
categoricalData2 = [transaction2.age, transaction2.gender, transaction2.category, transaction2.fraud];

numHashes = 100; % Número de funções hash

% Calcular assinaturas Min-Hash para as partes categóricas das transações
signature1 = calculateMinHashSignature(categoricalData1, numHashes);
signature2 = calculateMinHashSignature(categoricalData2, numHashes);

% Comparar assinaturas Min-Hash
minHashSimilarity = compareMinHashSignatures(signature1, signature2);

% Calcular a similaridade de Jaccard diretamente para a parte categórica
intersection = sum(categoricalData1 == categoricalData2);
union = length(categoricalData1);
jaccardSimilarity = intersection / union;

disp('Similaridade entre as duas transações (Min-Hash):');
disp(minHashSimilarity);

disp('Similaridade entre as duas transações (Jaccard):');
disp(jaccardSimilarity);

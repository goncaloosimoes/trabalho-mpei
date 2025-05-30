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

% Solicitar ao utilizador os índices das transações para comparar
index1 = input('Por favor, insira o índice da primeira transação: ');
index2 = input('Por favor, insira o índice da segunda transação: ');

% Selecionar duas transações para comparar
transaction1 = data(index1, :); % Primeira transação
transaction2 = data(index2, :); % Segunda transação

% Converter transações para vetores categóricos e contínuos
categoricalData1 = [transaction1.age, transaction1.gender, transaction1.category, transaction1.fraud];
categoricalData2 = [transaction2.age, transaction2.gender, transaction2.category, transaction2.fraud];

% Remover duplicatas para criar conjuntos representativos
categoricalData1 = unique(categoricalData1); % Transforma em conjunto
categoricalData2 = unique(categoricalData2); % Transforma em conjunto

numHashes = 500; % Número de funções hash aumentado para melhorar a precisão

% Calcular assinaturas Min-Hash para as partes categóricas das transações
signature1 = calculateMinHashSignature(categoricalData1, numHashes);
signature2 = calculateMinHashSignature(categoricalData2, numHashes);

% Comparar assinaturas Min-Hash
minHashSimilarity = compareMinHashSignatures(signature1, signature2);

% Calcular a similaridade de Jaccard diretamente para a parte categórica
intersection = length(intersect(categoricalData1, categoricalData2)); % Tamanho da interseção
union = length(union(categoricalData1, categoricalData2));             % Tamanho da união
jaccardSimilarity = intersection / union;

disp('Similaridade entre as duas transações (Min-Hash):');
disp(minHashSimilarity);

disp('Similaridade entre as duas transações (Jaccard):');
disp(jaccardSimilarity);

threshold = 0.15;

if (jaccardSimilarity < threshold && minHashSimilarity < threshold)
    if (transaction1(end) == 1) % se a primeira for fraude, como a distancia é baixa 
        % dizemos que a segunda pode ser fraudulenta também
        fprintf("As transações são de natureza possivelmente fraudulenta.");
    else 
        fprintf("As transações aparentam ser normais.");
    end
else 
    fprintf("As transações não são semelhantes");
end
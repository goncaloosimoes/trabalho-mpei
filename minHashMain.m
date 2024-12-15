% Carregar os Dados
data = readtable('data_table.csv');

% Pré-processamento
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

% Converter os dados em uma matriz binária
binaryData = data{:,:} > 0;

% Selecionar duas transações para comparar
transaction1 = binaryData(1, :); % Primeira transação
transaction2 = binaryData(3912, :); % Segunda transação

numHashes = 100; % Número de funções hash
% Calcular assinaturas Min-Hash para as duas transações
signature1 = minHash(transaction1, numHashes);
signature2 = minHash(transaction2, numHashes);

% Comparar assinaturas Min-Hash
similarity = compareMinHashSignatures(signature1, signature2);

disp('Similaridade entre as duas transações:');
disp(similarity);
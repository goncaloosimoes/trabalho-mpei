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

numHashes = 100; % Número de funções hash
signature = minHash(binaryData, numHashes);

disp('Min-Hash Signature:');
disp(signature);
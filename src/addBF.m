function BF = addBF(BF,key,k)
% adiciona um elemento ao filtro de bloom
    n = length(BF);
    for i=1:k
        modified_key = [key num2str(i)];
        h = string2hash(modified_key);
        h = mod(h,n)+1;
        BF(h) = true;
    end
end
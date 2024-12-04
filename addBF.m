function BF = addBF(BF,key,k)
% adds a new key to the bloom filter
    n = length(BF);
    for i=1:k
        modified_key = [key num2str(i)];
        h = string2hash(modified_key);
        h = mod(h,n)+1;
        BF(h) = true;
    end
end
function check = checkBF(BF,key,k)
% verifica se uma chave está dentro do filtro ou não
    n = length(BF);
    check=true;
    for i=1:k
        modified_key = [key num2str(i)];
        h = string2hash(modified_key);
        h = mod(h,n)+1;
        if ~BF(h)
            check = false;
            break;
        end
    end
end

function str = toString(value)
    if ischar(value) || isstring(value)
        str = char(value); % Converter para string se necessário
    else
        str = num2str(value); % Converter número para string
    end
end
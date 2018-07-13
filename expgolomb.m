function [ len_w, string_w ] = expgolomb(X)
%EXPGOLOMB is the function to calculate the
%Exp-Golomb code for a integer
%NUM   The number to be calculated
%LEN   The length of the resulting binary code sequence
%STRING   The resulting binary code sequence for integer NUM
testing  = 1; % length(X(:))
string_w  = '';
for index = 1: testing
    num = X(index);
    if num == 0
        len = 1;
        string = '1';
    elseif num >0
        string = dec2bin(2*num);
        len_tmp = length(string);
        temp = num2str(10^(len_tmp-1));
        string = strcat(temp(2:len_tmp),string);
        len = 2*len_tmp-1;
    else
        string = dec2bin(-2*num+1);
        len_tmp = length(string);
        temp = num2str(10^(len_tmp-1));
        string = strcat(temp(2:len_tmp),string);
        len = 2*len_tmp-1;
    end
    string_w = strcat(string_w, string);
end
len_w = length(string_w);
end


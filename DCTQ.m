function [X] = DCTQ(x,MF,Qbits,f)
x = double(x);
h_blocks = size(x,2)/4;
v_blocks = size(x,1)/4;
X = x*0;
for i = 1:v_blocks
    for j = 1:h_blocks
        block = x((i-1)*4 +1 :i*4,(j-1)*4 +1:j*4);
        X((i-1)*4 +1 :i*4,(j-1)*4 +1:j*4) = DCTQ4by4(block,MF,Qbits,f);
    end
end
end

function [Z] = DCTQ4by4(X,MF,Qbits,f)
method = 12; % 1 original DCT %else fast DCT
if method ==1
Cf = [1,1,1,1;
      2,1,-1,-2;
      1,-1,-1,1;
      1,-2,2,-1];
%% forward transform
W = Cf*X*Cf';
else
    node1 = X(1,:)+X(4,:);
    node2 = X(2,:)+X(3,:);
    node3 = X(2,:)-X(3,:);
    node4 = X(1,:)-X(4,:);
    temp1 = node1 + node2;
    temp2 = 2*node4+node3;
    temp3 = node1 - node2;
    temp4 = node4 - 2*node3;
    temp = [temp1;temp2;temp3;temp4];
    node1 = temp(:,1)+temp(:,4);
    node2 = temp(:,2)+temp(:,3);
    node3 = temp(:,2)-temp(:,3);
    node4 = temp(:,1)-temp(:,4);
    coeff1 = node1 + node2;
    coeff2 = 2*node4+node3;
    coeff3 = node1 - node2;
    coeff4 = node4 - 2*node3;
    W  = [coeff1';coeff2';coeff3';coeff4']';
end
%% Post Scaling and quantization
Z = W.* MF + f;
if method == 1
    %% method 1 division
    Z = Z/(2^Qbits);
    Z = round(Z);
else
    %% method 2 shift (the lost accuracy are compensated by f)
    coef = ones(4,4);
    for i  = 1:16
        if(Z(i)<0)
            coef(i) = -1;
        end
    end
    Z = bitshift(abs(Z),-Qbits).*coef;
    Z = round(Z);
end
end
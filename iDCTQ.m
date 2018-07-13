function [X] = iDCTQ(x,PF,Qstep)
x = double(x); 
h_blocks = size(x,2)/4;
v_blocks = size(x,1)/4;
X = x*0;
for i = 1:v_blocks
    for j = 1:h_blocks
        block = x((i-1)*4 +1 :i*4,(j-1)*4 +1:j*4);
        X((i-1)*4 +1 :i*4,(j-1)*4 +1:j*4) = iDCTQ4by4(block,PF,Qstep);
    end
end
end

function [X_] = iDCTQ4by4(Z,PF,Qstep)
% method  = 1 general; others fast
method  = 12;
Ci = [1,1,1,1;
      1,0.5,-0.5,-1;
      1,-1,-1,1;
      0.5,-1,1,-0.5];
Ef  = PF.* [1,2,1,2;
            2,4,2,4;
            1,2,1,2;
            2,4,2,4];
%% Decodingscaling
W_ = Z * Qstep .* Ef ;
%% inverse Transform
if method ==1
X_ = round(Ci'*W_*Ci);
else
    node1 = W_(1,:)+W_(3,:);
    node2 = W_(1,:)-W_(3,:);
    node3 = 0.5*W_(2,:)-W_(4,:);
    node4 = W_(2,:)+0.5*W_(4,:);
    temp1 = node1 + node4;
    temp2 = node2 + node3;
    temp3 = node2 - node3;
    temp4 = node1 - node4;
    temp = [temp1;temp2;temp3;temp4];
    node1 = temp(:,1)+temp(:,3);
    node2 = temp(:,1)-temp(:,3);
    node3 = 0.5*temp(:,2)-temp(:,4);
    node4 = temp(:,2)+0.5*temp(:,4);
    coeff1 = node1 + node4;
    coeff2 = node2 + node3;
    coeff3 = node2 - node3;
    coeff4 = node1 - node4;
    X_  = [coeff1';coeff2';coeff3';coeff4']';
    X_ = round(X_);
end
end
function [MF,Qbits,PF,Qstep,f1,fn] = paras(QP)
%% Qstep (1,52)
Qstep = ones(1,54);
Qstep(1:6) = [0.625,0.6875,0.8125,0.875,1,1.125];
for i = 7:6:49
    Qstep(i:i+5) = Qstep(i-6:i-1)*2;
end
Qstep = Qstep(1:52);
%% Qbits (1,52)
Qbits = ones(1,52);
for i = 1:52
    Qbits(i) = 15 + floor((i-1)/6);
end
%% PF (4,4)
% a = 0.5;b = (2/5)^0.5;
aa = 0.5^2; ab = (2/5)^0.5/4; bb =1/10;
PF = [aa,ab,aa,ab;
      ab,bb,ab,bb;
      aa,ab,aa,ab;
      ab,bb,ab,bb];
%% MF (4,4,52)
MF = ones(4,4,52);
for i = 1:52
    MF(:,:,i) = PF.* (2^Qbits(i) / Qstep(i));
end
MF = round(MF(:,:,QP+1));
Qbits = Qbits(QP+1);
Qstep = Qstep(QP+1);
f1 = round(2^Qbits/6);
fn = round(2^Qbits/3);
end

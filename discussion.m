clear;
clc
%% discussion 1 - search range
% j = 1;
% timer = zeros(3,10);
% PSNR_ME = zeros(3,10);
% PSNR_frame = zeros(3,10);
% 
% for i = [4,8,16,32]
%     [timer(j,:),len_code,PSNR_ME(j,:),PSNR_frame(j,:)] = encoder(22,24,i);
%     j = j + 1;
% end
% 
% f = 1: 10;
% PSNR_ME(1) = inf;
% figure(1);plot(f,PSNR_ME(1,:));
% title('PSNR of Motion Prediction'),xlabel('frames'),ylabel('PSNR');
% 
% figure(2);plot(f,PSNR_frame(1,:));hold on;plot(f,PSNR_frame(2,:));hold on;plot(f,PSNR_frame(3,:));
% title('PSNR of decoded frames');xlabel('frames');ylabel('PSNR');legend('8by8','16by16','32by32');
% 
% figure(3);plot(f,timer(1,:));hold on;plot(f,timer(2,:));hold on;plot(f,timer(3,:));
% title('time expense on motion prediction'),xlabel('frames'),ylabel('time(s)');legend('8by8','16by16','32by32');

%% discussion2 QP
j = 1;
f = 1: 10;
PSNR_frame = zeros(6,10);

for i = [18,22,24,26,30,36]
    [timer,len_code,PSNR_ME,PSNR_frame(j,:)] = encoder(22,i,8);
    j = j + 1;
end

figure(1);title('PSNR of encoded frames'),xlabel('frames'),ylabel('PSNR');
for j = 1:6
    plot(f,PSNR_frame(j,:));hold on;
end
title('PSNR of decoded frames');xlabel('frames');ylabel('PSNR');legend('QP = 18','QP = 22','QP = 24','QP = 26','QP = 30','QP = 36');

temp = (PSNR_frame(:,2:end))';
PSNR_aveg = sum(temp)/9;
figure(2),plot([18,22,24,26,30,36],PSNR_aveg);
title('average PSNR of inter decoded frames');xlabel('QP');ylabel('PSNR');
     
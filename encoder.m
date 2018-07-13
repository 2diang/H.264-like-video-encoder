function [timer,len_code,PSNR_ME,PSNR_frame] = encoder(QP1,QPn,window_size)
%% load the video as series frames 
[frame_orig,framenums] = YUVread('foreman_420.yuv');
frame_orig = double(frame_orig);
%% set and init parameters 
% quantization
% QP1 = 22; % QP for the first frame
% QPn = 24; % QP for the rest of frame
% motion prediction 
block_size = 4; 
% window_size = 8; % search window size % to be modify
frame_pred = double(frame_orig) * 0; % predict frame via (n-1)th frame
frame_resd = double(frame_orig) * 0; % residual frames (to be DCT and Quantization)
frame_dctq = double(frame_orig) * 0; % frames after DCT and Q
frame_recns = double(frame_orig) * 0;% reconstruct frames (to be as the reference frame)
% ZigZag and entropy coding
ZigResult = cell(1,framenums);
codResult = cell(2,framenums); % length and bitstream of each frame
% performance
PSNR_ME = zeros(1,framenums); % PSNR of pediction
PSNR_frame = ones(1,framenums);  % PSNR of orignal and reconstructed frames
timer = ones(1,framenums); % time consuption of encoder
%% system
for f = 1:framenums  % f denotes current frame
     
     if(f == 1) % the first frame only DCT +Q
         [MF,Qbits,PF,Qstep,f1,fn] = paras(QP1); % parameters for the coming DCT and quantization by QP1
         % DCT + Q
         frame_dctq(:,:,1) = DCTQ(frame_orig(:,:,1),MF,Qbits,f1);
         % coding + output
         ZigResult{1} = ZigZag(frame_dctq(:,:,1));
         [len_w, string_w] = expgolomb(ZigResult{1});
         codResult{1,1} = len_w;
         codResult{2,1} = string_w;
         % reconstruct frame
         frame_recns(:,:,1) = iDCTQ(frame_dctq(:,:,1),PF,Qstep);

     else % the rest of frames DCT + Q + motion prediction
         [MF,Qbits,PF,Qstep,f1,fn] = paras(QPn); % parameters for the coming DCT and quantization by QPn
         % motion estimation + compensation
         start  = tic;% ----------------------------------------------------------------
         [ predict, residual, PSNR_value, mv ] = FSBMAI(frame_recns(:,:,f-1), frame_orig(:,:,f), block_size, window_size);
         timer(f) = toc(start);% -------------------------------------------------------
         frame_pred(:,:,f) = predict;
         frame_resd(:,:,f) = residual;
         PSNR_ME(f) = PSNR_value;
         % DCT + Q
         frame_dctq(:,:,f) = DCTQ(frame_resd(:,:,f),MF,Qbits,fn);
         % coding + output
         ZigResult{f} = ZigZag(frame_dctq(:,:,f));
         [ len_w, string_w ] = expgolomb(ZigResult{f});
         codResult{1,f} = len_w;
         codResult{2,f} = string_w;
         % reconstruct frame
         frame_recns(:,:,f) = iDCTQ(frame_dctq(:,:,f),PF,Qstep) + frame_pred(:,:,f);   
     end
    
     PSNR_frame(f) = PSNR(frame_orig(:,:,f),frame_recns(:,:,f));
end
len_code = ones(1,framenums);
for i = 1:framenums
    len_code(i) = codResult{1,i};
end
%% plots
% f = 1: framenums;
% figure(1),plot(f,PSNR_ME),title('PSNR of Motion Prediction'),xlabel('frames'),ylabel('PSNR');
% figure(2),plot(f,PSNR_frame),title('PSNR of decoded frames'),xlabel('frames'),ylabel('PSNR');
% figure(3),plot(f,timer),title('time complexity'),xlabel('frames'),ylabel('time(s)');
% figure(4),plot(f,len_code),title('length of bitstream(bits)'),xlabel('frames'),ylabel('length');
% results = [timer',len_code',PSNR_ME',PSNR_frame'];


% To evaluate your source code, explicitly show the intra coding results of the first 4x4
% block (frame 0), i.e, quantized/dequantized transform coefficients at QP=17-22;
clear;
clc;
%% load the video as series frames 
[frame_orig,framenums] = YUVread('foreman_420.yuv');
%% get the first block of the first frame
block = frame_orig(1:4,1:4,1);
%% get parmeters 
QP = 22;
tic
[MF,Qbits,PF,Qstep,f1,fn] = paras(QP);
toc
%% det + q(quantized transform coeffients)
Z = DCTQ(block,MF,Qbits,f1);
%% idct +iq(dequantized transform coeffients)
block_ = iDCTQ(Z,PF,Qstep);
PSNR_block = PSNR(block,block_)
open Z
open block_
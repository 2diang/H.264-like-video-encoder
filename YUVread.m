function [vid,frames] = YUVread(filename)
row = 352;
col = 288;
%% open file
vid_handle = fopen(filename,'r'); 
vid = fread(vid_handle);
frames = length(vid(:)) / (row * col *1.5); %% get the total number of frames
fseek(vid_handle, 0 , -1);  %% move the poniter to the start
%% extract frames in YUV 
frame_Y = zeros(row, col, frames);
frame_U = zeros(row/2, col/2, frames);
frame_V = zeros(row/2, col/2, frames);
for i = 1:frames %% read YUV data
    frame_Y(:,:,i) = fread(vid_handle,[row,col],'uint8');
    frame_U(:,:,i) = fread(vid_handle,[row/2,col/2],'uint8');
    frame_V(:,:,i) = fread(vid_handle,[row/2,col/2],'uint8');
end
vid = uint8(frame_Y); %% only extract the Y frame
end
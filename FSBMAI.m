function [ predict, residual, PSNR, mv ] = FSBMAI( reference, original, block_size, window_size )
%FSBMAI is the function of full-search block matching algorithm with integer accuracy
%REFERENCE   The reference frame
%ORIGINAL   The original frame
%BLOCK_SIZE   The block size for the motion estimation
%WINDOW_SIZE   The size of the search window to find the best match
%PREDICT  The resulting motion compensated frame
%RESIDUAL   The distortion between the original frame and the predicted
%                   frame
%PSNR   The PSNR between the predicted frame and the original frame
%MV   The motion vector after motion estimation

width = size(reference, 2);
height = size(reference, 1);
h_block = width/block_size;
v_block = height/block_size;
mv = zeros(h_block, v_block, 2);
ref_int = padarray(reference, [window_size/2 window_size/2], 'replicate', 'both');

for i = 1 : block_size : width
    for j = 1 : block_size : height
        stop1 = j+block_size-1;
        stop2 = i+block_size-1;
        move1 = ceil(i/block_size);
        move2 = ceil(j/block_size);
        ori_block = original(j : stop1, i : stop2);
        measure = inf;
        for k = 0 : window_size
            for l = 0 : window_size-1
                measure_temp = norm(ori_block-ref_int((j+l):(stop1+l), (i+k):(stop2+k)),'fro')^2;
                if measure_temp < measure
                    measure = measure_temp;
                    pre_block = ref_int((j+l):(stop1+l), (i+k):(stop2+k));
                    mv(move1,move2,1) = k-window_size/2;
                    mv(move1,move2,2) = l-window_size/2;
                end
            end
        end
        predict(j : stop1, i : stop2, 1) = pre_block;
    end
end
residual = original-predict(:, :, 1);
PSNR = 10*log10(255^2/sum(sum(residual.^2))*width*height);
end
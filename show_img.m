frame_orig = uint8(frame_orig);
frame_recns = uint8(frame_recns);
figure(1);imshow(frame_orig(:,:,10));title('original frame10 ');
figure(2);imshow(frame_recns(:,:,10));title('decoded frame10 ');
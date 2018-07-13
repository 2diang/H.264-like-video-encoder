function [zz] = ZigZag(frame)
h_blocks = size(frame,2)/4;
v_blocks = size(frame,1)/4;
zz = zeros(16,h_blocks * v_blocks);
counter = 0;
for i = 1:v_blocks
    for j = 1:h_blocks
        counter = counter +1;
        x = frame((i-1)*4 +1 :i*4,(j-1)*4 +1:j*4);
        zz(:,counter) = [x(1),x(5),x(2),x(3),x(6),x(9),x(13),x(10),x(7),x(4),x(8),x(11),x(14),x(15),x(12),x(16)]';
    end
end
end
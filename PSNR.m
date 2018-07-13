function [PSNRr] = PSNR(A,B)
    % A -> original; B-> new
    A = double(A);
    B = double(B);
    [M,N]  = size(A);
    MSE =sum(sum((A-B).^2))/ (M * N);
    PSNRr = 10 * log10((max(A(:).^2) / MSE));
end
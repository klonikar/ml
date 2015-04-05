function result = rotate90(X)
%PREDICT Rotate the image in each X input row by 90 degrees

imgLen = columns(X);
imgWidth = sqrt(imgLen);
for i=1:rows(X)
    x = reshape(X(i,:),imgWidth,imgWidth)';
    X(i,:) = x(:);
end
result = X;


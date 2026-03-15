function [p, s] = Identify(file)
% 对给定的图像文件进行识别.数字为白底黑字.
% 返回识别结果p及其得分s.
% 袁沅祥，2019-7
file = "3.png";
m = double(rgb2gray(imread(file)));
m = imresize(255-m, [28, 28], 'bicubic');
v = max(max(m));

if v == 0
    p = -1; s = 0;
else
    DNN = LoadNN();
    q = length(DNN)-2;
    fprintf('The value of q is: %f\n', q);
    if q > 0
        m = m / v;
        X = reshape(m, 28*28, 1);
        for i = 1:q
            X = reLU(DNN{i} * [1; X]);
        end
        [s, p] = max(X);
        fprintf('The value of s is: %f\n', s);
        fprintf('The value of p is: %f\n', p);
        p = p - 1;
        imshow(m);
        xlabel(num2str(p));
        ylabel(num2str(s));
    else
        p = -1; s = 0;
    end
end

end

% 读取图像
img = imread('2022212364.png');
gray_img = rgb2gray(img);

% 二值化
bw_img = imbinarize(gray_img);

% 反色
bw_img = ~bw_img;i

% 显示原始图像和二值化后的图像
subplot(1, 2, 1);
imshow(img);
title('原始图像');
subplot(1, 2, 2);
imshow(bw_img);
title('二值化图像');

% 提取连通组件（数字）
cc = bwconncomp(bw_img);
num_labels = cc.NumObjects;

% 获取每个连通组件的边界框
bounding_boxes = regionprops(cc, 'BoundingBox');

% 分割数字并识别
figure; % 创建新的图形窗口用于显示分割后的数字和识别结果
for i = 1:num_labels
    box = bounding_boxes(i).BoundingBox;
    x = box(1);
    y = box(2);
    width = box(3);
    height = box(4);

    % 为了确保不截断数字，我们可以在边界框的每个维度上添加一些额外的像素
    % 这里我们添加10个像素作为额外的空间
    padding = 10;
    x = max(x - padding, 1); % 确保x不会小于1
    y = max(y - padding, 1); % 确保y不会小于1
    width = width + 2 * padding;
    height = height + 2 * padding;

    % 确保新的边界框不会超出图像的范围
    x = min(x, size(bw_img, 2) - width);
    y = min(y, size(bw_img, 1) - height);

    % 分割数字
    digit_img = imcrop(bw_img, [x, y, width, height]);
    digit_img = imresize(digit_img, [28, 28]);

    % 显示分割后的数字
    subplot(3, 5, i);
    imshow(digit_img);
    title(['数字 ' num2str(i)]);

    % 调用识别函数
    [p, s] = RecognizeDigit(digit_img, i);
    % 显示识别结果
    title([num2str(p) ' (' num2str(s) ')']);
end

function [p, s] = RecognizeDigit(digit, index)
    % 将二值图像转换为双精度类型
    m = im2double(digit);
    % 找到图像中的最大值
    v = max(max(m));
    
    % 输出v的数值
    fprintf('The value of v for image %d is: %f\n', index, v);
    
    if v == 0
        p = -1; s = 0;
    else
        DNN = LoadNN();
        q = length(DNN)-2;
        fprintf('The value of q for image %d is: %f\n', index, q);
        if q > 0
            m = m / v;
            X = reshape(m, 28*28, 1);
            for j = 1:q
                X = reLU(DNN{j} * [1; X]);
            end
            [s, p] = max(X);
            fprintf('The value of s for image %d is: %f\n', index, s);
            fprintf('The value of p for image %d is: %f\n', index, p);
            p = p - 1;
        else
            p = -1; s = 0;
        end
    end
end
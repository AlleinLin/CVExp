% 读取图像（这里假设图像是彩色的，你可以根据实际情况调整为灰度图等）
input_image = imread('images/DSC000114.jpg');

% 将图像转换为双精度类型，方便后续计算（范围是0到1）
input_image = im2double(input_image);

% 获取图像的高度、宽度和通道数
[height, width, channels] = size(input_image);

% 1. 使用Sobel算子进行滤波（这里分别对水平和垂直方向进行滤波，然后求梯度幅值）
% Sobel算子水平方向
sobel_x = [1 0 -1; 2 0 -2; 1 0 -1];
% Sobel算子垂直方向
sobel_y = [1 2 1; 0 0 0; -1 -2 -1];

% 初始化滤波后的图像（用于Sobel滤波结果）
filtered_image_sobel = zeros(height, width, channels);

% 对每个通道分别进行Sobel滤波（不使用内置函数包的情况下手动循环实现卷积操作）
for c = 1:channels
    for i = 2:height - 1
        for j = 2:width - 1
            % 水平方向卷积
            gx = 0;
            for m = -1:1
                for n = -1:1
                    gx = gx + sobel_x(m + 2, n + 2) * input_image(i + m, j + n, c);
                end
            end
            % 垂直方向卷积
            gy = 0;
            for m = -1:1
                for n = -1:1
                    gy = gy + sobel_y(m + 2, n + 2) * input_image(i + m, j + n, c);
                end
            end
            % 计算梯度幅值（使用简单的近似，实际中可能需更复杂处理保证精度）
            filtered_image_sobel(i, j, c) = sqrt(gx^2 + gy^2);
        end
    end
end

% 将滤波后的图像像素值范围调整到0-1（方便显示）
filtered_image_sobel = (filtered_image_sobel - min(filtered_image_sobel(:))) / (max(filtered_image_sobel(:)) - min(filtered_image_sobel(:)));

% 显示经过Sobel算子滤波的图像（以彩色图显示为例，如果是灰度图可调整显示方式）
figure;
imshow(filtered_image_sobel);
title('Filtered Image by Sobel Operator');

% 2. 使用给定卷积核进行滤波
custom_kernel = [1 0 -1; 2 0 -2; 1 0 -1];
% 初始化滤波后的图像（用于给定卷积核滤波结果）
filtered_image_custom = zeros(height, width, channels);

% 同样对每个通道进行滤波操作（手动循环卷积）
for c = 1:channels
    for i = 2:height - 1
        for j = 2:width - 1
            sum_value = 0;
            for m = -1:1
                for n = -1:1
                    sum_value = sum_value + custom_kernel(m + 2, n + 2) * input_image(i + m, j + n, c);
                end
            end
            filtered_image_custom(i, j, c) = sum_value;
        end
    end
end

% 将滤波后的图像像素值范围调整到0-1（方便显示）
filtered_image_custom = (filtered_image_custom - min(filtered_image_custom(:))) / (max(filtered_image_custom(:)) - min(filtered_image_custom(:)));

% 显示经过给定卷积核滤波的图像（以彩色图显示为例，如果是灰度图可调整显示方式）
figure;
imshow(filtered_image_custom);
title('Filtered Image by Given Custom Kernel');

% 3. 可视化图像的颜色直方图（这里以RGB三个通道分别展示为例，手动统计每个通道的像素值分布）
% 确定直方图的bin数量（这里简单设置为256，可根据需求调整）
num_bins = 256;
histogram_r = zeros(1, num_bins);
histogram_g = zeros(1, num_bins);
histogram_b = zeros(1, num_bins);

% 统计每个通道的像素值出现次数（手动循环遍历图像像素）
for i = 1:height
    for j = 1:width
        % 红色通道
        index_r = round(input_image(i, j, 1) * (num_bins - 1)) + 1;
        histogram_r(index_r) = histogram_r(index_r) + 1;
        % 绿色通道
        index_g = round(input_image(i, j, 2) * (num_bins - 1)) + 1;
        histogram_g(index_g) = histogram_g(index_g) + 1;
        % 蓝色通道
        index_b = round(input_image(i, j, 3) * (num_bins - 1)) + 1;
        histogram_b(index_b) = histogram_b(index_b) + 1;
    end
end

% 绘制直方图（可以使用bar函数简单绘制，这里设置一些基本的绘图属性）
figure;
subplot(3, 1, 1);
bar(0:(num_bins - 1), histogram_r);
title('Red Channel Histogram');
xlabel('Pixel Value');
ylabel('Frequency');

subplot(3, 1, 2);
bar(0:(num_bins - 1), histogram_g);
title('Green Channel Histogram');
xlabel('Pixel Value');
ylabel('Frequency');

subplot(3, 1, 3);
bar(0:(num_bins - 1), histogram_b);
title('Blue Channel Histogram');
xlabel('Pixel Value');
ylabel('Frequency');

% 4. 提取图像的纹理特征（这里简单以计算图像的灰度共生矩阵来提取部分纹理特征为例，不使用内置函数包手动计算）
% 先将图像转为灰度图（简单平均RGB通道值得到灰度值，也可以采用更标准的转换方式）
gray_image = (input_image(:, :, 1) + input_image(:, :, 2) + input_image(:, :, 3)) / 3;

% 定义灰度共生矩阵的参数（这里距离为1，角度为0度，可根据需求扩展更多角度和距离情况）
distance = 1;
angle = 0; % 0度表示水平方向
% 初始化灰度共生矩阵（灰度级别这里简单按256级考虑，可根据实际情况调整）
gray_levels = 256;
glcm = zeros(gray_levels, gray_levels);

% 计算灰度共生矩阵（手动遍历图像像素对）
for i = 1:height - distance
    for j = 1:width - 1
        row = round(gray_image(i, j) * (gray_levels - 1)) + 1;
        col = round(gray_image(i + distance, j) * (gray_levels - 1)) + 1;
        glcm(row, col) = glcm(row, col) + 1;
    end
end
pyenv('Version',"C:\Users\chysd\AppData\Local\Programs\Python\Python310\python.exe")
% 可以基于灰度共生矩阵进一步计算一些纹理特征，这里简单保存灰度共生矩阵作为纹理特征示例
% 将纹理特征保存为npy格式（这里需借助MATLAB的Python接口，确保已安装Python以及相关的numpy库，且配置好MATLAB与Python的交互环境）
py.importlib.import_module('numpy').save('texture_features.npy', glcm);
data = py.numpy.load('texture_features.npy');
disp(data);
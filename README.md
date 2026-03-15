# 计算机视觉项目集合

本项目包含两个主要的计算机视觉实验项目，使用 MATLAB 实现。

## 项目结构

```
cv/
├── MATLAB-DNN-master/       # 深度神经网络项目
│   ├── data/                # MNIST 训练数据
│   ├── test/                # MNIST 测试数据
│   ├── TrainDNN.m           # DNN 训练主函数
│   ├── TrainRecovery.m      # 训练恢复函数
│   ├── Identify.m           # 数字识别函数
│   ├── test.m               # 测试脚本
│   ├── LoadNN.m             # 加载神经网络
│   ├── reLU.m               # 激活函数
│   ├── Grad.m               # 梯度计算
│   ├── Accuracy.m           # 准确率计算
│   ├── loadMNIST.m          # 加载 MNIST 数据
│   └── trainMNIST.m         # MNIST 训练脚本
│
├── image-processing/        # 图像处理实验
│   ├── exp1.m               # 图像滤波与特征提取实验
│   ├── exp2.m               # 边缘检测与 Hough 变换实验
│   └── images/              # 实验图像资源
│
└── README.md
```

## 项目一：深度神经网络 (MATLAB-DNN-master)

### 简介

使用 MATLAB 实现的可自定义层数的深度神经网络 (DNN)，针对 MNIST 手写数字数据集进行训练和验证。

### 功能特点

- 支持自定义隐藏层数量和神经元数量
- 使用 Sigmoid 激活函数
- 支持训练中断恢复
- 图形化展示 Loss 和 Accuracy 随迭代次数的变化曲线
- 支持自定义图片的数字识别

### 主要文件说明

| 文件 | 说明 |
|------|------|
| `TrainDNN.m` | DNN 训练主函数，支持自定义网络结构 |
| `TrainRecovery.m` | 训练恢复函数，支持从断点继续训练 |
| `Identify.m` | 对输入的白底黑字图片进行数字识别 |
| `test.m` | 测试脚本，包含数字分割和识别功能 |
| `reLU.m` | 激活函数实现（当前配置为 Sigmoid） |
| `Grad.m` | 梯度计算函数 |
| `Accuracy.m` | 计算网络在测试集上的准确率 |
| `LoadNN.m` | 加载已训练的神经网络参数 |

### 使用方法

1. **训练网络**
   ```matlab
   % 在 trainMNIST.m 中设置网络结构
   hidden = [128, 64];  % 两个隐藏层，分别有128和64个神经元
   alpha = 1e-2;        % 初始学习率
   DNN = TrainDNN(Train, Label, Test, Tag, hidden, alpha);
   ```

2. **识别数字**
   ```matlab
   % 对白底黑字的数字图片进行识别
   [result, score] = Identify('your_image.png');
   ```

### 数据集

使用 MNIST 手写数字数据集：
- 训练集：60,000 张图片
- 测试集：10,000 张图片
- 图片尺寸：28×28 像素灰度图

---

## 项目二：图像处理实验 (image-processing)

### exp1.m - 图像滤波与特征提取

实现多种图像处理算法，不依赖 MATLAB 图像处理工具箱：

**功能：**
1. **Sobel 边缘检测** - 手动实现 Sobel 算子卷积
2. **自定义卷积滤波** - 支持任意卷积核
3. **颜色直方图** - RGB 三通道像素值分布统计
4. **纹理特征提取** - 灰度共生矩阵 (GLCM) 计算

**运行：**
```matlab
cd image-processing
exp1
```

### exp2.m - 边缘检测与 Hough 变换

实现完整的边缘检测和直线检测流程：

**处理流程：**
1. 灰度转换
2. Sobel 边缘检测
3. 均值滤波去噪
4. 二值化处理
5. Hough 变换直线检测

**运行：**
```matlab
cd image-processing
exp2
```

**输出示例：**
- 原图显示
- Sobel 边缘检测结果
- 均值滤波去噪结果
- 二值化结果
- Hough 变换检测到的直线（红色标记）

---

## 环境要求

- MATLAB R2016b 或更高版本
- 图像处理工具箱（可选，部分功能已手动实现）
- Python 3.x + NumPy（仅 exp1.m 的纹理特征保存功能需要）

## 参考资料

- [MNIST 数据集](http://yann.lecun.com/exdb/mnist/)
- [Sobel 算子](https://en.wikipedia.org/wiki/Sobel_operator)
- [Hough 变换](https://en.wikipedia.org/wiki/Hough_transform)

## 许可证

MATLAB-DNN 项目采用 MIT 许可证，详见 [MATLAB-DNN-master/LICENSE](MATLAB-DNN-master/LICENSE)。

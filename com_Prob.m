%% 时间不确定性
% 输入path：          路径
% 输入budget：        不确定参数
% 输入n1：            点的个数
% 输出Prob：          不确定概率
function Prob = com_Prob(path, budget, n1)

Prob = zeros(n1, n1);

nn = size(path, 2);

n = ( nn * (nn - 1) ) / 2;    % 生成n个[0,1]之间的数 

% 设置数字范围
min_val = 0;
max_val = 1;

% 生成n个数
% n = 59745;
numbers = rand(n, 1) * (max_val - min_val) + min_val;

% 计算当前和
current_sum = sum(numbers);

% 计算需要的缩放因子
scale_factor = budget / current_sum;

% 缩放数字使之和为目标和
numbers = numbers * scale_factor; 
[~, sortedIndex] = sort(numbers,'descend');   %  降序排序
rearrangedData = numbers(sortedIndex);

for i = 1 : n / 2
    if rearrangedData(i) > 1
        t = (rearrangedData(i) + rearrangedData(n - i + 1)) / 2;
        rearrangedData(i) = t;
        rearrangedData(n - i + 1) = t;
    end
end
randIndex = randperm(size(rearrangedData, 1));
num = rearrangedData(randIndex, : );

k = 1;
for i = 1 : nn - 1
    for j = i + 1 : nn
        Prob(path(i), path(j)) = num(k);
        Prob(path(j), path(i)) = num(k);
        k = k + 1;
    end
end



end
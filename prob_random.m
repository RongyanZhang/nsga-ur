%% 定义函数,生成符合要求的随机数
function random_number = prob_random(pp)
% 生成 10 个 [-1, 1] 之间的随机数
numbers = 2 * rand(1, 10) - 1;

if pp < 10
    % 根据要求调整数字的大小
    numbers(1 : pp) = abs(numbers(1 : pp));    % abs() 取绝对值函数
    numbers(pp + 1 : 10) = -abs(numbers(pp + 1 : 10));
else
    numbers(1 : pp) = abs(numbers(1 : pp));    % abs() 取绝对值函数
end

random_index = randi(length(numbers), 1, 1);
random_number = numbers(random_index);


%{
%% 定义函数,生成符合要求的随机数
function rand_num = prob_random()
    % 生成-1到1之间的随机数
    rand_num = 2 * rand() - 1;
    
    % 根据随机数大小,计算生成概率
    if rand_num >= 0
        prob = rand_num;
    else
        prob = rand_num / 2;
    end
    
    % 根据计算的概率,决定是否返回该随机数
    if rand() < prob
        return;
    else
        rand_num = prob_random(); % 递归调用直到满足条件
    end
end

%{
% 定义函数,生成符合要求的随机数
function rand_num = prob_random()
    % 生成符合指数分布的随机数
    rand_num = -log(1 - rand());
    
    % 将随机数映射到-1到1之间
    rand_num = 2 * rand_num / (1 + rand_num) - 1;
    
    
    return;
end
%}
%}
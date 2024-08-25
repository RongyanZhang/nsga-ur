%% 计算种群中每个个体的乘客满意度，出租车总距离
%输入SelCh：               种群
%输入R：                   订单
%输入B：                   公交车
%输入D：                   距离矩阵
%输出functionvalue：       种群中每个个体的乘客满意度，出租车总距离
function functionvalue = allObject(SelCh, R, B, D)
NIND = size(SelCh, 3);  % 种群大小
functionvalue = zeros(NIND, 5);
for i = 1 : NIND
    [satisfy, distance, walk, detour, price] = chromObj(SelCh(:, :, i), R, B, D);
    functionvalue(i, :) = [satisfy, distance, walk, detour, price];
end
end
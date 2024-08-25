%% 计算单个个体的乘客满意度，出租车总距离
%输入chrom：       单个个体
%输入R：           订单
%输入B：           公交车
%输入D：           距离矩阵
%输出satisfy：     乘客满意度
%输出distance：    出租车总距离
function [satisfy, distance, walk, detour, totalprice] = chromObj(chrom, R, B, D)

n_o = size(R,1);
n_B = size(B,1);

taxi = n_o;
n_p = taxi * 9;

pj = 2;    % 出租车每一公里的价钱 2元
a = 0.5;   % 打折费
b = 2;    % 座位费
c = 2;    % 公交车费
l = 0.5;  % 走路折扣费

x = 0.5;
y = 0.3;
z = 0.2;  % 乘客满意度的三个系数

%% 乘客的满意度
[path, ~]=Path(chrom, R, B, D);

satisfy = 0;
totalprice = 0;

for i = 1 : n_o
    
    walk = 0;    % 步行距离
    detour = 0;  % 绕行距离
    price = 0;   % 总花费

    if chrom(i, 1) == 0
        walk = walk + D(i, chrom(i,2)); 
    end
    if chrom(i, 3) ~= 0 && chrom(i, 4) == 0
        walk = walk + D(chrom(i,3), i + n_o); 
    end
    
    if chrom(i, 1) ~= 0
        path1 = path{chrom(i, 1) - n_o * 2 - n_B};
        if chrom(i, 2) == 0           % 出租车（起点-终点）
            dis = 0;
            for k = find(path1 == i) : find(path1 == i + n_o) - 1
                dis = dis + D(path1(k), path1(k+1));
            end
            detour1 = dis - D(i, i + n_o);
            detour = detour + detour1;
            price = price + D(i, i + n_o) * pj + a * pj * detour1 + (R(i, size(R, 2)) - 1) * b;

        elseif  chrom(i, 2) ~= 0    % 第一程为出租车（起点-公交车上车点）
            dis = 0;
            for k = find(path1 == i) : find(path1 == chrom(i, 2)) - 1
                dis = dis + D(path1(k), path1(k + 1));
            end
            detour1 = dis - D(i, chrom(i,2));
            detour = detour + detour1;
            price = price + D(i, chrom(i,2)) * pj + a * pj * detour1 + (R(i, size(R, 2)) - 1) * b;
        end
    end
    if chrom(i, 4) ~= 0 && chrom(i, 3) ~= 0     % 第三程为出租车（公交车下车点-终点）
        path1 = path{chrom(i, 4) - n_o * 2 - n_B};
        dis = 0;
        for k = find(path1 == chrom(i, 3)) : find(path1 == i + n_o) - 1
            dis = dis + D(path1(k), path1(k + 1));
        end
        detour1 = dis - D(chrom(i, 3), i + n_o);
        detour = detour + detour1; 
        price = price + D(chrom(i, 3), i + n_o) * pj + a * pj * detour1 + (R(i, size(R, 2)) - 1) * b;
    end

    if chrom(i, 2) == 0
        price = price - l * walk * R(i,size(R,2)) ;
    else
        price = price + R(i, size(R, 2)) * c - l * walk * R(i,size(R,2)) ;
    end
detour = abs(detour);
satisfy = satisfy + exp(-(x * walk + y * detour + z * price));
totalprice = totalprice + price;
end


%% 出租车的行车距离
distance = 0;
for j = 1 : n_p 
    path1 = path{j};
    if size(path1, 2) > 1
        n = size(path1, 2);
        for i = 1 : length(path1) - 1
            distance = distance + D(path1(1, i), path1(1, i + 1));
        end
        D2 = D(path1(1, n) , n_o * 2 + n_B + 1 : n_o * 2 + n_B + 90);
        distance = distance + min(D2);
    end   
end

end
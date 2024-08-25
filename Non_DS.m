%% 非支配排序
% 输入functionvalue	    目标函数值，乘客满意度，出租车总距离
% 输出frontvalue		每个个体的前沿面编号
% 思路：遍历每个个体，记录其他个体支配该个体的总数目，则前沿面编号=总数目+1
function frontvalue = Non_DS(functionvalue)
fnum = 0;                                              % 当前分配的前沿面编号
N = size(functionvalue, 1);                            % 个体数目
frontvalue = zeros(N, 1);                              % 每个个体的前沿面编号
cz = false(N, 1);                                      % 记录个体是否已被分配编号
while ~all(cz)                                      % 开始迭代判断每个个体的前沿面,采用改进的deductive sort
    fnum = fnum + 1;
    d = cz;
    for i = 1 : N
        if ~d(i)
            dominate_num = 0;                         % 记录支配第i个个体的数目
            for j = 1 : N
                if ~d(j)
                    if i ~= j
                        if (((functionvalue(j, 1) > functionvalue(i, 1)) && functionvalue(j, 2) < functionvalue(i, 2)))...
                                || (((functionvalue(j, 1) > functionvalue(i, 1)) && functionvalue(j, 2) == functionvalue(i, 2)))...
                                || (((functionvalue(j, 1) == functionvalue(i,1)) && functionvalue(j, 2) < functionvalue(i, 2)))
                            dominate_num = dominate_num + 1;
                        end
                        
                    end
                end
            end
            if dominate_num == 0    % 支配i的个体为0
                frontvalue(i) = fnum;
                cz(i) = true;
            end
        end
    end
end
end
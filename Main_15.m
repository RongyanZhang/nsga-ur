%%  request 2  and  0.6 0.8 1

clear
clc
tic

Obj_ALL1 = zeros(500, 100);
Obj_ALL2 = zeros(500, 100);
Obj_ALL3 = zeros(500, 100);
Obj_ALL4 = zeros(500, 100);
Obj_ALL5 = zeros(500, 100);

Satisfy_ALL = zeros(500, 500);
Distance_ALL = zeros(500, 500);

number = 0;

for j = 2 : 4
    for i = 1 : 6  
        if j == 1
            dev_t = 0;
            pp = 6;
            budget = 0;

        elseif j == 2
            dev_t = 2;
            pp = 6;
            budget = 1;

        elseif j == 3
            dev_t = 2;
            pp = 8;
            budget = 2;

        elseif j == 4
            dev_t = 2;
            pp = 10;
            budget = 3;
        end

        %% 创建数据
        [R, B, rB, D, station, Region] = Get_data(pp, dev_t);

        for k = 1 : 3     % 三种程度 0.15 0.3 0.5
            if k == 1
                dev_f = 0.15;
            elseif k == 2
                dev_f = 0.3;
            elseif k == 3
                dev_f = 0.5;
            end

            %% 参数设置
            NIND = 100;            % 种群大小
            Pc1 = 0.6;             % 交叉概率
            Pc2 = 0.5;
            MAXGEN = 500;         % 迭代次数
            Satisfy = zeros(1, MAXGEN);
            Distance =zeros(1, MAXGEN);
            
            %% 初始种群
            Population.Particle = InitPop(NIND, R, B, rB, D, station, Region, budget, dev_f);
            Population.PopObj = allObject(Population.Particle, R, B, D);
                                      
            %% 迭代优化
            gen=0;
            while gen<MAXGEN
                %% 交叉操作
                NewPopulation.Particle = Crossover2(Population.Particle, Pc1, R, B);
                NewPopulation.Particle = SelfCross2(NewPopulation.Particle, Pc2, R, B);
                %% 越界处理
                NewPopulation.Particle = adjustChrom(NewPopulation.Particle, R, B, rB, D, Region, budget, dev_f);
                NewPopulation.PopObj = allObject(NewPopulation.Particle, R, B, D);
                %% 种群合并
                NewPopulation.Particle = cat(3, Population.Particle, NewPopulation.Particle);
                NewPopulation.PopObj = [Population.PopObj;NewPopulation.PopObj];
                NewPopulation.frontvalue = Non_DS(NewPopulation.PopObj);
            
                %% 计算拥挤距离/选出下一代个体
                fnum = 0;   % 当前前沿面
                % numel函数：用于计算数组中满足指定条件的元素个数
                while numel(NewPopulation.frontvalue, NewPopulation.frontvalue <= fnum + 1) <= NIND     % 判断前多少个面的个体能完全放入下一代种群
                    fnum = fnum + 1;
                end
                %% 如果SelCh中第一前沿面个体数目不大于NIND
                newnum = numel(NewPopulation.frontvalue, NewPopulation.frontvalue <= fnum);                              % 前fnum个面的个体数
                Population.Particle(:, :, 1 : newnum) = NewPopulation.Particle(:, :, NewPopulation.frontvalue <= fnum);      % 将前fnum个面的个体复制入下一代
                Population.PopObj(1 : newnum, : ) = NewPopulation.PopObj(NewPopulation.frontvalue <= fnum, : );
                if newnum < NIND
                    popu = find(NewPopulation.frontvalue == fnum + 1);                                      % popu记录第fnum+1个面上的个体编号
                    distancevalue = CD_Assign(NewPopulation.PopObj(:, 1 : 2), NewPopulation.frontvalue, fnum + 1);           % 计算拥挤距离
                    popu = -sortrows(-[distancevalue'; popu']')';                          % 按拥挤距离降序排序第fnum+1个面上的个体
                    Population.Particle(:, :, newnum + 1 : NIND) = NewPopulation.Particle(:, :, popu(2, 1 : NIND - newnum));          % 将第fnum+1个面上拥挤距离较大的前NIND-newnum个个体复制入下一代
                    Population.PopObj(newnum + 1 : NIND, : ) = NewPopulation.PopObj(popu(2, 1 : NIND - newnum), : );
                end
                Obj = Population.PopObj;
        
                %% 更新迭代次数
                gen = gen + 1;
                max_satisfy = max(Obj(:, 1));
                Satisfy(gen) = max_satisfy;
                min_distance = min(Obj(:, 2));
                Distance(gen) = min_distance;
            end
            number = number + 1
           
            Obj_ALL1(number, : ) = Obj(:, 1)';
            Obj_ALL2(number, : ) = Obj(:, 2)';
            Obj_ALL3(number, : ) = Obj(:, 3)';
            Obj_ALL4(number, : ) = Obj(:, 4)';
            Obj_ALL5(number, : ) = Obj(:, 5)';
            
            Satisfy_ALL(number, : ) = Satisfy;
            Distance_ALL(number, : ) = Distance;
            
            cell = sprintf('A%d', number);   % A1 A2 A3...
            xlswrite('C:\Users\Dell\Desktop\Obj_ALL.xlsx', Obj(:, 1)', 1, cell)
            xlswrite('C:\Users\Dell\Desktop\Obj_ALL.xlsx', Obj(:, 2)', 2, cell)
            xlswrite('C:\Users\Dell\Desktop\Obj_ALL.xlsx', Obj(:, 3)', 3, cell)
            xlswrite('C:\Users\Dell\Desktop\Obj_ALL.xlsx', Obj(:, 4)', 4, cell)
            xlswrite('C:\Users\Dell\Desktop\Obj_ALL.xlsx', Obj(:, 5)', 5, cell)

            xlswrite('C:\Users\Dell\Desktop\Change_Obj.xlsx', Satisfy, 1, cell)
            xlswrite('C:\Users\Dell\Desktop\Change_Obj.xlsx', Distance, 2, cell)

        end
    
    end 
end

toc
function [inputsv] = loadRunData(SVPath,configId)
    SV = readtable(SVPath);
    ConfigParams = GetConfig(configId);

    % inputsvictors
    % for each timestep: sv values for that time, config params
    inputsv = SV;
    dateSplit = split(string(inputsv.Var1), '-');
    
    inputsv.swpcapacity = repmat(ConfigParams.swpcapacity,height(inputsv),1);
    inputsv.cvpcapacity = repmat(ConfigParams.cvpcapacity,height(inputsv),1);
    inputsv.user1 = repmat(ConfigParams.user1,height(inputsv),1);
    inputsv.user2 = repmat(ConfigParams.user2,height(inputsv),1);
    inputsv.source1 = repmat(ConfigParams.source1,height(inputsv),1);
    inputsv.source2 = repmat(ConfigParams.source2,height(inputsv),1);
    inputsv.source3 = repmat(ConfigParams.source3,height(inputsv),1);
    inputsv.source4 = repmat(ConfigParams.source4,height(inputsv),1);
    inputsv.source5 = repmat(ConfigParams.source5,height(inputsv),1);
    
    inputsv.month = str2double(dateSplit(:,2));
    
    eiRatio = [0.65, 0.65, 0.65, 0.65, 0.00, 0.35, 0.35, 0.35, 0.35, 0.65, 0.65, 0.65];
    
    % Add demand table here (same across scenarios) might have monthly effect-
    % check in inputsvictor selection
    demand_demand = [1.891, 3.111, 1.138, 1.015, 0.324, 0.566, 1.363, 1.434, 0.630, 1.452, 2.388, 1.975];
    demand_summ = [1.891, 5.002,6.140,7.155,7.479,8.045,9.408,10.842,11.472,12.924,15.312,17.287];
    
    % Check WYT as well to see if it's inputsvictive
    
    inputsv.eiRatio = eiRatio(inputsv.month)';
    inputsv.demand_demand = demand_demand(inputsv.month)';
    inputsv.demand_summ = demand_summ(inputsv.month)';
end

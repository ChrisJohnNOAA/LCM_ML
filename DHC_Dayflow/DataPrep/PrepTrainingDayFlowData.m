function [bayData, deltaData] = PrepTrainingDayFlowData(usePreLibertyIsland, useAbs, useX2Delta)
    if (useAbs)
        pred = readtable("D:\GitHub\LCM_ML\DHC_Dayflow\Data\Dayflow\DayFlow_MonthlyMean_AllAbs.csv");
    else
        pred = readtable("D:\GitHub\LCM_ML\DHC_Dayflow\Data\Dayflow\DayFlow_MonthlyMean.csv");
    end

    % The output doesn't have results for 2018 and later, so we can't use
    % those years for training
    pred = pred(pred.Year<2018,:);
    if (~usePreLibertyIsland)
        % Only take months with liberty island.
        pred = pred(pred.LibIsland==1,:);
        % Remove the liberty island column since it's not useful now.
        pred = pred(:,1:end-1);
    end

    deltaCapacity =  readtable("D:\GitHub\LCM_ML\DHC_Dayflow\Data\DHC_Results\Delta_Capacity95_NoMask_Historical_20210924.xlsx");
    bayCapacity =  readtable("D:\GitHub\LCM_ML\DHC_Dayflow\Data\DHC_Results\Bay_Capacity95_NoMask_Historical_20210924.xlsx");

    out = [deltaCapacity.Year, deltaCapacity.Month, deltaCapacity.Total, bayCapacity.Total];
    if (~usePreLibertyIsland)
        % Remove rows before liberty island flooded.
        out = out(out(:,1)>1997,:);
        out = out(~(out(:,1)==1998 & out(:,2)==1), :);
    end

    bayData = pred;
    bayData.Capacity = out(:,4);
    deltaData = pred;
    deltaData.Capacity = out(:,3);
    if (~useX2Delta)
        deltaData.X2 = [];
    end
end
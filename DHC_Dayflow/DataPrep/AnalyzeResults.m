function [analysis, outputDiff] = AnalyzeResults(bayData, deltaData, DayFlowModels, results)
analysis = struct();
% Do a rough "normalization" to see how large rmse is relative to
% variable values.
analysis.Bay_rmse_norm = sqrt(DayFlowModels.Bay_rmse) / mean(bayData.Capacity);
analysis.Delta_rmse_norm = sqrt(DayFlowModels.Delta_rmse) / mean(deltaData.Capacity);

outputDiff = table();

outputDiff.Bay(:) = bayData.Capacity(:) - results.bay_capacity(:);
figure('Name','Bay','NumberTitle','off');
scatter(results.bay_capacity, bayData.Capacity);

outputDiff.Delta(:) = deltaData.Capacity(:) - results.delta_capacity(:);
figure('Name','Delta','NumberTitle','off');
scatter(results.delta_capacity, deltaData.Capacity);
    
end

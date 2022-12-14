function [analysis, outputDiff] = AnalyzeResults(bayData, deltaData, DayFlowModels, results, descriptor)
analysis = struct();
% Do a rough "normalization" to see how large rmse is relative to
% variable values.
analysis.Bay_rmse_norm = sqrt(DayFlowModels.Bay_rmse) / mean(bayData.Capacity);
analysis.Delta_rmse_norm = sqrt(DayFlowModels.Delta_rmse) / mean(deltaData.Capacity);

outputDiff = table();

outputDiff.Bay(:) = bayData.Capacity(:) - results.bay_capacity(:);
figName = strcat(descriptor, 'Bay');
figure('Name',figName,'NumberTitle','off');
scatter(results.bay_capacity, bayData.Capacity);
saveas(gcf,figName,"png");

outputDiff.Delta(:) = deltaData.Capacity(:) - results.delta_capacity(:);
figName = strcat(descriptor,'Delta');
figure('Name',figName,'NumberTitle','off');
scatter(results.delta_capacity, deltaData.Capacity);
saveas(gcf,figName,"png");
    
end

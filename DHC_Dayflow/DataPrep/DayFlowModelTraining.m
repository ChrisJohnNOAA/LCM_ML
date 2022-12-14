function [DayFlowModels] = DayFlowModelTraining(DayFlowPredictors, bayData, deltaData, useGaussian)

DayFlowModels = struct();

DayFlowModels = trainModel(DayFlowModels, bayData, DayFlowPredictors.bay_capacity, bayData.Capacity, "Bay", useGaussian);
DayFlowModels = trainModel(DayFlowModels, deltaData, DayFlowPredictors.delta_capacity, deltaData.Capacity, "Delta", useGaussian);

end

function [DayFlowModels] = trainModel(DayFlowModels, data, predictors, output, varName, useGaussian)
    varName
    if (useGaussian)
        [model, rmse] = trainGPRModel(data, predictors,  output)
    else
        [model, rmse] = trainLinearModel(data, predictors,  output)
    end
    DayFlowModels.(varName) = model;
    DayFlowModels.(varName + "_rmse") = rmse;
    save('DayFlowModels.mat', 'DayFlowModels');
end

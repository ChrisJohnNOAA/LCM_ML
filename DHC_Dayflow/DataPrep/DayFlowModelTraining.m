function [DayFlowModels] = DayFlowModelTraining(DayFlowPredictors, bayData, deltaData, useGaussian, kernel)

DayFlowModels = struct();

DayFlowModels = trainModel(DayFlowModels, bayData, DayFlowPredictors.bay_capacity, bayData.Capacity, "Bay", useGaussian, kernel);
DayFlowModels = trainModel(DayFlowModels, deltaData, DayFlowPredictors.delta_capacity, deltaData.Capacity, "Delta", useGaussian, kernel);

end

function [DayFlowModels] = trainModel(DayFlowModels, data, predictors, output, varName, useGaussian, kernel)
    varName
    if (useGaussian)
        [model, rmse] = trainGPRModel(data, predictors,  output, kernel)
    else
        [model, rmse] = trainLinearModel(data, predictors,  output)
    end
    DayFlowModels.(varName) = model;
    DayFlowModels.(varName + "_rmse") = rmse;
    save('DayFlowModels.mat', 'DayFlowModels');
end

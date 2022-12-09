function [DayFlowModels] = DayFlowModelTraining(DayFlowPredictors, bayData, deltaData)

DayFlowModels = struct();

DayFlowModels = trainModel(DayFlowModels, bayData, DayFlowPredictors.bay_capacity, bayData.Capacity, "Bay");
DayFlowModels = trainModel(DayFlowModels, deltaData, DayFlowPredictors.delta_capacity, deltaData.Capacity, "Delta");

end

function [DayFlowModels] = trainModel(DayFlowModels, data, predictors, output, varName)
    varName
    [model, rmse] = trainCalSimGPRModel(data, predictors,  output)
    
    DayFlowModels.(varName) = model;
    DayFlowModels.(varName + "_rmse") = rmse;
    save('DayFlowModels.mat', 'DayFlowModels');
end

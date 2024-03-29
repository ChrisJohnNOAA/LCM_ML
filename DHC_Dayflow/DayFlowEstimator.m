%% Commands for loading training data and running training
% All at once:
% [dayFlowModelsPreLib, dayFlowModelsLibOnly, DayFlowPredictorsPreLib, DayFlowPredictorsLibOnly] = PrepAndTrainDayflow()
% By Parts:
% [bay, delta] = PrepTrainingDayFlowData();
% [DayFlowPredictors, scoreStruct] = DayFlowPredictorSelection(bay, delta);
% dayFlowModels = DayFlowModelTraining(DayFlowPredictors, bay, delta);

%% Use trained models to predict results
% newResultsData =  DayFlowMonthlyMean(DayFlowMonthlyMean.Year>=2018, :);
% newResultsLibOnly = DayFlowEstimator(newResultsData, dayFlowModelsLibOnly);

%% Commands for loading run data and running a simulation
% predictionTestingData =  DayFlowMonthlyLibOnly(DayFlowMonthlyLibOnly.Year<2018, :);
% predictionTestingData =  DayFlowMonthlyMean(DayFlowMonthlyMean.Year<2018, :);
% results = DayFlowEstimator(predictionTestingData, dayFlowModels);

%% Some helpful analysis scripts examples
% [analysis, outputDiff] = AnalyzeResults(bay, delta, dayFlowModels, results)

%% DayFlow function
function [output] = DayFlowEstimator(input, DayFlowModels, useGaussian)
output = table();

for i=1:height(input)
    stepInput = input(i,:);
    bayInput = stepInput(:,DayFlowModels.Bay.RequiredVariables);
    for j=1:width(bayInput)
        bayInput.Properties.VariableNames(j) = "x"+j;
    end

    deltaInput = stepInput(:,DayFlowModels.Delta.RequiredVariables);
    for j=1:width(deltaInput)
        deltaInput.Properties.VariableNames(j) = "x"+j;
    end

    if (useGaussian)
        [output.bay_capacity(i), output.bay_std(i)] = predict(DayFlowModels.Bay.RegressionGP, bayInput);
        [output.delta_capacity(i), output.delta_std(i)] = predict(DayFlowModels.Delta.RegressionGP, deltaInput);
    else
        [output.bay_capacity(i)] = predict(DayFlowModels.Bay.LinearModel, stepInput);
        [output.delta_capacity(i)] = predict(DayFlowModels.Delta.LinearModel, stepInput);
    end


end

end

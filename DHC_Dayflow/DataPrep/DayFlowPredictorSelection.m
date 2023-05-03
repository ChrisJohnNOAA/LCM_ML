function [DayFlowPredictors, scoreStruct] = DayFlowPredictorSelection(bayData, deltaData, useGaussian, kernel)

bayData = standardizeMissing(bayData, {Inf, -Inf});
preNormBay= bayData(:, 2:end);
deltaData = standardizeMissing(deltaData, {Inf, -Inf});
preNormDelta= deltaData(:, 2:end);
% Normalize variables before analysis
normBay = normalize(preNormBay);
normDelta = normalize(preNormDelta);

scoreStruct = struct();
DayFlowPredictors = struct();

[scoreStruct, DayFlowPredictors] = AnalyzeVariable(scoreStruct, ...
    DayFlowPredictors, normBay, 'bay_capacity', useGaussian, kernel);

[scoreStruct, DayFlowPredictors] = AnalyzeVariable(scoreStruct, ...
    DayFlowPredictors, normDelta, 'delta_capacity', useGaussian, kernel);

save("DayFlowPredictors.mat", "DayFlowPredictors");
save('modelInputScoring.mat', 'scoreStruct');

end

function [scoreStruct, DayFlowPredictors] = AnalyzeVariable(scoreStruct, ...
    DayFlowPredictors, data, varName, useGaussian, kernel)
    varName

    % this is the default value, and many of the other options take
    % significantly longer to to feature selection with (particularlt the
    % 'ard' options). Trying the simpler default to see if we can do
    % feature selection in a reasonable time frame.
    % kernelfcn = 'squaredexponential';
    % Predictors are anyting besides the Capacity column
    predictors = data.Properties.VariableNames(1:end-1);

    % Globally relevant values, added here to all rather than including in
    % the above lists.
    [predictors, scoreStruct] = SelectPredictors(varName, data, predictors, ...
        data.Capacity, 10, scoreStruct, true, kernel, useGaussian);
    DayFlowPredictors.(varName) = predictors;

    predictors
end


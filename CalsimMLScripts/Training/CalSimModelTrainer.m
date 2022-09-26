function [CalSimModels] = CalSimModelTrainer(CalSimPredictors, calPred, calOut, variables)

CalSimModels = struct();

% Targeted retraining
%load("CalSimModels.mat", 'CalSimModels');
%variables = ["C_SAC041", "DXC", "C_SAC029A", "C_SAC022", "C_SAC007", ...
%    "C_SAC000", "X2_WHLJPOD_EST_", "D_OMR028_DMC000", "D_OMR027_CAA000", ...
%    "S_ECHOL", "S_SLUIS_CVP", "S_SLUIS_SWP"];

for variable = variables
    CalSimModels = trainModel(CalSimModels, calPred, CalSimPredictors, calOut, variable);
end

end

function [CalSimModels] = trainModel(CalSimModels, calPred, CalSimPredictors, output, varName)
    varName

    %'exponential'	Exponential kernel.
    %'squaredexponential'	Squared exponential kernel.
    %'matern32'	Matern kernel with parameter 3/2.
    %'matern52'	Matern kernel with parameter 5/2.
    %'rationalquadratic'	Rational quadratic kernel.
    %'ardexponential'	Exponential kernel with a separate length scale per predictor.
    %'ardsquaredexponential'	Squared exponential kernel with a separate length scale per predictor.
    %'ardmatern32'	Matern kernel with parameter 3/2 and a separate length scale per predictor.
    %'ardmatern52'	Matern kernel with parameter 5/2 and a separate length scale per predictor.
    %'ardrationalquadratic'	Rational quadratic kernel with a separate length scale per predictor.

    % Train Model
    [model, rmse] = trainCalSimGPRModel(calPred, CalSimPredictors.(varName),  output.(varName))
    CalSimModels.(varName) = model;
    CalSimModels.(varName + "_rmse") = rmse;
    
    save('CalSimModels.mat', 'CalSimModels');
    
end

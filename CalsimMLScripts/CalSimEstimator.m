%% Commands for loading training data and running training
% [calPred, calOut] = PrepCalSim();
% [scoreStruct, CalSimPredictors, variables] = PredictorSelection(calPred, calOut, false);
% CalSimModels = CalSimModelTrainer(CalSimPredictors, calPred, calOut, variables, false);

%% Commands for loading run data and running a simulation
% inputsv = loadRunData("D:\GitHub\LCM_ML\Calsim_SV\0_DCR19_12.30_120621_NDDOff_2020.csv", 0);
% results = CalSimEstimator(inputsv, CalSimModels, variables);

%% Some helpful analysis scripts examples
% analysis = AnalysisScript(calPred, calOut, CalSimModels, variables);
% FindVariablesUsePredictor(CalSimPredictors, variables, "S_ALMNR")
% outputDiff= CheckPredictions(results, checkData);

%% Needs Improvement/investigation
% C_CSL004B, D_OMR027_CAA000, DXC, D_OMR028_DMC000
% S_WKYTN, S_SLUIS_SWP, S_LOSVQ, S_ALMNR, S_PARDE

%% CalsimEstimator function
function [calOut] = CalSimEstimator(calInput, CalSimModels, variables)
calOut = table();

variables = variables(isfield(CalSimModels, variables));

stepInput = table();
for variable = variables
    for name = CalSimModels.(variable).RequiredVariables
        stepInput.(char(name))(1) = 0;
    end
end
varName = calInput.Properties.VariableNames;
for i = 1:length(varName)
    stepInput.(varName{i})(1) = calInput.(varName{i})(1);
end
for variable = variables
    convertedInput = stepInput(:,CalSimModels.(variable).RequiredVariables);
    for i=1:width(convertedInput)
        convertedInput.Properties.VariableNames(i) = "x"+i;
    end
    %calOut.(variable)(1) = CalSimModels.(variable).predictFcn(convertedInput);
    calOut.(variable)(1) = predict(CalSimModels.(variable).RegressionGP, convertedInput);
end

for i=2:height(calInput)
    stepInput = calInput(i,:);
    varName = calOut.Properties.VariableNames;
    for j = 1:length(varName)
        stepInput.(varName{j})(:) = calOut.(varName{j})(i-1);
    end

    for variable = variables
        convertedInput = stepInput(:,CalSimModels.(variable).RequiredVariables);
        for j=1:width(convertedInput)
            convertedInput.Properties.VariableNames(j) = "x"+j;
        end
        %calOut.(variable)(i) = CalSimModels.(variable).predictFcn(convertedInput);

        calOut.(variable)(i) = predict(CalSimModels.(variable).RegressionGP, convertedInput);
    end
end

end

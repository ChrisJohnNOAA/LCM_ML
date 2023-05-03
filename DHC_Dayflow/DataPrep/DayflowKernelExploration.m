function [] = DayflowKernelExploration()
% post lib: all available, with exclusion list, with exclusion list +nbaq
% allowed
% pre lib: new exclusion list (no nbaq)
    useGaussian = true;
    usePreLibertyIsland = false;
    useAbs = false;
    allowX2 = false;
    evaluations = 5;
    holdoutAmount = 0.1;

    [bay, delta, fullData] = PrepTrainingDayFlowData(usePreLibertyIsland, useAbs, allowX2);

    [ardexponential] = runScenario(bay, delta, fullData, useGaussian, "ardexponential", evaluations, holdoutAmount);

    [exponential] = runScenario(bay, delta, fullData, useGaussian, "exponential", evaluations, holdoutAmount);
    [squaredexponential] = runScenario(bay, delta, fullData, useGaussian, "squaredexponential", evaluations, holdoutAmount);
    [matern32] = runScenario(bay, delta, fullData, useGaussian, "matern32", evaluations, holdoutAmount);
    [matern52] = runScenario(bay, delta, fullData, useGaussian, "matern52", evaluations, holdoutAmount);
    [rationalquadratic] = runScenario(bay, delta, fullData, useGaussian, "rationalquadratic", evaluations, holdoutAmount);
    
    [ardsquaredexponential] = runScenario(bay, delta, fullData, useGaussian, "ardsquaredexponential", evaluations, holdoutAmount);
    [ardmatern32] = runScenario(bay, delta, fullData, useGaussian, "ardmatern32", evaluations, holdoutAmount);
    [ardmatern52] = runScenario(bay, delta, fullData, useGaussian, "ardmatern52", evaluations, holdoutAmount);
    [ardrationalquadratic] = runScenario(bay, delta, fullData, useGaussian, "ardrationalquadratic", evaluations, holdoutAmount);
    
    save('DayFlowDHCKernelsData.mat');
end

function [values] = runScenario(bay, delta, fullData, useGaussian, descriptor, evaluations, holdoutAmount)
    descriptor
    values = struct();

    [rows, ] = size(bay);
    bayHoldout = bay(1:floor(rows*holdoutAmount), :);
    bayTraining = bay(ceil(rows*holdoutAmount):rows, :);

    [rows, ] = size(delta);
    deltaHoldout = delta(1:floor(rows*holdoutAmount), :);
    deltaTraining = delta(ceil(rows*holdoutAmount):rows, :);
    
    %[values.DayFlowPredictors] = DayFlowPredictorSelection(bay, delta, useGaussian, descriptor);
    %values.dayFlowModels = DayFlowModelTraining(values.DayFlowPredictors, bay, delta, useGaussian, descriptor, evaluations);
    % Since we have so little data, it may be better to use the full data
    % for predictor selection.
    [values.DayFlowPredictors] = DayFlowPredictorSelection(bayTraining, deltaTraining, useGaussian, descriptor);
    values.dayFlowModels = DayFlowModelTraining(values.DayFlowPredictors, bayTraining, deltaTraining, useGaussian, descriptor, evaluations);

    %values.results = DayFlowEstimator(bay, values.dayFlowModels , useGaussian);
    %[values.analysis, values.outputDiff] = AnalyzeResults(bay, delta, values.dayFlowModels , values.results, descriptor);
    values.results = DayFlowEstimator(bayHoldout, values.dayFlowModels , useGaussian);
    [values.analysis, values.outputDiff] = AnalyzeResults(bayHoldout, deltaHoldout, values.dayFlowModels , values.results, descriptor);
    newResultsData =  fullData(fullData.Year>=2018, :);
    values.newResults = DayFlowEstimator(newResultsData, values.dayFlowModels , true);
end


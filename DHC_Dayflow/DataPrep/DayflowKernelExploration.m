function [] = DayflowKernelExploration()
% post lib: all available, with exclusion list, with exclusion list +nbaq
% allowed
% pre lib: new exclusion list (no nbaq)
    useGaussian = true;
    usePreLibertyIsland = false;
    useAbs = false;
    allowX2 = false;

    [bay, delta, fullData] = PrepTrainingDayFlowData(usePreLibertyIsland, useAbs, allowX2);

    [ardexponential] = runScenario(bay, delta, fullData, useGaussian, "ardexponential");

    [exponential] = runScenario(bay, delta, fullData, useGaussian, "exponential");
    [squaredexponential] = runScenario(bay, delta, fullData, useGaussian, "squaredexponential");
    [matern32] = runScenario(bay, delta, fullData, useGaussian, "matern32");
    [matern52] = runScenario(bay, delta, fullData, useGaussian, "matern52");
    [rationalquadratic] = runScenario(bay, delta, fullData, useGaussian, "rationalquadratic");
    
    [ardsquaredexponential] = runScenario(bay, delta, fullData, useGaussian, "ardsquaredexponential");
    [ardmatern32] = runScenario(bay, delta, fullData, useGaussian, "ardmatern32");
    [ardmatern52] = runScenario(bay, delta, fullData, useGaussian, "ardmatern52");
    [ardrationalquadratic] = runScenario(bay, delta, fullData, useGaussian, "ardrationalquadratic");
    
    save('DayFlowDHCKernelsData.mat');
end

function [values] = runScenario(bay, delta, fullData, useGaussian, descriptor)
    descriptor
    values = struct();
    
    [values.DayFlowPredictors] = DayFlowPredictorSelection(bay, delta, useGaussian, descriptor);
    values.dayFlowModels = DayFlowModelTraining(values.DayFlowPredictors, bay, delta, useGaussian, descriptor);

    values.results = DayFlowEstimator(bay, values.dayFlowModels , useGaussian);
    [values.analysis, values.outputDiff] = AnalyzeResults(bay, delta, values.dayFlowModels , values.results, descriptor);
    newResultsData =  fullData(fullData.Year>=2018, :);
    values.newResults = DayFlowEstimator(newResultsData, values.dayFlowModels , true);
end


function [] = PrepAndTrainDayflow()
    useGaussian = false;
    [libRawResults, libRawModels, libRawPredictors, libRawAnalysis, libRawOutputDiff] = runScenario(false, false, false, useGaussian, "Lib Only Raw ");
    [preLibRawResults, preLibRawModels, preLibRawPredictors, preLibRawAnalysis, preLibRawOutputDiff] = runScenario(true, false, false, useGaussian, "Pre-Lib Raw ");
    [libAbsResults, libAbsModels, libAbsPredictors, libAbsAnalysis, libAbsOutputDiff] = runScenario(false, true, false, useGaussian, "Lib Only Abs ");
    [preLibAbsResults, preLibAbsModels, preLibAbsPredictors, preLibAbsAnalysis, preLibAbsOutputDiff] = runScenario(true, true, false, useGaussian, "Pre-Lib Abs ");

    [libRawX2Results, libRawX2Models, libRawX2Predictors, libRawX2Analysis, libRawX2OutputDiff] = runScenario(false, false, true, useGaussian, "Lib Only Raw X2 ");
    [preLibRawX2Results, preLibRawX2Models, preLibRawX2Predictors, preLibRawX2Analysis, preLibRawX2OutputDiff] = runScenario(true, false, true, useGaussian, "Pre-Lib Raw X2 ");
    [libAbsX2Results, libAbsX2Models, libAbsX2Predictors, libAbsX2Analysis, libAbsX2OutputDiff] = runScenario(false, true, true, useGaussian, "Lib Only Abs X2 ");
    [preLibAbsX2Results, preLibAbsX2Models, preLibAbsX2Predictors, preLibAbsX2Analysis, preLibAbsX2OutputDiff] = runScenario(true, true, true, useGaussian, "Pre-Lib Abs X2 ");
    save('DayFlowDHCData.mat');
end

function [results, dayFlowModels, DayFlowPredictors, analysis, outputDiff] = runScenario(usePreLibertyIsland, useAbs, x2Delta, useGaussian, descriptor)
    [bay, delta] = PrepTrainingDayFlowData(usePreLibertyIsland, useAbs, x2Delta);
    [DayFlowPredictors] = DayFlowPredictorSelection(bay, delta, useGaussian);
    dayFlowModels = DayFlowModelTraining(DayFlowPredictors, bay, delta, useGaussian);
    results = DayFlowEstimator(bay, dayFlowModels, useGaussian);
    [analysis, outputDiff] = AnalyzeResults(bay, delta, dayFlowModels, results, descriptor);
end
function [] = PrepAndTrainDayflow()
    [libRawResults, libRawModels, libRawPredictors, libRawAnalysis, libRawOutputDiff] = runScenario(false, false, false, "Lib Only Raw ");
    [preLibRawResults, preLibRawModels, preLibRawPredictors, preLibRawAnalysis, preLibRawOutputDiff] = runScenario(true, false, false, "Pre-Lib Raw ");
    [libAbsResults, libAbsModels, libAbsPredictors, libAbsAnalysis, libAbsOutputDiff] = runScenario(false, true, false, "Lib Only Abs ");
    [preLibAbsResults, preLibAbsModels, preLibAbsPredictors, preLibAbsAnalysis, preLibAbsOutputDiff] = runScenario(true, true, false, "Pre-Lib Abs ");

    [libRawX2Results, libRawX2Models, libRawX2Predictors, libRawX2Analysis, libRawX2OutputDiff] = runScenario(false, false, true, "Lib Only Raw X2 ");
    [preLibRawX2Results, preLibRawX2Models, preLibRawX2Predictors, preLibRawX2Analysis, preLibRawX2OutputDiff] = runScenario(true, false, true, "Pre-Lib Raw X2 ");
    [libAbsX2Results, libAbsX2Models, libAbsX2Predictors, libAbsX2Analysis, libAbsX2OutputDiff] = runScenario(false, true, true, "Lib Only Abs X2 ");
    [preLibAbsX2Results, preLibAbsX2Models, preLibAbsX2Predictors, preLibAbsX2Analysis, preLibAbsX2OutputDiff] = runScenario(true, true, true, "Pre-Lib Abs X2 ");
    save('DayFlowDHCData.mat');
end

function [results, dayFlowModels, DayFlowPredictors, analysis, outputDiff] = runScenario(usePreLibertyIsland, useAbs, x2Delta, descriptor)
    [bay, delta] = PrepTrainingDayFlowData(usePreLibertyIsland, useAbs, x2Delta);
    [DayFlowPredictors] = DayFlowPredictorSelection(bay, delta);
    dayFlowModels = DayFlowModelTraining(DayFlowPredictors, bay, delta);
    results = DayFlowEstimator(bay, dayFlowModels);
    [analysis, outputDiff] = AnalyzeResults(bay, delta, dayFlowModels, results, descriptor);
end
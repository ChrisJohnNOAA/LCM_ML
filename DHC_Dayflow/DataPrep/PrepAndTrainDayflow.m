function [dayFlowModels,DayFlowPredictors] = PrepAndTrainDayflow()
    [bay, delta] = PrepTrainingDayFlowData();
    [DayFlowPredictors, scoreStruct] = DayFlowPredictorSelection(bay, delta);
    dayFlowModels = DayFlowModelTraining(DayFlowPredictors, bay, delta);
end


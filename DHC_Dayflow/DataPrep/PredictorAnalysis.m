function [] = PredictorAnalysis()
    load('DayFlowDHCKernelsData.mat')

    printPredictors(exponential)
    printPredictors(squaredexponential)
    printPredictors(matern32)
    printPredictors(matern52)
    printPredictors(rationalquadratic)
    printPredictors(ardexponential)
    printPredictors(ardsquaredexponential)
    printPredictors(ardmatern32)
    printPredictors(ardmatern52)
    printPredictors(ardrationalquadratic)
    
end

function [] = printPredictors(input)
    disp(strcat('bay- ', num2str(input.dayFlowModels.Bay_rmse)))
    input.DayFlowPredictors.bay_capacity
    disp(strcat('delta- ', num2str(input.dayFlowModels.Delta_rmse)))
    input.DayFlowPredictors.delta_capacity
end
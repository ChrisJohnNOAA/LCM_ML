function [uses] = FindVariablesUsePredictor(CalSimPredictors, variables, predictor)
uses = [];
for variable = variables
    if any(strcmp(CalSimPredictors.(variable), predictor))
        uses = [uses variable];
    end
end
end
function [uses] = FindVariablesUsePredictor(CalSimPredictors, variables, predictor)
    uses = [];
    for variable = variables
        if (isfield(CalSimPredictors, variable))
            if any(strcmp(CalSimPredictors.(variable), predictor))
                uses = [uses variable];
            end
        end
    end
end
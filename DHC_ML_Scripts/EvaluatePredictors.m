function [fscores, mrscores, pcaPredictors] = EvaluatePredictors(predictors, outputs)
% Ignore the date/time variables
predictors = predictors(:,2:end);
outputs = outputs(:,2:end);

 % Feature Ranking and Selection
 % Replace Inf/-Inf values with NaN to prepare data for normalization
 predictors = standardizeMissing(predictors, {Inf, -Inf});
 % Normalize data for feature ranking
 predictorMatrix= normalize(predictors, "DataVariable", true);

fscores = zeros(width(predictors),width(outputs));
% foreach output
for i = 1:width(outputs)
    response = outputs.(i);
    % Rank features using FTest algorithm
    [featureIndex, featureScore] = fsrftest(...
        predictorMatrix, ...
        response);
    %featureScore(isinf(featureScore)) = 100000;
    fscores(:, i) = featureScore;
end

mrscores = zeros(width(predictors),width(outputs));
for i = 1:width(outputs)
    response = outputs.(i);
    % Rank features using FTest algorithm
    [featureIndex, featureScore] = fsrmrmr(...
        predictorMatrix, ...
        response);
    %featureScore(isinf(featureScore)) = 100000;
    mrscores(:, i) = featureScore;
end

pcaPredictors = UsePCA(predictors);

noInf = mrscores;
noInf(isinf(noInf)) = 1000;
collapsedScores = sum(noInf,2);
varIndex = collapsedScores>50000;
colNames = predictors.Properties.VariableNames(2:end);
selectedCols = colNames(varIndex);

end

function [predictors] = UsePCA(numericPredictors)
    numericPredictors = table2array(varfun(@double, numericPredictors));
    % 'inf' values have to be treated as missing data for PCA.
    numericPredictors(isinf(numericPredictors)) = NaN;
    [pcaCoefficients, pcaScores, ~, ~, explained, pcaCenters] = pca(...
        numericPredictors);
    % Keep enough components to explain the desired amount of variance.
    explainedVarianceToKeepAsFraction = 9.999000e+01/100;
    numComponentsToKeep = find(cumsum(explained)/sum(explained) >= explainedVarianceToKeepAsFraction, 1);
    pcaCoefficients = pcaCoefficients(:,1:numComponentsToKeep);
    predictors = array2table(pcaScores(:,1:numComponentsToKeep));
end
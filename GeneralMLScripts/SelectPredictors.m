function [predictors, scoreStruct] = SelectPredictors(varName, data, predictors, target, maxPredictors, scoreStruct, indepthSelection, kernelfcn)
    if (indepthSelection)
        [predictors, scoreStruct] = SequentialSelection(varName, data, predictors, target, maxPredictors, scoreStruct, kernelfcn);
    else
        [predictors, scoreStruct] = QuickSelection(varName, data, predictors, target, maxPredictors, scoreStruct);
    end

end

function [predictors, scoreStruct] = QuickSelection(varName, data, predictors, target, maxPredictors, scoreStruct)
    % Check for correlation p < 0.05
    [r, p] = corr(table2array(data(:, predictors)), ...
        target, 'rows','complete');

    scoreStruct.(varName+"_corr") = table(predictors', r, p);
    scoreStruct.(varName+"_corr") = sortrows(scoreStruct.(varName+"_corr"),'r','descend');

    predictors = predictors(p<0.05);

    % Check for fscore > 400
    [featureIndex, featureScore] = fsrftest(...
        data(:, predictors), ...
        target);

    scoreStruct.(varName+"_f") = table(predictors(featureIndex)', featureScore(featureIndex)');
    predictors = predictors(featureScore > 400);
    
    % Use mrmr to select top X from remaining (15?)
    [featureIndex, featureScore] = fsrmrmr(...
        data(:, predictors), ...
        target);

    scoreStruct.(varName+"_mrmr") = table(predictors(featureIndex)', featureScore(featureIndex)');
    predictors = predictors(featureIndex);
    predictors = predictors(1:min(maxPredictors,length(predictors)));
end


function [predictors, scoreStruct] = SequentialSelection(varName, data, predictors, target, maxPredictors, scoreStruct, kernelfcn)
% Check for correlation p < 0.05
[r, p] = corr(table2array(data(:, predictors)), ...
    target, 'rows','complete');

scoreStruct.(varName+"_corr") = table(predictors', r, p);
scoreStruct.(varName+"_corr") = sortrows(scoreStruct.(varName+"_corr"),'r','descend');

predictors = predictors(p<0.05);

% Check for fscore > 10
[featureIndex, featureScore] = fsrftest(...
    data(:, predictors), ...
    target);

scoreStruct.(varName+"_f") = table(predictors(featureIndex)', featureScore(featureIndex)');
predictors = predictors(featureScore > 10);


c = cvpartition(target,'k',10);
opts = statset('Display','iter','UseParallel',true);

function [lossAmount] = FitAndLoss(XTrain,YTrain,XTest,YTest)
    try
        lossAmount = loss(fitrgp(...
            XTrain, ...
            YTrain, ...
            'BasisFunction', 'constant', ...
            'Standardize', true, ...
            'PredictMethod','exact', ... % It defaults to 'bcd' if training data > 10,000 and I'm using 13,536 rows, but bcd seems to get stuck training
            'KernelFunction', kernelfcn),XTest,YTest);
    catch ME
        disp(ME)
        lossAmount = 999999999;
    end
end


[fs,history] = sequentialfs(@FitAndLoss,table2array(data(:, predictors)),target,'cv',c,'options',opts);
scoreStruct.(varName+"_history") = history;
predictors = predictors(fs);
end
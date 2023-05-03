function [inmodel] = PredictorSelector(data)
%X = table2array(data(:,2:end-1));
Y = data.capacity;

standardized = standardizeMissing(data(:,2:end-1), {Inf, -Inf});
% Normalize data for feature ranking
normalized = normalize(standardized);

inmodel = customSequential(table2array(normalized),Y);

end

function [selectedPredictors] = customSequential(X,Y)

%X = standardizeMissing(X, {Inf, -Inf});
% Normalize data for feature ranking
%predictorMatrix = normalize(X);

numPredictors = width(X);

response = Y;

selectedPredictors = false(1,numPredictors);

% loop
for i=1:numPredictors
    %[featureIndex, featureScore] = fsrftest(...
    %        predictorMatrix, ...
    %        response);
    predictorScore = nan(1,numPredictors);
    
    for j=1:numPredictors
        if ~selectedPredictors(j)
            selectedPredictors(j) = true;
            model = trainModel(X(:,selectedPredictors), Y);
            predictorScore(j) = sum(abs(predict(model, X(:,selectedPredictors)) - Y));
            selectedPredictors(j) = false;
        end
    end

    [err, index] = min(predictorScore);
    selectedPredictors(index) = true;
    
    % get first feature and add to selected predictors
    
    % train model on feature
    model = trainModel(X(:,selectedPredictors), Y);
    
    % calculate errors for model
    errors = predict(model, X(:,selectedPredictors)) - Y;

    if sum(abs(response)) < sum(abs(errors))
        selectedPredictors(index) = false;
        break;
    end
    response = errors;

    %check if errors small enough to stop?
end
end

function [model] = trainModel(predictors, response)
%model = fitglm(predictors, response,"quadratic","Distribution","poisson");

%model = fitrnet(...
%    predictors, ...
%    response, ...
%    'LayerSizes', [10 10], ...
%    'Activations', 'relu', ...
%    'Lambda', 0, ...
%    'IterationLimit', 1000, ...
%    'Standardize', true);

%model = fitlm(...
%    predictors, response, ...
%    'interactions', ...
%    'RobustOpts', 'off');

%model = fitrtree(...
%    predictors, ...
%    response, ...
%    'MinLeafSize', 4, ...
%    'Surrogate', 'off');

model = fitrgp(...
               predictors, ...
               response, ...
               'BasisFunction', 'constant', ...
               'KernelFunction', 'exponential', ...
               'Standardize', true);
end

function [inmodel] = useSequential(X,Y)

% Look at options for these- though trying my idea will likely run much
% faster
maxdev = chi2inv(.95,1);     
opt = statset('display','iter',...
              'TolFun',maxdev,...
              'TolTypeFun','abs');

inmodel = sequentialfs(@critfun,X,Y,...
                       'cv','none',...
                       'options',opt,...
                       'direction','forward');

%'nullmodel',true,...
end

function [validationRMSE] = critfun(X,Y)
model = fitrgp(...
    X, ...
    Y, ...
    'BasisFunction', 'constant', ...
    'KernelFunction', 'exponential', ...
    'Standardize', true);
%loss = model.resubLoss();

% Perform cross-validation
partitionedModel = crossval(model, 'KFold', 5);

% Compute validation RMSE
validationRMSE = sqrt(kfoldLoss(partitionedModel, 'LossFun', 'mse'));

%model = fitglm(X,Y,'Distribution','binomial');
%dev = model.Deviance;
end



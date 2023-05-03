function [modelResultsTable, models] = PredictorExplorationController(data)
% Ignore the date column
data = data(:,2:end);
models = struct();
modelResultsTable = table('Size', [0,2], 'VariableNames',{'name', 'rmse'}, ...
    'VariableTypes',{'string','double'});
tableRow = 1;
% 1 variable
for i=1:(width(data)-1)
    predictors = [false false false false false false false false false false false false false];
    predictors(i) = true;
    %modelResultsTable.predictors(tableRow) = predictors;
    modelResultsTable.name(tableRow) = data.Properties.VariableNames(i);
    disp('Evaluating: ' + string(modelResultsTable.name(tableRow)))
    [model, modelResultsTable.rmse(tableRow)] = trainTreeRegressionModel(data, predictors);
    tableRow = tableRow + 1;
end

% 2 variable
for i=1:(width(data)-2)
    for j=(i+1):(width(data)-1)
        if i==j
            continue;
        end
        predictors = [false false false false false false false false false false false false false];
        predictors(i) = true;
        predictors(j) = true;
        %modelResultsTable.predictors(tableRow) = predictors;
        modelResultsTable.name(tableRow) = data.Properties.VariableNames(i);
        modelResultsTable.name(tableRow) = modelResultsTable.name(tableRow) + data.Properties.VariableNames(j);
        disp('Evaluating: ' + string(modelResultsTable.name(tableRow)))
        [model, modelResultsTable.rmse(tableRow)] = trainTreeRegressionModel(data, predictors);
        tableRow = tableRow + 1;
    end
end

% 3 variable
for i=1:(width(data)-3)
    for j=(i+1):(width(data)-2)
        if i==j
            continue
        end
        for k=(j+1):(width(data)-1)
            if i==k || j==k
                continue;
            end
            predictors = [false false false false false false false false false false false false false];
            predictors(i) = true;
            predictors(j) = true;
            predictors(k) = true;
            %modelResultsTable.predictors(tableRow) = predictors;
            modelResultsTable.name(tableRow) = data.Properties.VariableNames(i);
            modelResultsTable.name(tableRow) = modelResultsTable.name(tableRow) + data.Properties.VariableNames(j);
            modelResultsTable.name(tableRow) = modelResultsTable.name(tableRow) + data.Properties.VariableNames(k);
            disp('Evaluating: ' + string(modelResultsTable.name(tableRow)))
            [model, modelResultsTable.rmse(tableRow)] = trainTreeRegressionModel(data, predictors);
            tableRow = tableRow + 1;
        end
    end
end

% 4 variable
for i=1:(width(data)-4)
    for j=(i+1):(width(data)-3)
        if i==j
            continue
        end
        for k=(j+1):(width(data)-2)
            if i==k || j==k
                continue;
            end
            for l=(k+1):(width(data)-1)
                if l==i || l==j || l==k
                    continue;
                end
                predictors = [false false false false false false false false false false false false false];
                predictors(i) = true;
                predictors(j) = true;
                predictors(k) = true;
                predictors(l) = true;
                %modelResultsTable.predictors(tableRow) = predictors;
                modelResultsTable.name(tableRow) = data.Properties.VariableNames(i);
                modelResultsTable.name(tableRow) = modelResultsTable.name(tableRow) + data.Properties.VariableNames(j);
                modelResultsTable.name(tableRow) = modelResultsTable.name(tableRow) + data.Properties.VariableNames(k);
                modelResultsTable.name(tableRow) = modelResultsTable.name(tableRow) + data.Properties.VariableNames(l);
                disp('Evaluating: ' + string(modelResultsTable.name(tableRow)))
                [model, modelResultsTable.rmse(tableRow)] = trainTreeRegressionModel(data, predictors);
                tableRow = tableRow + 1;
            end
        end
    end
end

% 5 variable
for i=1:(width(data)-5)
    for j=(i+1):(width(data)-4)
        if i==j
            continue
        end
        for k=(j+1):(width(data)-3)
            if i==k || j==k
                continue;
            end
            for l=(k+1):(width(data)-2)
                if l==i || l==j || l==k
                    continue;
                end
                for m=(l+1):(width(data)-1)
                    if m==i || m==j || m==k || m==l
                        continue;
                    end
                    predictors = [false false false false false false false false false false false false false];
                    predictors(i) = true;
                    predictors(j) = true;
                    predictors(k) = true;
                    predictors(l) = true;
                    predictors(m) = true;
                    %modelResultsTable.predictors(tableRow) = predictors;
                    
                    rowName = string(data.Properties.VariableNames(i));
                    rowName = rowName + string(data.Properties.VariableNames(j));
                    rowName = rowName + string(data.Properties.VariableNames(k));
                    rowName = rowName + string(data.Properties.VariableNames(l));
                    rowName = rowName + string(data.Properties.VariableNames(m));
                    disp('Evaluating: ' + string(rowName))
                    [model, rmse] = trainTreeRegressionModel(data, predictors);
                    modelResultsTable.name(tableRow) = rowName;
                    modelResultsTable.rmse(tableRow) = rmse;
                    tableRow = tableRow + 1;
                end
            end
        end
    end
end

end


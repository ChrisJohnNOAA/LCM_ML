function [outputDiff] = CheckPredictions(results,checkData)
outputDiff = table();
varName = results.Properties.VariableNames;
for i = 1:length(varName)
    outputDiff.(varName{i})(:) = checkData.(varName{i})(:) - results.(varName{i})(:);
    figure('Name',varName{i},'NumberTitle','off');
    scatter(results.(varName{i}), checkData.(varName{i}));
end

end
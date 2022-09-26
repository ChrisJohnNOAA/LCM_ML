function [] = findDateTime(table)
varName = table.Properties.VariableNames;
for i = 1:length(varName)
    if isdatetime(table.(varName{i})) == 1
        disp("datetime: " + varName{i} + "at index: " + i);
    end
end
end
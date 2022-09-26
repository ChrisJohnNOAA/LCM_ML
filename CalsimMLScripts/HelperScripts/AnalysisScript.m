function [analysis] = AnalysisScript(calPred, calOut, CalSimModels, variables)
analysis = struct();

for variable = variables
    % Do a rough "normalization" to see how large rmse is relative to
    % variable values.
    analysis.(variable + "_rmse_norm") = sqrt(CalSimModels.(variable + "_rmse")) / mean(calOut.(variable));
    % currently investigating if kernel type is reliable for different
    % variables in order to allow speeding up training time.
    analysis.(variable + "_kernel") = CalSimModels.(variable).RegressionGP.KernelFunction;
    if (analysis.(variable + "_rmse_norm") > 0.01)
        disp("high normalized rmse for: " + variable)
    end
end

end

%% Helper function used to compare results across runs.
function change = CompareResults(mrmrAnalysis, oldAnalysis)

variables = ["C_KSWCK", "C_SAC287", "C_SAC269", "C_SAC257", "C_SAC247", ...
    "C_SAC240", "C_SAC217", "C_SAC207", "C_SAC193", "C_SAC185", "C_SAC169",...
    "C_SAC159", "C_SAC148", "C_SAC122", "C_SAC120", "C_SAC093", "C_SAC083",...
    "SP_SAC083_YBP037", "C_SAC075", "C_SAC065", "C_YBP002", "C_CSL004B",...
    "C_SAC063", "C_SAC062", "C_SAC041", "C_SAC029A", "C_SAC022", "C_SAC007",...
    "DXC", "C_SAC000", "D_OMR027_CAA000", "D_OMR028_DMC000",...
    "C_CLV004", "C_MOK022", "S_SHSTA", "S_TRNTY", "S_WKYTN", "S_ALMNR",...
    "S_OROVL", "S_NBLDB", "S_FOLSM", "S_ECHOL", "S_MLRTN", "S_NHGAN", ...
    "S_MELON", "S_SLUIS_CVP", "S_SLUIS_SWP", "X2_WHLJPOD_EST_"];

for variable = variables
    change.(variable) = mrmrAnalysis.(variable + "_rmse_norm") - mrmrAnalysis_old.(variable + "_rmse_norm");
end
end



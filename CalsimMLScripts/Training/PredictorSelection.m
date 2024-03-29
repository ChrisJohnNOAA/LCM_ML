function [scoreStruct, CalSimPredictors, variables] = PredictorSelection(predictors,output, slurm)

predictors = standardizeMissing(predictors, {Inf, -Inf});
preNormPredictors = predictors(:, 2:end);
output = standardizeMissing(output, {Inf, -Inf});
% Normalize variables before analysis
calPred = normalize(preNormPredictors);
calOut = normalize(output(:,2:end));
calPred = calPred(:, sum(isnan(table2array(calPred))) < 100);

scoreStruct = struct();
CalSimPredictors = struct();
variables = ["C_KSWCK", "C_SAC287", "C_SAC269", "C_SAC257", "C_SAC247", ...
    "C_SAC240", "C_SAC217", "C_SAC207", "C_SAC193", "C_SAC185", "C_SAC169",...
    "C_SAC159", "C_SAC148", "C_SAC122", "C_SAC120", "C_SAC093", "C_SAC083",...
    "SP_SAC083_YBP037", "C_SAC075", "C_SAC065", "C_YBP002", "C_CSL004B",...
    "C_SAC063", "C_SAC062", "C_SAC041", "C_SAC029A", "C_SAC022", "C_SAC007",...
    "DXC", "C_SAC000", "D_OMR027_CAA000", "D_OMR028_DMC000",...
    "C_CLV004", "C_MOK022", "X2_WHLJPOD_EST_", "S_SLUIS_CVP", "S_SLUIS_SWP",...
    "CVPRULECV", "SWPRULECV"];

%load("CalSimPredictors.mat", "CalSimPredictors");
%load('modelInputScoring.mat', 'scoreStruct');
%load('CalSimMLVariables.mat', 'variables');

shstaVariables = ["I_SHSTA", "S_SHSTA"];
trntyVariables = ["I_TRNTY", "S_TRNTY"];
wkytnVariables = cat(2, ["I_LWSTN", "I_WKYTN", "S_WKYTN"], trntyVariables);
kswckRunoff = ["SR_02", "SR_03"];
kswckVariables = cat(2, kswckRunoff, cat(2, wkytnVariables, shstaVariables));
almnrVariables = ["I_MTMDW", "I_ALMNR", "S_ALMNR"];
orovlVariables = cat(2, ["I_OROVL", "I_MFF019", "I_NFF027", "I_NFF029",...
    "I_EBF001", "S_OROVL"], almnrVariables);
nbldbVariables = ["I_NFY029", "S_NBLDB", "I_SLTSP"];
echolVariables = ["I_ECHOL", "S_ECHOL"];
hholeVariables = ["I_HHOLE", "S_HHOLE", "I_RUB047", "I_LRB004"];
folsmVariables = cat(2, ["I_FOLSM", "S_FOLSM", "I_NFA054", "I_MFA001", "I_MFA025", "I_MFA036"],...
    echolVariables, hholeVariables);
mlrtnVariables = ["I_MLRTN", "S_MLRTN"];
sluisVariables = ["I_SLUIS", "S_SLUIS_CVP", "S_SLUIS_SWP"];
nhganVariables = ["I_NHGAN", "S_NHGAN"];
melonVariables = ["I_MELON_FCST", "I_STS072", "S_MELON", "I_ANG017", "I_MIL003", "I_SPICE", "I_BVC007", "I_BEARD", "I_DONLL", "I_CFS001", "I_RLIEF", "I_SFS030", "I_LYONS", "I_PCRST"];
% melonPrefixes = ["I_NFS", "I_MFS"];
htchyVariables = ["I_HTCHY"];

pedroVariables = cat(2, ["S_PEDRO", "I_PEDRO", "I_LLOYD"], htchyVariables);
estmnVariables = ["S_ESTMN", "I_ESTMN"];

clrlkVariables = ["S_CLRLK", "I_CLRLK"];
losvqVariables = ["S_LOSVQ", "I_LOSVQ"];

% upper SAC <- SHSTA, KSWCK, TRNTY
upperSacVariables = kswckVariables;
sac287Variables = cat(2, upperSacVariables, ["I_CLR011"]);
sac269Variables = cat(2, sac287Variables, ["I_COW014", "I_BTL006", "I_CWD018"]);
sac217Variables = cat(2, ["SR_04", "SR_05"], sac269Variables);
sac207Variables = cat(2, ["I_MNS000"], sac217Variables);
sac196Variables = cat(2, ["SR_10"], sac207Variables);
sac185Variables = cat(2, ["SR_06", "SR_07N", "SR_08N", "SR_09"], sac196Variables);
sac146Variables = cat(2, ["SR_08S"], sac185Variables);
sac093Variables = cat(2, ["SR_07S"], sac146Variables);

sac083Variables = cat(2,  ["I_NBLDB", "I_BTC048", "SR_11", "SR_12", "SR_13", "SR_14", "SR_15N", "SR_15S", "SR_16", "SR_17N", "SR_17S", "SR_18", "SR_19"], sac093Variables, orovlVariables, nbldbVariables);
brysaVariables = ["S_BRYSA", "I_PTH070"]; % Diagram says this should be I_BRYSA, but that doesn't exist in the inputs
ybpSpecific = cat(2, clrlkVariables, brysaVariables, ["SR_20", "SR_21", "SR_25", "I_PTH070"]);
ybpVariables = cat(2, ybpSpecific, sac083Variables);

sac082Variables = cat(2, ["SR_22", "SR_23", "SR_24", "SR_26N"], sac083Variables);

sac063Variables = cat(2, ["SR_26S"], sac082Variables, folsmVariables);

pardeVariables = ["S_PARDE", "I_PARDE", "I_MOK079", "I_SFM005", "I_MFM008", "I_NFM006"];
cmcheVariables = cat(2, pardeVariables, ["S_CMCHE", "I_CMCHE"]);
mokVariables = cat(2, cmcheVariables, [ "SR_60N"]);
lowerMokVariables = cat(2, ["I_MOK019B", "I_MOK019A", "I_CSM035"], mokVariables);

mclreVariables = ["S_MCLRE", "I_MCLRE"];
% The below exist according to the schematic pdf, but not according to the
% sv files I'm using for training.
%, "I_MCD080", "I_MCD096", "I_MCD119", "I_MCD128", "I_MSF001", "I_MSF023"];

sjrInflows = ["SR_60S", "SR_61", "SR_62", "SR_63", "SR_64", "SR_71", "SR_72", "SR_73"];
sjrVariables = cat(2, mlrtnVariables, sluisVariables, melonVariables, sjrInflows, pedroVariables, estmnVariables, losvqVariables, mclreVariables);

projectVariables = ["swpcapacity", "cvpcapacity"];

clvVariables = cat(2, ["I_CLV026"], nhganVariables);

others = ["X2_WHLJPOD_EST_"];

 testingVars = ["S_HNSLY", "I_HNSLY"];

allPredictors = cat(2, sac063Variables, ybpSpecific, sjrVariables, projectVariables, lowerMokVariables, clvVariables, others, testingVars);

allPredictors = AddLargestByPrefixIfMissing(allPredictors, preNormPredictors, "I_", 40, []);
allPredictors = AddLargestByPrefixIfMissing(allPredictors, preNormPredictors, "S_", 20, ["S_SLUIS", "S_UPPERFEATHER", "S_UNVLY", "S_ADJCLRLK", "S_EBTML"]);
allPredictors = AddLargestByPrefixIfMissing(allPredictors, preNormPredictors, "AW", 20, []);

[scoreStruct, CalSimPredictors] = AnalyzeVariable(slurm, scoreStruct, CalSimPredictors, calPred, ...
    clvVariables, calOut, ...
    'C_CLV004', 15, false, 'Exponential');

[scoreStruct, CalSimPredictors] = AnalyzeVariable(slurm, scoreStruct, CalSimPredictors, calPred, ...
    mokVariables, calOut, ...
    'C_MOK022', 15, false, 'ARDExponential');

% UPPER SAC
[scoreStruct, CalSimPredictors] = AnalyzeVariable(slurm, scoreStruct, CalSimPredictors, calPred, ...
    kswckVariables, calOut, ...
    'C_KSWCK', 15, false, 'Exponential');

[scoreStruct, CalSimPredictors] = AnalyzeVariable(slurm, scoreStruct, CalSimPredictors, calPred, ...
    sac287Variables, calOut, ...
    'C_SAC287', 15, false, 'Exponential');

[scoreStruct, CalSimPredictors] = AnalyzeVariable(slurm, scoreStruct, CalSimPredictors, calPred, ...
    sac269Variables, calOut, ...
    'C_SAC269', 15, false, 'ARDExponential');

[scoreStruct, CalSimPredictors] = AnalyzeVariable(slurm, scoreStruct, CalSimPredictors, calPred, ...
    sac269Variables, calOut, ...
    'C_SAC257', 15, false, 'Exponential');

[scoreStruct, CalSimPredictors] = AnalyzeVariable(slurm, scoreStruct, CalSimPredictors, calPred, ...
    sac269Variables, calOut, ...
    'C_SAC247', 15, false, 'Exponential');

[scoreStruct, CalSimPredictors] = AnalyzeVariable(slurm, scoreStruct, CalSimPredictors, calPred, ...
    sac269Variables, calOut, ...
    'C_SAC240', 15, false, 'Exponential');

[scoreStruct, CalSimPredictors] = AnalyzeVariable(slurm, scoreStruct, CalSimPredictors, calPred, ...
    sac217Variables, calOut, ...
    'C_SAC217', 15, false, 'Exponential');

[scoreStruct, CalSimPredictors] = AnalyzeVariable(slurm, scoreStruct, CalSimPredictors, calPred, ...
    sac207Variables, calOut, ...
    'C_SAC207', 15, false, 'Exponential');

[scoreStruct, CalSimPredictors] = AnalyzeVariable(slurm, scoreStruct, CalSimPredictors, calPred, ...
    sac196Variables, calOut, ...
    'C_SAC193', 15, false, 'ARDExponential');

[scoreStruct, CalSimPredictors] = AnalyzeVariable(slurm, scoreStruct, CalSimPredictors, calPred, ...
    sac185Variables, calOut, ...
    'C_SAC185', 15, false, 'ARDExponential');

[scoreStruct, CalSimPredictors] = AnalyzeVariable(slurm, scoreStruct, CalSimPredictors, calPred, ...
    sac185Variables, calOut, ...
    'C_SAC169', 15, false, 'ARDExponential');

[scoreStruct, CalSimPredictors] = AnalyzeVariable(slurm, scoreStruct, CalSimPredictors, calPred, ...
    sac185Variables, calOut, ...
    'C_SAC159', 15, false, 'ARDExponential');

[scoreStruct, CalSimPredictors] = AnalyzeVariable(slurm, scoreStruct, CalSimPredictors, calPred, ...
    sac185Variables, calOut, ...
    'C_SAC148', 15, false, 'ARDRationalQuadratic');

[scoreStruct, CalSimPredictors] = AnalyzeVariable(slurm, scoreStruct, CalSimPredictors, calPred, ...
    sac146Variables, calOut, ...
    'C_SAC122', 15, false, 'Exponential');

[scoreStruct, CalSimPredictors] = AnalyzeVariable(slurm, scoreStruct, CalSimPredictors, calPred, ...
    sac146Variables, calOut, ...
    'C_SAC120', 15, false, 'ARDExponential');

[scoreStruct, CalSimPredictors] = AnalyzeVariable(slurm, scoreStruct, CalSimPredictors, calPred, ...
    sac093Variables, calOut, ...
    'C_SAC093', 15, false, 'ARDExponential');


% MIDDLE SAC
[scoreStruct, CalSimPredictors] = AnalyzeVariable(slurm, scoreStruct, CalSimPredictors, calPred, ...
    sac083Variables, calOut, ...
    'C_SAC083', 15, false, 'Exponential');

[scoreStruct, CalSimPredictors] = AnalyzeVariable(slurm, scoreStruct, CalSimPredictors, calPred, ...
    sac083Variables, calOut, ...
    'SP_SAC083_YBP037', 15, false, 'Matern32');

[scoreStruct, CalSimPredictors] = AnalyzeVariable(slurm, scoreStruct, CalSimPredictors, calPred, ...
    sac082Variables, calOut, ...
    'C_SAC075', 15, false, 'Matern32');

[scoreStruct, CalSimPredictors] = AnalyzeVariable(slurm, scoreStruct, CalSimPredictors, calPred, ...
    sac082Variables, calOut, ...
    'C_SAC065', 15, false, 'ARDExponential');

[scoreStruct, CalSimPredictors] = AnalyzeVariable(slurm, scoreStruct, CalSimPredictors, calPred, ...
    ybpVariables, calOut, ...
    'C_YBP002', 15, false, 'Matern32');

[scoreStruct, CalSimPredictors] = AnalyzeVariable(slurm, scoreStruct, CalSimPredictors, calPred, ...
    ybpVariables, calOut, ...
    'C_CSL004B', 15, false, 'ARDMatern32');


% LOWER SAC
[scoreStruct, CalSimPredictors] = AnalyzeVariable(slurm, scoreStruct, CalSimPredictors, calPred, ...
    sac063Variables, calOut, ...
    'C_SAC063', 15, false, 'ARDExponential');

[scoreStruct, CalSimPredictors] = AnalyzeVariable(slurm, scoreStruct, CalSimPredictors, calPred, ...
    sac063Variables, calOut, ...
    'C_SAC062', 15, false, 'Exponential');


% CROSS CHANNEL SAC
[scoreStruct, CalSimPredictors] = AnalyzeVariable(slurm, scoreStruct, CalSimPredictors, calPred, ...
    allPredictors, calOut, ...
    'C_SAC041', 20, false, 'Exponential');

[scoreStruct, CalSimPredictors] = AnalyzeVariable(slurm, scoreStruct, CalSimPredictors, calPred, ...
    cat(2, allPredictors, "MONTH_DAYS"), calOut, ...
    'DXC', 20, false, 'Exponential');

[scoreStruct, CalSimPredictors] = AnalyzeVariable(slurm, scoreStruct, CalSimPredictors, calPred, ...
    allPredictors, calOut, ...
    'C_SAC029A', 20, false, 'ARDExponential');

[scoreStruct, CalSimPredictors] = AnalyzeVariable(slurm, scoreStruct, CalSimPredictors, calPred, ...
    allPredictors, calOut, ...
    'C_SAC022', 20, false, 'Matern32');

[scoreStruct, CalSimPredictors] = AnalyzeVariable(slurm, scoreStruct, CalSimPredictors, calPred, ...
    allPredictors, calOut, ...
    'C_SAC007', 20, false, 'ARDExponential');


% SJR variables moved up to lower sac to be used as inputs for cross
% channel gate/pumping
[scoreStruct, CalSimPredictors] = AnalyzeVariable(slurm, scoreStruct, CalSimPredictors, calPred, ...
    allPredictors, calOut, ...
    'C_SAC000', 20, false, 'ARDMatern32');

[scoreStruct, CalSimPredictors] = AnalyzeVariable(slurm, scoreStruct, CalSimPredictors, calPred, ...
    allPredictors, calOut, ...
    'X2_WHLJPOD_EST_', 20, false, 'Matern32');


% South Delta Variables
% commenting this out- trying to predict these diversions with whole system
% knowledge instead.
% predictors = makePredictors(sjrVariables, calPred);
% Add in swp and cvp here for the OMR diversions
[scoreStruct, CalSimPredictors] = AnalyzeVariable(slurm, scoreStruct, CalSimPredictors, calPred, ...
    allPredictors, calOut, ...
    'D_OMR028_DMC000', 20, false, 'RationalQuadratic');


% This is Clifton Court Forebay which is big pumps for SWP
[scoreStruct, CalSimPredictors] = AnalyzeVariable(slurm, scoreStruct, CalSimPredictors, calPred, ...
    allPredictors, calOut, ...
    'D_OMR027_CAA000', 20, false, 'Exponential');

% Since these might pull in other storage, add them here.
[scoreStruct, CalSimPredictors] = AnalyzeVariable(slurm, scoreStruct, CalSimPredictors, calPred, ...
    allPredictors, calOut, ...
    'S_SLUIS_CVP', 20, false, 'ARDExponential');

[scoreStruct, CalSimPredictors] = AnalyzeVariable(slurm, scoreStruct, CalSimPredictors, calPred, ...
    allPredictors, calOut, ...
    'S_SLUIS_SWP', 20, false, 'Exponential');

[scoreStruct, CalSimPredictors] = AnalyzeVariable(slurm, scoreStruct, CalSimPredictors, calPred, ...
    allPredictors, calOut, ...
    'CVPRULECV', 20, false, 'ARDExponential');

[scoreStruct, CalSimPredictors] = AnalyzeVariable(slurm, scoreStruct, CalSimPredictors, calPred, ...
    allPredictors, calOut, ...
    'SWPRULECV', 20, false, 'Exponential');

%storageUsed = FindPredictorsWithPrefix(CalSimPredictors, variables, "S_");
% For now just say all of the storage is used.
storageUsed = {};
storageUsed = AddPrefixIfMissing(storageUsed, calPred, "S_");

% Storage Variables
[scoreStruct, CalSimPredictors] = AnalyzeVariableIfUsed(slurm, scoreStruct, CalSimPredictors, calPred, ...
    shstaVariables, calOut, ...
    'S_SHSTA', storageUsed, 15, false, 'ARDExponential');

[scoreStruct, CalSimPredictors] = AnalyzeVariableIfUsed(slurm, scoreStruct, CalSimPredictors, calPred, ...
    trntyVariables, calOut, ...
    'S_TRNTY', storageUsed, 15, false, 'Exponential');

[scoreStruct, CalSimPredictors] = AnalyzeVariableIfUsed(slurm, scoreStruct, CalSimPredictors, calPred, ...
    wkytnVariables, calOut, ...
    'S_WKYTN', storageUsed, 15, false, 'Exponential');

[scoreStruct, CalSimPredictors] = AnalyzeVariableIfUsed(slurm, scoreStruct, CalSimPredictors, calPred, ...
    almnrVariables, calOut, ...
    'S_ALMNR', storageUsed, 15, false, 'ARDMatern32');

[scoreStruct, CalSimPredictors] = AnalyzeVariableIfUsed(slurm, scoreStruct, CalSimPredictors, calPred, ...
    orovlVariables, calOut, ...
    'S_OROVL', storageUsed, 15, false, 'Exponential');

[scoreStruct, CalSimPredictors] = AnalyzeVariableIfUsed(slurm, scoreStruct, CalSimPredictors, calPred, ...
    nbldbVariables, calOut, ...
    'S_NBLDB', storageUsed, 15, false, 'ARDExponential');

[scoreStruct, CalSimPredictors] = AnalyzeVariableIfUsed(slurm, scoreStruct, CalSimPredictors, calPred, ...
    echolVariables, calOut, ...
    'S_ECHOL', storageUsed, 15, false, 'Matern52');

[scoreStruct, CalSimPredictors] = AnalyzeVariableIfUsed(slurm, scoreStruct, CalSimPredictors, calPred, ...
    hholeVariables, calOut, ...
    'S_HHOLE', storageUsed, 15, false, 'Exponential');

[scoreStruct, CalSimPredictors] = AnalyzeVariableIfUsed(slurm, scoreStruct, CalSimPredictors, calPred, ...
    folsmVariables, calOut, ...
    'S_FOLSM', storageUsed, 15, false, 'Exponential');

[scoreStruct, CalSimPredictors] = AnalyzeVariableIfUsed(slurm, scoreStruct, CalSimPredictors, calPred, ...
    mlrtnVariables, calOut, ...
    'S_MLRTN', storageUsed, 15, false, 'ARDExponential');

[scoreStruct, CalSimPredictors] = AnalyzeVariableIfUsed(slurm, scoreStruct, CalSimPredictors, calPred, ...
    nhganVariables, calOut, ...
    'S_NHGAN', storageUsed, 15, false, 'Exponential');

[scoreStruct, CalSimPredictors] = AnalyzeVariableIfUsed(slurm, scoreStruct, CalSimPredictors, calPred, ...
    melonVariables, calOut, ...
    'S_MELON', storageUsed, 15, false, 'squaredexponential');

[scoreStruct, CalSimPredictors] = AnalyzeVariableIfUsed(slurm, scoreStruct, CalSimPredictors, calPred, ...
    pedroVariables, calOut, ...
    'S_PEDRO', storageUsed, 15, false, 'ARDExponential');

[scoreStruct, CalSimPredictors] = AnalyzeVariableIfUsed(slurm, scoreStruct, CalSimPredictors, calPred, ...
    estmnVariables, calOut, ...
    'S_ESTMN', storageUsed, 15, false, 'squaredexponential');

[scoreStruct, CalSimPredictors] = AnalyzeVariableIfUsed(slurm, scoreStruct, CalSimPredictors, calPred, ...
    clrlkVariables, calOut, ...
    'S_CLRLK', storageUsed, 15, false, 'ARDRationalQuadratic');

[scoreStruct, CalSimPredictors] = AnalyzeVariableIfUsed(slurm, scoreStruct, CalSimPredictors, calPred, ...
    cmcheVariables, calOut, ...
    'S_CMCHE', storageUsed, 15, false, 'Exponential');

[scoreStruct, CalSimPredictors] = AnalyzeVariableIfUsed(slurm, scoreStruct, CalSimPredictors, calPred, ...
    pardeVariables, calOut, ...
    'S_PARDE', storageUsed, 15, false, 'Exponential');

[scoreStruct, CalSimPredictors] = AnalyzeVariableIfUsed(slurm, scoreStruct, CalSimPredictors, calPred, ...
    losvqVariables, calOut, ...
    'S_LOSVQ', storageUsed, 15, false, 'ARDRationalQuadratic');

[scoreStruct, CalSimPredictors] = AnalyzeVariableIfUsed(slurm, scoreStruct, CalSimPredictors, calPred, ...
    mclreVariables, calOut, ...
    'S_MCLRE', storageUsed, 15, false, 'ARDRationalQuadratic');

[scoreStruct, CalSimPredictors] = AnalyzeVariableIfUsed(slurm, scoreStruct, CalSimPredictors, calPred, ...
    brysaVariables, calOut, ...
    'S_BRYSA', storageUsed, 15, false, 'ARDRationalQuadratic');

variables = unique(cat(2, variables, storageUsed));

save("CalSimPredictors.mat", "CalSimPredictors");
save('modelInputScoring.mat', 'scoreStruct');
save('CalSimMLVariables.mat', 'variables');

% newStorage = FindPredictorsWithPrefix(CalSimPredictors, variables, "S_");
% 
% for storage = newStorage 
%     if ~any(strcmp(variables,storage))
%         disp(storage + ": Warning storage used that doesn't have selected predictors. Added as predictor for other storage.")
%     end
% end
end

function [scoreStruct, CalSimPredictors] = AnalyzeVariable(slurm, scoreStruct, ...
    CalSimPredictors, calPred, predictors, output, varName, predictorCount,...
    indepthSelection, kernelfcn)
    varName

    % this is the default value, and many of the other options take
    % significantly longer to to feature selection with (particularlt the
    % 'ard' options). Trying the simpler default to see if we can do
    % feature selection in a reasonable time frame.
    kernelfcn = 'squaredexponential';

    % Globally relevant values, added here to all rather than including in
    % the above lists.
    predictors = AddIfMissing(predictors, "eiRatio");
    predictors = AddIfMissing(predictors, "month");
    predictors = AddIfMissing(predictors, "demand_demand");
    predictors = AddIfMissing(predictors, "demand_summ");
    predictors = AddIfMissing(predictors, "swpcapacity");
    predictors = AddIfMissing(predictors, "cvpcapacity");
    predictors = AddIfMissing(predictors, "X2_WHLJPOD_EST_");
    predictors = AddIfMissing(predictors, "CVPRULECV");
    predictors = AddIfMissing(predictors, "SWPRULECV");

    %future = parfeval(@SlurmSelectPredictors, 0, varName, calPred, predictors, output.(varName), predictorCount, false, kernelfcn);
    %future = batch(@SlurmSelectPredictors, 0, {varName, calPred, predictors, output.(varName), predictorCount, false, kernelfcn});
    % Predictor variable analysis
    if (slurm) 
        [predictors, scoreStruct] = SlurmSelectPredictors(varName, calPred, predictors, output.(varName), predictorCount, scoreStruct, true, kernelfcn);
        CalSimPredictors.(varName) = predictors;
    else
        [predictors, scoreStruct] = SelectPredictors(varName, calPred, predictors, output.(varName), predictorCount, scoreStruct, indepthSelection, kernelfcn);
        CalSimPredictors.(varName) = predictors;
    end
    predictors
end

function [predictors, scoreStruct] = SlurmSelectPredictors(varName, calPred, predictors, target, predictorCount, scoreStruct, indepthSelection, kernelfcn)
    disp("starting " + varName)
    if (isfile(strcat("/hb/scratch/cpjohn/LCM_ML/out/", varName, '_predictors.mat')) && isfile(strcat("/hb/scratch/cpjohn/LCM_ML/out/", varName, '_scoreStruct.mat')))
        load(strcat("/hb/scratch/cpjohn/LCM_ML/out/", varName, '_predictors.mat'), 'predictors');
        load(strcat("/hb/scratch/cpjohn/LCM_ML/out/", varName, '_scoreStruct.mat'), 'scoreStruct');
        disp("loaded " + varName)
    else
        [predictors, scoreStruct] = SelectPredictors(varName, calPred, predictors, target, predictorCount, scoreStruct, indepthSelection, kernelfcn);
        save(strcat("/hb/scratch/cpjohn/LCM_ML/out/", varName, '_predictors.mat'), 'predictors');
        save(strcat("/hb/scratch/cpjohn/LCM_ML/out/", varName, '_scoreStruct.mat'), 'scoreStruct');
        disp("finished " + varName)
    end
end

function [scoreStruct, CalSimPredictors] = AnalyzeVariableIfUsed(slurm, scoreStruct, ...
    CalSimPredictors, calPred, predictors, output, varName, ...
    storageUsedList, predictorCount, indepthSelection, kernelfcn)
    if any(strcmp(storageUsedList,varName)) || slurm
        [scoreStruct, CalSimPredictors] = AnalyzeVariable(slurm, scoreStruct, CalSimPredictors, calPred, ...
            predictors, output, varName, predictorCount, indepthSelection, kernelfcn);
    end
end

function predictors = AddIfMissing(predictors, toAdd)
    if ~any(strcmp(predictors, toAdd))
        predictors(end+1) = toAdd;
    end
end

function predictors = AddPrefixIfMissing(predictors, calPred, prefix)
    for name = calPred.Properties.VariableNames
        if ~any(strcmp(predictors, name)) && startsWith(name,prefix)
            predictors(end+1) = name;
        end
    end
end

function predictors = AddLargestByPrefixIfMissing(predictors, preNormPredictors, prefix, count, excluded)
    matches = {};
    for name = preNormPredictors.Properties.VariableNames
        if startsWith(name,prefix)
            new_value = true;
            if any(strcmp(excluded, name))
                continue
            end
            for predictor = predictors
                if startsWith(name, predictor) && name ~= predictor
                    new_value = false;
                    break
                end
            end
            if (new_value)
                matches(end+1) = name;
            end
        end
    end
    magnitudes = sum(table2array(preNormPredictors(:,matches)), 'omitnan');
    [~, indicies] = maxk(magnitudes, count);
    for index = indicies
        name = matches(index);
        if ~any(strcmp(predictors, name))
            predictors(end+1) = name;
        end
    end
end

function matches = FindPredictorsWithPrefix(CalSimPredictors, variables, prefix)
    matches = {};
    for variable = variables
        if (isfield(CalSimPredictors, variable))
            for name = CalSimPredictors.(variable)
                if startsWith(name,prefix) && ~any(strcmp(matches, name))
                    matches(end+1) = cellstr(name);
                end
            end
        end
    end
end

%% Helper function to see what variables had predictors change between runs.
function variables = DiffPredictors(CalSimPredictors, CalSimPredictors_PreChanges, variables)
    toPredict = [];
    for variable = variables
        if ~isfield(CalSimPredictors, variable) || ~isfield(CalSimPredictors_PreChanges, variable)
            disp(variable)
            toPredict = [toPredict variable];
        elseif length(setdiff(CalSimPredictors.(variable), CalSimPredictors_PreChanges.(variable))) > 0
            disp(variable)
            toPredict = [toPredict variable];
        end
    end
end
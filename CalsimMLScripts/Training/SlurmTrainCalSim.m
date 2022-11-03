function [] = SlurmTrainCalSim()
    % create a local cluster object
    pc = parcluster('local')
    pool = parpool(pc, str2num(getenv('SLURM_CPUS_ON_NODE')))

    [nddoff2020, outnddoff2020] = PrepareCalSimScenario("/hb/home/cpjohn/LCM_ML/Calsim_SV/0_DCR19_12.30_120621_NDDOff_2020.csv", GetConfig(0), "/hb/home/cpjohn/LCM_ML/Calsim_dss/0_DCR19_12.30_120621_NDDOff_2020.dss.csv", "/hb/home/cpjohn/LCM_ML/Calsim_dss_used/0_DCR19_12.30_120621_NDDOff_2020.dss.csv");
    [nddoff2040, outnddoff2040 ] = PrepareCalSimScenario("/hb/home/cpjohn/LCM_ML/Calsim_SV/0_DCR19_12.30_122021_NDDOff_2040CT.csv", GetConfig(0), "/hb/home/cpjohn/LCM_ML/Calsim_dss/0_DCR19_12.30_122021_NDDOff_2040CT.dss.csv", "/hb/home/cpjohn/LCM_ML/Calsim_dss_used/0_DCR19_12.30_122021_NDDOff_2040CT.dss.csv");
    [nddswp30002020, outnddswp30002020] = PrepareCalSimScenario("/hb/home/cpjohn/LCM_ML/Calsim_SV/1_DCR19_12.30_120621_NDD_SWP3000_2020.csv", GetConfig(1), "/hb/home/cpjohn/LCM_ML/Calsim_dss/1_DCR19_12.30_120621_NDD_SWP3000_2020.dss.csv", "/hb/home/cpjohn/LCM_ML/Calsim_dss_used/1_DCR19_12.30_120621_NDD_SWP3000_2020.dss.csv");
    [nddswp30002040, outnddswp30002040] = PrepareCalSimScenario("/hb/home/cpjohn/LCM_ML/Calsim_SV/1_DCR19_12.30_122021_NDD_SWP3000_2040CT.csv", GetConfig(1), "/hb/home/cpjohn/LCM_ML/Calsim_dss/1_DCR19_12.30_122021_NDD_SWP3000_2040CT.dss.csv", "/hb/home/cpjohn/LCM_ML/Calsim_dss_used/1_DCR19_12.30_122021_NDD_SWP3000_2040CT.dss.csv");
    [nddswp45002020, outnddswp45002020] = PrepareCalSimScenario("/hb/home/cpjohn/LCM_ML/Calsim_SV/2_DCR19_12.30_120621_NDD_SWP4500_2020.csv", GetConfig(2), "/hb/home/cpjohn/LCM_ML/Calsim_dss/2_DCR19_12.30_120621_NDD_SWP4500_2020.dss.csv", "/hb/home/cpjohn/LCM_ML/Calsim_dss_used/2_DCR19_12.30_120621_NDD_SWP4500_2020.dss.csv");
    [nddswp45002040, outnddswp45002040] = PrepareCalSimScenario("/hb/home/cpjohn/LCM_ML/Calsim_SV/2_DCR19_12.30_122021_NDD_SWP4500_2040CT.csv", GetConfig(2), "/hb/home/cpjohn/LCM_ML/Calsim_dss/2_DCR19_12.30_122021_NDD_SWP4500_2040CT.dss.csv", "/hb/home/cpjohn/LCM_ML/Calsim_dss_used/2_DCR19_12.30_122021_NDD_SWP4500_2040CT.dss.csv");
    [nddswp60002020, outnddswp60002020] = PrepareCalSimScenario("/hb/home/cpjohn/LCM_ML/Calsim_SV/3_DCR19_12.30_120621_NDD_SWP6000_2020.csv", GetConfig(3), "/hb/home/cpjohn/LCM_ML/Calsim_dss/3_DCR19_12.30_120621_NDD_SWP6000_2020.dss.csv", "/hb/home/cpjohn/LCM_ML/Calsim_dss_used/3_DCR19_12.30_120621_NDD_SWP6000_2020.dss.csv");
    [nddswp60002040, outnddswp60002040 ] = PrepareCalSimScenario("/hb/home/cpjohn/LCM_ML/Calsim_SV/3_DCR19_12.30_122021_NDD_SWP6000_2040CT.csv", GetConfig(3), "/hb/home/cpjohn/LCM_ML/Calsim_dss/3_DCR19_12.30_122021_NDD_SWP6000_2040CT.dss.csv", "/hb/home/cpjohn/LCM_ML/Calsim_dss_used/3_DCR19_12.30_122021_NDD_SWP6000_2040CT.dss.csv");
    [nddswp6000Beth2020, outnddswp6000Beth2020 ] = PrepareCalSimScenario("/hb/home/cpjohn/LCM_ML/Calsim_SV/4_DCR19_12.30_120621_NDD_SWP6000_Beth_2020.csv", GetConfig(4), "/hb/home/cpjohn/LCM_ML/Calsim_dss/4_DCR19_12.30_120621_NDD_SWP6000_Beth_2020.dss.csv", "/hb/home/cpjohn/LCM_ML/Calsim_dss_used/4_DCR19_12.30_120621_NDD_SWP6000_Beth_2020.dss.csv");
    [nddswp6000Beth2040, outnddswp6000Beth2040] = PrepareCalSimScenario("/hb/home/cpjohn/LCM_ML/Calsim_SV/4_DCR19_12.30_122021_NDD_SWP6000_Beth_2040CT.csv", GetConfig(4), "/hb/home/cpjohn/LCM_ML/Calsim_dss/4_DCR19_12.30_122021_NDD_SWP6000_Beth_2040CT.dss.csv", "/hb/home/cpjohn/LCM_ML/Calsim_dss_used/4_DCR19_12.30_122021_NDD_SWP6000_Beth_2040CT.dss.csv");
    [nddswp6000CVP2020, outnddswp6000CVP2020 ] = PrepareCalSimScenario("/hb/home/cpjohn/LCM_ML/Calsim_SV/5_DCR19_12.30_120621_NDD_SWP6000_CVP1500_2020.csv", GetConfig(5), "/hb/home/cpjohn/LCM_ML/Calsim_dss/5_DCR19_12.30_120621_NDD_SWP6000_CVP1500_2020.dss.csv", "/hb/home/cpjohn/LCM_ML/Calsim_dss_used/5_DCR19_12.30_120621_NDD_SWP6000_CVP1500_2020.dss.csv");
    [nddswp6000CVP2040, outnddswp6000CVP2040 ]= PrepareCalSimScenario("/hb/home/cpjohn/LCM_ML/Calsim_SV/5_DCR19_12.30_122021_NDD_SWP6000_CVP1500_2040CT.csv", GetConfig(5), "/hb/home/cpjohn/LCM_ML/Calsim_dss/5_DCR19_12.30_122021_NDD_SWP6000_CVP1500_2040CT.dss.csv", "/hb/home/cpjohn/LCM_ML/Calsim_dss_used/5_DCR19_12.30_122021_NDD_SWP6000_CVP1500_2040CT.dss.csv");

    pred = [nddoff2020;nddoff2040;nddswp30002020;nddswp30002040;nddswp45002020;nddswp45002040;nddswp60002020;nddswp60002040;nddswp6000Beth2020;nddswp6000Beth2040;nddswp6000CVP2020;nddswp6000CVP2040];
    out = [outnddoff2020;outnddoff2040;outnddswp30002020;outnddswp30002040;outnddswp45002020;outnddswp45002040;outnddswp60002020;outnddswp60002040;outnddswp6000Beth2020;outnddswp6000Beth2040;outnddswp6000CVP2020;outnddswp6000CVP2040];
    
    randomOrder = randperm(height(pred));
    pred = pred(randomOrder,:);
    out = out(randomOrder,:);

    % Slurm should already have the predictors selected, what this does is
    % use use the saved individual files to load up the results and return
    % it the way the trainer code expects it to be structured.
    [scoreStruct, CalSimPredictors, variables] = PredictorSelection(pred, out, false);
    
    CalSimModels = CalSimModelTrainer(CalSimPredictors, pred, out, variables, true);
end

function [pred, out] = PrepareCalSimScenario(SVPath, ConfigParams, DSSFull, DSSUsed)

SV = readtable(SVPath);

dss = readtable(DSSFull);

% predictors
% for each timestep: sv values for that time, config params, dssout for
% previous time (what to do for time 0?
pred = SV;
dateSplit = split(string(pred.Var1), '-');

varName = dss.Properties.VariableNames;
for i = 1:length(varName)
    if isdatetime(dss.(varName{i})) == 1
        pred.(varName{i})(1) = NaT;
    else
        pred.(varName{i})(1) = NaN;
    end
    pred.(varName{i})(2:end) = dss.(varName{i})(1:end-1);
end

pred.swpcapacity = repmat(ConfigParams.swpcapacity,height(pred),1);
pred.cvpcapacity = repmat(ConfigParams.cvpcapacity,height(pred),1);
pred.user1 = repmat(ConfigParams.user1,height(pred),1);
pred.user2 = repmat(ConfigParams.user2,height(pred),1);
pred.source1 = repmat(ConfigParams.source1,height(pred),1);
pred.source2 = repmat(ConfigParams.source2,height(pred),1);
pred.source3 = repmat(ConfigParams.source3,height(pred),1);
pred.source4 = repmat(ConfigParams.source4,height(pred),1);
pred.source5 = repmat(ConfigParams.source5,height(pred),1);

pred.month = str2double(dateSplit(:,2));

eiRatio = [0.65, 0.65, 0.65, 0.65, 0.00, 0.35, 0.35, 0.35, 0.35, 0.65, 0.65, 0.65];

% Add demand table here (same across scenarios) might have monthly effect-
% check in predictor selection
demand_demand = [1.891, 3.111, 1.138, 1.015, 0.324, 0.566, 1.363, 1.434, 0.630, 1.452, 2.388, 1.975];
demand_summ = [1.891, 5.002,6.140,7.155,7.479,8.045,9.408,10.842,11.472,12.924,15.312,17.287];

pred.eiRatio = eiRatio(pred.month)';
pred.demand_demand = demand_demand(pred.month)';
pred.demand_summ = demand_summ(pred.month)';

% out
% dssout for the current time
out = readtable(DSSUsed);

end
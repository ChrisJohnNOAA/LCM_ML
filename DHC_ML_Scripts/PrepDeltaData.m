function [deltaData] = PrepDeltaData()

    deltanddoff2020 = PrepScenario("D:\GitHub\LCM_ML\Calsim_delta_dss\0_DCR19_12.30_120621_NDDOff_2020.dss.csv", "D:\GitHub\LCM_ML\DHC_output\NDDOff_2020\Delta_Capacity95_NoMask_NDDOff_2020.xlsx");
    deltanddoff2040 = PrepScenario("D:\GitHub\LCM_ML\Calsim_delta_dss\0_DCR19_12.30_122021_NDDOff_2040CT.dss.csv", "D:\GitHub\LCM_ML\DHC_output\NDDOff_2040CT\Delta_Capacity95_NoMask_NDDOff_2040CT.xlsx");
    deltanddswp30002020 = PrepScenario("D:\GitHub\LCM_ML\Calsim_delta_dss\1_DCR19_12.30_120621_NDD_SWP3000_2020.dss.csv", "D:\GitHub\LCM_ML\DHC_output\NDD_SWP3000_2020\Delta_Capacity95_NoMask_NDD_SWP3000_2020.xlsx");
    deltanddswp30002040 = PrepScenario("D:\GitHub\LCM_ML\Calsim_delta_dss\1_DCR19_12.30_122021_NDD_SWP3000_2040CT.dss.csv", "D:\GitHub\LCM_ML\DHC_output\NDD_SWP3000_2040CT\Delta_Capacity95_NoMask_NDD_SWP3000_2040CT.xlsx");
    deltanddswp45002020 = PrepScenario("D:\GitHub\LCM_ML\Calsim_delta_dss\2_DCR19_12.30_120621_NDD_SWP4500_2020.dss.csv", "D:\GitHub\LCM_ML\DHC_output\NDD_SWP4500_2020\Delta_Capacity95_NoMask_NDD_SWP4500_2020.xlsx");
    deltanddswp45002040 = PrepScenario("D:\GitHub\LCM_ML\Calsim_delta_dss\2_DCR19_12.30_122021_NDD_SWP4500_2040CT.dss.csv", "D:\GitHub\LCM_ML\DHC_output\NDD_SWP4500_2040CT\Delta_Capacity95_NoMask_NDD_SWP4500_2040CT.xlsx");
    deltanddswp60002020 = PrepScenario("D:\GitHub\LCM_ML\Calsim_delta_dss\3_DCR19_12.30_120621_NDD_SWP6000_2020.dss.csv", "D:\GitHub\LCM_ML\DHC_output\NDD_SWP6000_2020\Delta_Capacity95_NoMask_NDD_SWP6000_2020.xlsx");
    deltanddswp60002040 = PrepScenario("D:\GitHub\LCM_ML\Calsim_delta_dss\3_DCR19_12.30_122021_NDD_SWP6000_2040CT.dss.csv", "D:\GitHub\LCM_ML\DHC_output\NDD_SWP6000_2040CT\Delta_Capacity95_NoMask_NDD_SWP6000_2040CT.xlsx");
    deltanddswp6000Beth2020 = PrepScenario("D:\GitHub\LCM_ML\Calsim_delta_dss\4_DCR19_12.30_120621_NDD_SWP6000_Beth_2020.dss.csv", "D:\GitHub\LCM_ML\DHC_output\NDD_SWP6000_Beth_2020\Delta_Capacity95_NoMask_NDD_SWP6000_Beth_2020.xlsx");
    deltanddswp6000Beth2040 = PrepScenario("D:\GitHub\LCM_ML\Calsim_delta_dss\4_DCR19_12.30_122021_NDD_SWP6000_Beth_2040CT.dss.csv", "D:\GitHub\LCM_ML\DHC_output\NDD_SWP6000_Beth_2040CT\Delta_Capacity95_NoMask_NDD_SWP6000_Beth_2040CT.xlsx");
    deltanddswp6000CVP2020 = PrepScenario("D:\GitHub\LCM_ML\Calsim_delta_dss\5_DCR19_12.30_120621_NDD_SWP6000_CVP1500_2020.dss.csv", "D:\GitHub\LCM_ML\DHC_output\NDD_SWP6000_CVP1500_2020\Delta_Capacity95_NoMask_NDD_SWP6000_CVP1500_2020.xlsx");
    deltanddswp6000CVP2040 = PrepScenario("D:\GitHub\LCM_ML\Calsim_delta_dss\5_DCR19_12.30_122021_NDD_SWP6000_CVP1500_2040CT.dss.csv", "D:\GitHub\LCM_ML\DHC_output\NDD_SWP6000_CVP1500_2040CT\Delta_Capacity95_NoMask_NDD_SWP6000_CVP1500_2040CT.xlsx");

    
    deltaData = [deltanddoff2020;deltanddoff2040;deltanddswp30002020;deltanddswp30002040;deltanddswp45002020;deltanddswp45002040;deltanddswp60002020;deltanddswp60002040;deltanddswp6000Beth2020;deltanddswp6000Beth2040;deltanddswp6000CVP2020;deltanddswp6000CVP2040];
    deltaData = deltaData(randperm(height(deltaData)),:);

end

function [dataTable] = PrepScenario(dssPath, dhcPath)
dataTable =readtable(dssPath);
dataTable([1,2],:) = [];
capacityTable = readtable(dhcPath);
dataTable.capacity = capacityTable.Total;
end


function [bayData] = PrepBayData()
    baynddoff2020 = PrepScenario("D:\ML_DSM2_DHC\bay_0_DCR19_12.30_120621_NDDOff_2020.dss.csv", "D:\ML_DSM2_DHC\DHC_output\NDDOff_2020\Bay_Capacity95_NoMask_NDDOff_2020.xlsx");
    baynddoff2040 = PrepScenario("D:\ML_DSM2_DHC\bay_0_DCR19_12.30_122021_NDDOff_2040CT.dss.csv", "D:\ML_DSM2_DHC\DHC_output\NDDOff_2040CT\Bay_Capacity95_NoMask_NDDOff_2040CT.xlsx");
    baynddswp30002020 = PrepScenario("D:\ML_DSM2_DHC\bay_1_DCR19_12.30_120621_NDD_SWP3000_2020.dss.csv", "D:\ML_DSM2_DHC\DHC_output\NDD_SWP3000_2020\Bay_Capacity95_NoMask_NDD_SWP3000_2020.xlsx");
    baynddswp30002040 = PrepScenario("D:\ML_DSM2_DHC\bay_1_DCR19_12.30_122021_NDD_SWP3000_2040CT.dss.csv", "D:\ML_DSM2_DHC\DHC_output\NDD_SWP3000_2040CT\Bay_Capacity95_NoMask_NDD_SWP3000_2040CT.xlsx");
    baynddswp45002020 = PrepScenario("D:\ML_DSM2_DHC\bay_2_DCR19_12.30_120621_NDD_SWP4500_2020.dss.csv", "D:\ML_DSM2_DHC\DHC_output\NDD_SWP4500_2020\Bay_Capacity95_NoMask_NDD_SWP4500_2020.xlsx");
    baynddswp45002040 = PrepScenario("D:\ML_DSM2_DHC\bay_2_DCR19_12.30_122021_NDD_SWP4500_2040CT.dss.csv", "D:\ML_DSM2_DHC\DHC_output\NDD_SWP4500_2040CT\Bay_Capacity95_NoMask_NDD_SWP4500_2040CT.xlsx");
    baynddswp60002020 = PrepScenario("D:\ML_DSM2_DHC\bay_3_DCR19_12.30_120621_NDD_SWP6000_2020.dss.csv", "D:\ML_DSM2_DHC\DHC_output\NDD_SWP6000_2020\Bay_Capacity95_NoMask_NDD_SWP6000_2020.xlsx");
    baynddswp60002040 = PrepScenario("D:\ML_DSM2_DHC\bay_3_DCR19_12.30_122021_NDD_SWP6000_2040CT.dss.csv", "D:\ML_DSM2_DHC\DHC_output\NDD_SWP6000_2040CT\Bay_Capacity95_NoMask_NDD_SWP6000_2040CT.xlsx");
    baynddswp6000Beth2020 = PrepScenario("D:\ML_DSM2_DHC\bay_4_DCR19_12.30_120621_NDD_SWP6000_Beth_2020.dss.csv", "D:\ML_DSM2_DHC\DHC_output\NDD_SWP6000_Beth_2020\Bay_Capacity95_NoMask_NDD_SWP6000_Beth_2020.xlsx");
    baynddswp6000Beth2040 = PrepScenario("D:\ML_DSM2_DHC\bay_4_DCR19_12.30_122021_NDD_SWP6000_Beth_2040CT.dss.csv", "D:\ML_DSM2_DHC\DHC_output\NDD_SWP6000_Beth_2040CT\Bay_Capacity95_NoMask_NDD_SWP6000_Beth_2040CT.xlsx");
    baynddswp6000CVP2020 = PrepScenario("D:\ML_DSM2_DHC\bay_5_DCR19_12.30_120621_NDD_SWP6000_CVP1500_2020.dss.csv", "D:\ML_DSM2_DHC\DHC_output\NDD_SWP6000_CVP1500_2020\Bay_Capacity95_NoMask_NDD_SWP6000_CVP1500_2020.xlsx");
    baynddswp6000CVP2040 = PrepScenario("D:\ML_DSM2_DHC\bay_5_DCR19_12.30_122021_NDD_SWP6000_CVP1500_2040CT.dss.csv", "D:\ML_DSM2_DHC\DHC_output\NDD_SWP6000_CVP1500_2040CT\Bay_Capacity95_NoMask_NDD_SWP6000_CVP1500_2040CT.xlsx");

    bayData = [baynddoff2020;baynddoff2040;baynddswp30002020;baynddswp30002040;baynddswp45002020;baynddswp45002040;baynddswp60002020;baynddswp60002040;baynddswp6000Beth2020;baynddswp6000Beth2040;baynddswp6000CVP2020;baynddswp6000CVP2040];
    bayData = bayData(randperm(height(bayData)),:);
end

function [bayTable] = PrepScenario(dssPath, dhcPath)
%Create month string array

dataTable =readtable(dssPath);

capacityTable = readtable(dhcPath);

%Get the x2 data for the x2 table. Use X2_PRV shifted by one month. For the
%final month of the time series, use X2_WHLJPOD_EST_
x2_km = dataTable.X2_PRV(2:end);
x2_km(end+1) = dataTable.X2_WHLJPOD_EST_(end);

%Get x10 for the x2 table.
x10_km = x2_km.*0.75;

year = capacityTable.Year;
month = capacityTable.Month;
sac = dataTable.C_SAC000;
capacity = capacityTable.Total;

%Put all data into the table.
bayTable = table(year,month,x2_km,x10_km, sac, capacity);
end


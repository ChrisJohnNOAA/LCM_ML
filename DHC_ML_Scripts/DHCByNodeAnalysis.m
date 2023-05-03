function [deltaData] = DHCByNodeAnalysis()
    deltanddoff2020 = PrepScenario("D:\GitHub\LCM_ML\DHC_output\NDDOff_2020\Capacity95_Fish_NoMask_NDDOff_2020.csv");
    deltanddoff2040 = PrepScenario("D:\GitHub\LCM_ML\DHC_output\NDDOff_2040CT\Capacity95_Fish_NoMask_NDDOff_2040CT.csv");
    deltanddswp30002020 = PrepScenario("D:\GitHub\LCM_ML\DHC_output\NDD_SWP3000_2020\Capacity95_Fish_NoMask_NDD_SWP3000_2020.csv");
    deltanddswp30002040 = PrepScenario("D:\GitHub\LCM_ML\DHC_output\NDD_SWP3000_2040CT\Capacity95_Fish_NoMask_NDD_SWP3000_2040CT.csv");
    deltanddswp45002020 = PrepScenario("D:\GitHub\LCM_ML\DHC_output\NDD_SWP4500_2020\Capacity95_Fish_NoMask_NDD_SWP4500_2020.csv");
    deltanddswp45002040 = PrepScenario("D:\GitHub\LCM_ML\DHC_output\NDD_SWP4500_2040CT\Capacity95_Fish_NoMask_NDD_SWP4500_2040CT.csv");
    deltanddswp60002020 = PrepScenario("D:\GitHub\LCM_ML\DHC_output\NDD_SWP6000_2020\Capacity95_Fish_NoMask_NDD_SWP6000_2020.csv");
    deltanddswp60002040 = PrepScenario("D:\GitHub\LCM_ML\DHC_output\NDD_SWP6000_2040CT\Capacity95_Fish_NoMask_NDD_SWP6000_2040CT.csv");
    deltanddswp6000Beth2020 = PrepScenario("D:\GitHub\LCM_ML\DHC_output\NDD_SWP6000_Beth_2020\Capacity95_Fish_NoMask_NDD_SWP6000_Beth_2020.csv");
    deltanddswp6000Beth2040 = PrepScenario("D:\GitHub\LCM_ML\DHC_output\NDD_SWP6000_Beth_2040CT\Capacity95_Fish_NoMask_NDD_SWP6000_Beth_2040CT.csv");
    deltanddswp6000CVP2020 = PrepScenario("D:\GitHub\LCM_ML\DHC_output\NDD_SWP6000_CVP1500_2020\Capacity95_Fish_NoMask_NDD_SWP6000_CVP1500_2020.csv");
    deltanddswp6000CVP2040 = PrepScenario("D:\GitHub\LCM_ML\DHC_output\NDD_SWP6000_CVP1500_2040CT\Capacity95_Fish_NoMask_NDD_SWP6000_CVP1500_2040CT.csv");

    
    deltaData = [deltanddoff2020;deltanddoff2040;deltanddswp30002020;deltanddswp30002040;deltanddswp45002020;deltanddswp45002040;deltanddswp60002020;deltanddswp60002040;deltanddswp6000Beth2020;deltanddswp6000Beth2040;deltanddswp6000CVP2020;deltanddswp6000CVP2040];

    stats = grpstats(deltaData, 'Channel', "std");
    
    vChannelNum = readgeoraster('channelNum82.tif');

    test = nan(size(vChannelNum));
    for i = 1:length(stats.Channel)
        ind = find(vChannelNum==stats.Channel(i));
        test(ind) = stats.std_Cap95(i);
    end
    imagesc(test)
    colorbar

    stats.std_Cap95
end


function [dataTable] = PrepScenario(dhcPath)
dataTable = readtable(dhcPath);
end
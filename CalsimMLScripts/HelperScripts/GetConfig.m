function [config] = GetConfig(scenario)
config = table();
config.swpcapacity = 6000;
config.cvpcapacity = 0;
config.user1 = 0;
config.user2 = 1;
config.source1 = 1;
config.source2 = 1;
config.source3 = 1;
config.source4 = 0;
config.source5 = 0;
switch scenario
    case 0
        config.user2 = 0;
        config.source1 = 0;
        config.source2 = 0;
        config.source3 = 0;
    case 1
        config.swpcapacity = 3000;
    case 2
        config.swpcapacity = 4500;
    case 5
        config.cvpcapacity = 1500;
        config.user1 = 1;
        config.source4 = 1;
        config.source5 = 1;
end        
end
%Ejemplo de Codigo para cargar una fase de cada archivo 
V = {};
labels = {};

load('GKLE_0929_1610_30.mat','Va'); % downstream capacitor de-energizing
V{end+1} = Va;
labels{end+1} = 'downstream capacitor de-energizing';


load('Q82U_0329_0947_30.mat','Va'); % no event
V{end+1} = Va;
labels{end+1} = 'no event';

load('QL9F_0322_1916_00.mat','Va'); % downstream capacitor energizing
V{end+1} = Va;
labels{end+1} = 'downstream capacitor energizing';

load('Q6ZW_0329_2323_30.mat','Va'); % fault event
V{end+1} = Va;
labels{end+1} = 'fault event';

load('QB7B_0327_2016_00.mat','Va'); % upstream capacitor energizing
V{end+1} = Va;
labels{end+1} = 'upstream capacitor energizin';

load('UWZ5_1230_1741_00.mat','Va'); % event not caused by capacitor switching
V{end+1} = Va;
labels{end+1} = 'event not caused by capacitor switching';




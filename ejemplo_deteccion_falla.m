%ejemplo de aplicacion wavelet para encontrar donde se 

load('QL9F_0322_1916_00.mat','Vc'); % downstream capacitor energizing
%tomo solo una fase para este ejemplo 
x = Vc(1.5e5+1:end); %corto el segmento para no manejar tantos datos


d = get_wvcd(x,wname,3); 
x = x/max(x); %normalizo asi es mas facil plotear superponiendo otras curvas
figure()
plot(x);
xlim([1e4 *6.4,1e4 *6.75])
ylim([-1.1,1.1])
grid('on')
legend('Face C')
ylabel('Tension Normalizada')
xlabel('Muestras')

figure()
hold on;
plot(d(1,:),'linewidth',1.5);
plot(d(2,:),'linewidth',1.5);
plot(d(3,:),'linewidth',1.5);
plot(x,'linewidth',2); %ploteo normalizado
xlim([1e4 *6.63,1e4 *6.65])
ylim([-1.1,1.1])
grid('on')
legend({'Coef Detalle 1','Coef Detalle 2','Coef Detalle 3','Face C'})
ylabel('Tension Normalizada')
xlabel('Muestras')
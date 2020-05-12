%%Ejemplo Función Seno vs Morlet
figure()
N = 2048;
x = 1:N;
seno = sin(x*0.039);
subplot(2,2,1)
plot(x,seno,'linewidth',2); 
xlim([1,N])
title('Función Seno');
xlabel('Muestras')
subplot(2,2,3)
f = (0:N-1)*(2*pi/N);
fsen = fft(seno);
power = abs(fsen).^2/N;    
plot(f(1:floor(N/2)),power(1:floor(N/2)),'LineWidth',1.5) 
title('Espectro Función Seno');
xlim([0,0.25])
xlabel(sprintf('\\omega'))
ylabel('Potencia')

[morlet] = wavefun('morl',11); %aproximo una wavelet morlet con 2^11 muestras
subplot(2,2,2)
plot(morlet,'linewidth',2); 
N = length(morlet);

xlim([1,N])
title('Morlet Wavelet');
xlabel('Muestras')
subplot(2,2,4)
f = (0:N-1)*(2*pi/N);
fmorlet = fft(morlet);
power = abs(fmorlet).^2/N;    
plot(f(1:floor(N/2)),power(1:floor(N/2)),'LineWidth',1.5) 
title('Espectro Morlet Wavelet');
ylabel('Potencia')
xlabel(sprintf('\\omega'))
xlim([0,0.25])

%% Coeficientes de la CWT, escalas y desplazamientos
[mexh] = wavefun('mexh',9); %aproximo wavelet sombrero mexicano con 2^9 muestras
mexh = mexh(101:end-100); %para simpificar el plot saco los bordes
m = length(mexh);
N = 2^9;
as= [10,1,1]; %elijo las escalas a plotear
bs = [200,200,400]; %elijo los desplazamientos  a plotear
for i = 1:length(as)
    a = as(i);
    b = bs(i);
    x = zeros(N,1);
    wvl = mexh(1:10/a:m); %tomo muestras salteadas es equivalente a escalar en tiempo
    x(b-length(wvl)/2:b+floor((m-1)/10*a)-length(wvl)/2) = wvl; %coloco wavelet en vector de zeros
    subplot(2,3,i)
    plot(x,'LineWidth',1.5)
    title(sprintf('Forma de onda: \\psi con a=%.1f  b=%d',a/10,b));
    ylabel('Amplitud')
    xlabel(sprintf('muestras'))
    subplot(2,3,i+3)
    f = (0:N-1)*(2*pi/N);
    %calculo la fft
    amp = abs(fft(x))/N/sqrt(a);    
    plot(f(1:floor(N/2)),amp(1:floor(N/2)),'LineWidth',1.5)
    xlim([-0.1,pi/2])
    title(sprintf('Espectro: \\psi con a=%.1f  b=%d',a/10,b));
    ylabel('Modulo Amplitud')
    xlabel(sprintf('\\omega'))
end
%% Efecto en frecuencia de las escalas en la CWT
[morl] = wavefun('morl',13); %morlet con 2^13 muestras
m = length(morl);
N = 2^13;
asp = [1,2,4,8,16,32];%escalas de la forma 2^n
asl = linspace(1,32,6); %escala crecientes de forma lineal


for i = 1:length(asl)
    a = asl(i);
    x = zeros(N,1);
    x(1:1+floor((m-1)/floor(150/a))) = morl(1:floor(150/a):m)/sqrt(a); %coloco wavelet en vector  de zeros
    f = (0:N-1)*(2*pi/N);
    %calculo fft
    amp = abs(fft(x))/N/sqrt(a);
    subplot(2,2,1)
    hold on
    plot(f(1:floor(N/2)),amp(1:floor(N/2)),'LineWidth',1.5)
    title(sprintf('Espectros: escala lineal 1 a 32',a+m/2));
    ylabel('Modulo Amplitud')
    xlabel(sprintf('\\omega'))
    xlim([-0.02,3])
    subplot(2,2,3)
    hold on
    plot(f(1:floor(N/2)),amp(1:floor(N/2)),'LineWidth',1.5)
    title(sprintf('Espectros: escala lineal 1 a 32',a+m/2));
    ylabel('Modulo Amplitud')
    xlabel(sprintf('\\omega [log]'))
    set(gca, 'XScale', 'log')
    xlim([0.013,2.8])
end
%simil anterior pero con escalas en progresion geometrica
for i = 1:length(asp)
    a = asp(i);
    x = zeros(N,1);
    x(b:b+floor((m-1)/floor(150/a))) = morl(1:floor(150/a):m)/sqrt(a);
    f = (0:N-1)*(2*pi/N);
    amp = abs(fft(x))/N/sqrt(a);
    subplot(2,2,2)
    hold on
    plot(f(1:floor(N/2)),amp(1:floor(N/2)),'LineWidth',1.5)
    title(sprintf('Espectros: potencias de 2, 1 a 32',a+m/2));
    ylabel('Modulo Amplitud')
    xlabel(sprintf('\\omega'))
    xlim([-0.02,3])
    subplot(2,2,4)
    hold on
    plot(f(1:floor(N/2)),amp(1:floor(N/2)),'LineWidth',1.5)
    title(sprintf('Espectros: potencias de 2, 1 a 32',a+m/2));
    ylabel('Modulo Amplitud')
    xlabel(sprintf('\\omega [log]'))    
    set(gca, 'XScale', 'log')
    xlim([0.013,2.8])
end

%% CWT ejmplo ecolocacion
load batsignal %cargo los datos;
fs = 1/DT;
cwt(batsignal,'bump',fs,'VoicesPerOctave',30,'FrequencyLimits',[10000,75000])

%% Ejemplo CWT y algunos cambios graficos
disp('Descargar y dejar accesible los datos: <a href="https://www.kaggle.com/robikscube/hourly-energy-consumption/download/Q44VajE6rAh0n5SfMS5b%2Fversions%2FqrKdq5dRu6kSxrzIB5I6%2Ffiles%2FCOMED_hourly.csv?datasetVersionNumber=3">Link</a>.')
%Commonwealth Edison (ComEd) - estimated energy consumption in Megawatts
%(MW)Eastern Interconnection grid de EEUU
% una medicion por hora
%empiezan el 31/12/2011 y terminan el 19/1/2018

%cargo los datos, colocar la ubicacion del archivo csv
data = readtable('C:\Users\localadmin1\Downloads\COMED_hourly.csv');
x = data.COMED_MW; 

fs = 1/(60*60); %frecuencia en segundos (una muestra por hora)
figure()
cwt(x,'morse',fs)
figure()
%utilizo funcion hora para dar el periodo de muestreo en lugar de la
%frecuencia, el resultado aparece en funcion del periodo en el eje y
cwt(x,'morse',hours(1))
figure()
%cambio wavelet
cwt(x,'bump',hours(1))
%% Cambiando ejes de la cwt
%supongo datos cargados en la variable x
figure()
cwt(x,'bump',hours(1))
%codigo para cambiar las etiquetas de los ejes de la cwt:

xl = xticklabels;
years = 1:7; %años que quiero mostrar
xt = years*24*365; %paso a horas esos años para saber donde plotear
xticks(xt)  %seteo donde apareceran las etiquetas
xticklabels(years) %coloco etiquetas
xlabel('Tiempo (años)')

yt ={'12 horas','dias','semana/2','semana','aire acond','anio'}; %etiquetas en el eje y que quiero mostrar
hs = [12,24,7/2*24,24*7,365*24/2,365*24];  %paso a horas para saber donde plotear
yticks(hs)   %seteo donde apareceran las etiquetas
yticklabels(yt) %coloco etiquetas
ylabel('Mis Labels')
%% Observando periodo de 12 horas
figure()
invierno = zeros(30,24); %creo matriz donde guardar señales diarias de un mes
%tomo los primeros 30 dias (pleno invierno en el dataset)
for i = 1:30
    invierno(i,:) = x(24*(i-1)+1:i*24); 
end
plot(mean(invierno),'linewidth',2)
hold on
    
verano = zeros(30,24); %creo matriz donde guardar señales diarias de un mes
%avanzo 6 meses (en horas 6*30*24) y tomo 30 dias
for i = 1:30
    verano(i,:) = x(6*30*24+(24*(i-1)+1:i*24));
end
plot(mean(verano),'linewidth',2)
xlim([1,24])
xlabel('Tiempo (Horas)')
ylabel('Potencia (MW)')
grid on
legend('día medio en invierno','día medio en verano')
title('Días verano vs dias invierno')
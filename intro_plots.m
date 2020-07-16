%ploteos de la introduccion de la clase de wavelets
close all %cierro todas las ventanas creadas
%% ejemplo Señal digital
figure()
f = @(x) sin(x/2+0.2)+1-x/30;
stem(f(1:15),'linewidth',2)
hold on
xcont = linspace(1,15,300); %pasos chicos simulo continuidad
plot(xcont,f(xcont))
xlim([0.5,10.5])
%ylim([0,1.1])
xlabel('Tiempo')
ylabel('')
grid on
legend('x[n]','f(t)')
%% Ejemplo Muestreo valido
figure()
ts = 0.5; %frecuencia de muestreo
ts_cont = 0.001;  %no se puede guardar algo continuo en vector pero supongamos un ts muy chico como aproximacion

n = 0:ts:10; %tiempo discreto
t = 0:ts_cont:10; %tiempo pseudo continuo
f = 0.8; %frecuencia del coseno

t1 = cos(2*pi*f*t); %pseudo funcion continua
d = cos(2*pi*f*n); %funcion muestreada
%utilizo resample, esta funcion cambia el intervalo de muestreo el 40 dice que tan bueno es el filtro de reconstruccion
t2 = resample(d,ts/ts_cont,1,80); %pseudo funcion reconstruida
plot(t,t1,'-','LineWidth',3)
hold on

stem(n,d,'ko','LineWidth',3)
plot(t,t2(1:length(t)),'-','LineWidth',1.5)
hold off
title('Teorema de Muestreo - con Señal Reconstruida')
xlabel('Tiempo(s)')
ylabel('Amplitud')
ylim([-1.1,1.1])
xlim([-0.1,10.5])
legend(sprintf('Continuo'),...
    sprintf('Muestras'),...
    sprintf('Reconstrucción'))
%% Ejemplo Muestreo NO valido
figure()
ts = 0.5;
ts_cont = 0.001; %no se puede guardar algo continuo en vector pero supongamos un ts muy chico como aproximacion

n = 0:ts:20; %tiempo discreto
t = 0:ts_cont:20; %tiempo pseudo continuo
f = 21/20;
%
d = cos(2*pi*f*n);
t1 = cos(2*pi*f*t); %tiempo pseudo continuo
%reconstruimos la señal original
%utilizo resample, esta funcion cambia el intervalo de muestreo el 40 dice que tan bueno es el filtro de reconstruccion
t2 = resample(d,ts/ts_cont,1,40); %pseudo funcion reconstruida
plot(t,t1,'-','LineWidth',3)
hold on

stem(n,d,'ko','LineWidth',3)
plot(t,t2(1:length(t)),'-','LineWidth',1.5)
hold off
title('Teorema de Muestreo')
xlabel('Tiempo(s)')
ylabel('Amplitud')
ylim([-1.1,1.1])
xlim([0.5,10.5])
legend(sprintf('Continuo'),...
    sprintf('Muestras'),...
    sprintf('Reconstrucción'))

%% Ejemplo de ploteo usando fftshift de Matlab

figure()
N = 21; 
rand_sig = rand(N,1)-0.5;
pot = abs(fft(rand_sig))/N; %calculo el modulo del espectro
cero2p = 0:(2*pi)/N:2*pi-(2*pi)/N;
piapi = sort([cero2p(cero2p>=pi)-2*pi, cero2p(cero2p<pi)]); %resto 2*pi a los coeficientes mayores o iguales a pi
pc = plot(cero2p,pot,'-o','LineWidth',1.5);
hold on
pia = plot(piapi,fftshift(pot),'--o','LineWidth',1.5);
grid on
xline(pi,'Label',sprintf('\\pi'),'LineWidth',1.5)
xline(0,'LineWidth',1.5)
xline(-pi,'Label',sprintf('-\\pi'),'LineWidth',1.5)
xline(2*pi,'Label',sprintf('2\\pi'),'LineWidth',1.5)

legend([pc, pia],'Periodo obtenido de la serie','Visualizacion usual')
xlim([-pi-0.2,2*pi+0.5])
xlabel(sprintf('\\omega'))
ylabel(sprintf('Abs(F[\\omega])'))


%% Ejemplo quejido de ballena azul

try
    [x,fs] = audioread('whale52.ogg');
catch
    disp('descargando archivo...')
    websave('whale52.ogg','https://en.wikipedia.org/wiki/File:Ak52_10x.ogg')
    disp('archivo descargado, volver a correr celda')
end
%sound(x,fs) %por si quieren escuchar el quejido (esta 10 veces mas rapido de lo real)
figure()
fs = fs/10;     %calculo la verdadera frecuencia (la que da matlab esta para que se pueda escuchar)
N = length(x); % cantidad de elementos

t = (0:1/fs:(length(x)-1)/fs); %calculo los tiempos de las muestras
subplot(2,1,1)
plot(t,x)
xlabel('Tiempo (segundos)')
ylabel('Amplitud')
xlim([0 t(end)])
subplot(2,1,2)

f = (0:N-1)*(fs/N); %calculo todas las frecuencias de las que tengo informacion
y = fft(x);
power = abs(y).^2/N; %calculo densidad de potencia

plot(f(1:floor(N/2)),power(1:floor(N/2)),'LineWidth',1.5) %el floor esta para solo incluir las frecuencias menores a pi si N es par
xlabel('Frecuencia (Hz)')
ylabel('Potencia')
%% Ejemplo Ecolocación

figure()
load batsignal; %cargo los datos
fs = 1/DT; %calculo frecuencia a partir del intervalo de muestreo
t = 0:DT:(numel(batsignal)*DT)-DT; %calculo tiempos de las muestras
N = length(batsignal);       % cantidad de elementos
subplot(2,1,1)
plot(t,batsignal)
xlabel('Tiempo (segundos)')
ylabel('Amplitud')
xlim([0 t(end)])
subplot(2,1,2)

f = (0:N-1)*(fs/N); %calculo todas las frecuencias de las que tengo informacion
y = fft(batsignal);
power = abs(y).^2/N;      

plot(f(1:floor(N/2)),power(1:floor(N/2)),'LineWidth',1.5) %el floor esta para solo incluir las frecuencias menores a pi si N es par
xlabel('Frecuencia (Hz)')
ylabel('Potencia')
%% Ejemplo Ecolocación, ventanas y STFT

figure()
%cargo los datos;
load batsignal;
fs = 1/DT;
t = 0:DT:(numel(batsignal)*DT)-DT;
N = length(batsignal);       % cantidad de elementos
ventana = 50; %elijo un ancho en muestras para la ventana
subplot(3,1,1)
plot(t,batsignal)
for i = 1:floor(N/ventana)
    xline(i*ventana*DT,'--r','linewidth',1.5)
end
xlim([0 t(end)])
xlabel('Tiempo (segundos)')
ylabel('Amplitud')
subplot(3,1,2)
%creo el vector que va a representar la funcion ventana
fvent = zeros(size(batsignal));
fvent(ventana*2+1:ventana*3)=1; %solo vale uno para la 3era ventana
plot(t,fvent,'linewidth',2)
xlim([0 t(end)])
ylim([0,1.5])
title('Función Ventana')
xlabel('Tiempo (segundos)')
ylabel('Amplitud')
subplot(3,1,3)
f = linspace(-fs/2,fs/2,8000);
pv = abs((ventana*DT)*sinc(f*(ventana*DT)*pi)).^2; %modulo de la transformada de fourier de una ventana
plot(f,pv/max(pv),'linewidth',2)
hold on
pall = abs((N*DT)*sinc(f*(N*DT)*pi)).^2; %modulo de la transformada de fourier de una ventana del largo de la señal
plot(f,pall/max(pall),'linewidth',2)
title('Espectro Ventana')
ylabel('Potencia Normalizada')
xlabel('Frecuencias (Hz)')
legend(sprintf('ventana de %d muestras',ventana),...
    sprintf('ventana de %d muestras',N))
xlim([-2000,2000])
%% Espectrograma de ecolocacion

%cargo los datos
load batsignal;
fs = 1/DT;
ventana = 50;
spectrogram(batsignal,ventana,0,[],fs,'yaxis')
if false % true para mostrar periodos
    yticklabels(cellfun(@(x) num2str(1/str2num(x),2),yticklabels,'UniformOutput',false))
    ylabel('Peridodo (ms)')
end
%% Múltiples Espectrogramas para señal de ecolocación
figure()
%cargo los datos
load batsignal;
fs = 1/DT;
ventanas = [20,50,100,200];
for i = 1:length(ventanas)
    subplot(2,2,i)
    spectrogram(batsignal,ventanas(i),0,[],fs,'yaxis','psd');
    if false % true para mostrar periodos
        yticklabels(cellfun(@(x) num2str(1/str2num(x),2),yticklabels,'UniformOutput',false))
        ylabel('Peridodo (ms)')
    end
    title([num2str(ventanas(i)) ' muestras'])
end

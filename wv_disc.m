%Ejemplo escalas y desplazamientos no superpuestos

escales = 4;
for i = 1:escales
    subplot(escales,1,i)
    [~,psi] = wavefun('db3 ',9-i);
    x = repmat(psi,1,2^(escales-i));
    plot(x,'linewidth',1.5)
    xlim([1,length(x)])
    title(sprintf('escala = s_o*2^{(m_o+%d)}',i),'interpreter','tex')
    ylabel(sprintf('\\psi''s a convolucionar'))
end


%% Ejemplo señal electrica y dwt ploteada como una cwt
load leleccum; %consumo electrico durante 3 dias (dt=1 minuto)
indx = 2000:4000;
y = leleccum(indx);
subplot(2,1,1)
plot(y)
N = length(y);
xlim([1,N])
xlabel('muestras')
ylabel('Consumo')

grid('on')

escalas = 7;
[C,L] = wavedec(y,escalas,'db3');
M = zeros(escalas+1,N*700);
usados = 0;
subplot(2,1,2)
for s = 1:escalas+1
    coefs = L(s);
    ancho = floor(N*700/coefs);
    for i = 1:coefs
        M(s,(1:ancho)+ancho*(i-1)) = C(usados+i);
    end
    usados = usados + coefs;
end
image(1:N,(escalas+1):-1:1,abs(M))
xlabel('muestras')

yp = 1:escalas+1; %posicion de escalas
ylab = {};
for i =1:escalas
    ylab{i} = ['coef detalle ' num2str(i)];
end
ylab{escalas+1} = ['coef aprox ' num2str(escalas)];
yticks(yp)   
yticklabels(ylab)
%% Ejemplo Denoising
figure
load leleccum; %consumo electrico durante 3 dias (dt=1 minuto)
indx = 2000:4000;
x = leleccum(indx);
N = length(x);
subplot(3,1,1)

plot(x);
xlim([1,N]);
grid on;
ylabel('x[n]')
title('Señal con ruido')
xden = wdenoise(x,4,'Wavelet','db3','DenoisingMethod','UniversalThreshold'); %revisar cmddenoise para un metodo mas automatico
subplot(3,1,2)
plot(xden)
xlim([1,N]);
grid on;
ylabel('xden[n]')
title('Señal sin ruido')

y = xden;
escalas = 7;
[C,L] = wavedec(y,escalas,'db3');
M = zeros(escalas+1,N*700);
usados = 0;
subplot(3,1,3)
for s = 1:escalas+1
    coefs = L(s);
    ancho = floor(N*700/coefs);
    for i = 1:coefs
        M(s,(1:ancho)+ancho*(i-1)) = C(usados+i);
    end
    usados = usados + coefs;
end
image(1:N,(escalas+1):-1:1,abs(M))
xlabel('muestras')

yp = 1:escalas+1; %posicion de escalas
ylab = {};
for i =1:escalas
    ylab{i} = ['coef detalle ' num2str(i)];
end
ylab{escalas+1} = ['coef aprox ' num2str(escalas)];
yticks(yp)   
yticklabels(ylab)
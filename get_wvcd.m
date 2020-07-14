function details = get_wvcd(x,wname,maxlevel)
%Esta funcion calcula los coeficientes de detalle hasta el nivel maxlevel
% para el vector x, repitiendo valores crea una matriz details de (maxlevel,length(x)) 
% muy práctica para plotear resultados, donde cada escala esta ajustada por
% el maximo valor y elevada al cuadrado.
details = zeros(maxlevel,length(x));
a = x;
for i = 1:maxlevel
    [a,cD] = dwt(a,wname);
    samples2remove = length(cD)- floor(length(x)/2^i);
    cD = cD(floor(samples2remove/2)+1:end-ceil(samples2remove/2));
    cD = cD.^2; %al cuadrado para ver mejor cambios
    details(i,:) = repelem(cD,2^i)/max(cD(200:end-200)); %normalizo por el maximo, sin contar efectos de borde
end
end


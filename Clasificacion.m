 tamVent = 1024; %Tamaño de la ventana
 paso = tamVent; %Overlap de ventanas: Si es igual al tamaño de la ventana no hay overlap

fm_clasico=zeros(3,1); %vector columna con las frecuencias de muestreo
carac=zeros(9,18);
for i=1:3
    [s_clasico, fm_clasico(i,1)] = audioread(strcat('Canciones/clasico' , int2str(i),'_modificado.wav'));
    carac(i,:) = extraerCaract(s_clasico,tamVent,paso,fm_clasico(i,1));
end

fm_rap=zeros(3,1);
for j=1:3
   [s_rap, fm_rap(j,1)] = audioread(strcat('Canciones/rap' , int2str(j),'_modificado.wav'));
   carac(i+j,:) = extraerCaract(s_rap,tamVent,paso,fm_rap(j,1));
end

fm_cumbia=zeros(3,1);
for k=1:3
    [s_cumbia, fm_cumbia(k,1)] = audioread(strcat('Canciones/cumbia' , int2str(k),'_modificado.wav'));
    carac(i,:) = extraerCaract(s_cumbia,tamVent,paso,fm_cumbia(k,1));
end

etiqueta= [ 'clasico'; 'clasico'; 'clasico'; 'rap'; 'rap'; 'rap'; 'cumbia'; 'cumbia'; 'cumbia'];

red = fitcdiscr(carac,etiqueta);

[s_cumbia, fm_c] = audioread(strcat('Canciones/cumbia' , int2str(7),'_modificado.wav'));
desconocido(1,:) = extraerCaract(s_cumbia,tamVent,paso,fm_c);

resultado = predict (red, desconocido);
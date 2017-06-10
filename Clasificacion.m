
 tamVent = 1024; %Tamaño de la ventana
 paso = tamVent; %Overlap de ventanas: Si es igual al tamaño de la ventana no hay overlap

fm_clasico=zeros(3,1); %vector columna con las frecuencias de muestreo
carac=zeros(9,18);
for i=1 : 3
    [s_clasico, fm_clasico(i,1)] = audioread(strcat('Canciones/clasico' , int2str(i),'_modificado.wav'));
    
   [carac(i,1),carac(i,2),carac(i,3),carac(i,4),carac(i,5),carac(i,6),carac(i,7),carac(i,8),v1,v2] = extraerCaract(s_clasico,tamVent,paso,fm_clasico(i,1));
   carac(i,:)=[carac(i,:) v1(:) v2(:)];
end

fm_rap=zeros(3,1);
for j=1 : 3
    [s_rap, fm_rap(j,1)] = audioread(strcat('Canciones/rap' , int2str(j),'_modificado.wav'));
    
   [carac(i+j,1),carac(i+j,2),carac(i+j,3),carac(i+j,4),carac(i+j,5),carac(i+j,6),carac(i+j,7),carac(i+j,8),v1,v2] = extraerCaract(s_rap,tamVent,paso,fm_rap(j,1));
   carac(i+j,:)=[carac(i+j,:) v1 v2];
end

fm_cumbia=zeros(3,1);
for k=1 : 3
    [s_cumbia, fm_cumbia(k,1)] = audioread(strcat('Canciones/cumbia' , int2str(k),'_modificado.wav'));
    
   [carac(i+j+k,1),carac(i+j+k,2),carac(i+j+k,3),carac(i+j+k,4),carac(i+j+k,5),carac(i+j+k,6),carac(i+j+k,7),carac(i+j+k,8),v1,v2] = extraerCaract(s_cumbia,tamVent,paso,fm_cumbia(k,1));
   carac(i+j+k,:)=[carac(i+j+k,:) v1 v2];
end

etiqueta= [ 'clasico'; 'clasico'; 'clasico'; 'rap'; 'rap'; 'rap'; 'cumbia'; 'cumbia'; 'cumbia'];

red = fitcdiscr(carac,etiqueta);

[s_cumbia, fm_c] = audioread(strcat('Canciones/cumbia' , int2str(7),'_modificado.wav'));
[caract(1,1),caract(1,2),caract(1,3),caract(1,4),caract(1,5),caract(1,6),caract(1,7),caract(1,8),v1,v2] = extraerCaract(s_cumbia,tamVent,paso,fm_c);
carac(1,:)=[carac(1,:) v1 v2];

resultado = predict (red, caract);
%{
Extraer características: 
Parámetros: cancion (señal de la cancion completa), tamVent (tamaño de la ventana), paso (avance de la ventana), fs (frecuencia de la señal)
Algunas características se calculan por ventanas y luego se toma la media y varianza

Elementos que devuelve la funcion en el vector carac
    m_sF: media flujo espectral
    v_sF: varianza flujo espectral
    m_sR: media rol off
    v_sR: varianza rol off
    m_cE: media centroide espectral
    v_cE: varianza centroide espectral
    m_zC: media de la cantidad de cruces por cero
    v_zC: varianza de la cantidad de cruces por cero
    m_cM: Media de los primeros 5 coeficientes de Mel
    v_cM: Varianza de los primeros 5 coeficientes de Mel
    A0, A1, RA, P1, P2, SUM: Parámetros calculados del histograma de beat
%}
function carac = extraerCaract(cancion,tamVent,paso,fm)
    carac = zeros(0);
  
	%Ventanear: Según el tamaño de la canción, su fs asociada, el tamaño de la ventana y el paso,  
	cant_frames = floor((length(cancion)-tamVent)/paso) + 1; %Frame: Ventana por señal
	H = hamming(tamVent);
	posAct = 1;	
	ventana = zeros(cant_frames,tamVent);
	tdf_v = ventana;
	for i=1:cant_frames
        %fprintf(strcat(int2str(length(cancion(posAct:posAct+tamVent-1))),'- ', int2str(cant_frames), '\n'));
		ventana(i,:) = H.*(cancion(posAct:posAct+tamVent-1));
		tdf_v(i,:) = abs(fft(ventana(i,:)));
		posAct = posAct + paso;
	end

	%Calcular características
	sF = spFlux(tdf_v); %Flujo espectral (vector de 1xcant_frames)
	carac(end+1) = mean(sF);
	carac(end+1) = var(sF);	
    
    %inicializo vectores con cero
    m_sRol = zeros(1,cant_frames);
	cE = zeros(1,cant_frames);
	zC = zeros(1,cant_frames);
    cM = zeros(cant_frames,5);

    for i=1:cant_frames %Para cada frame
            m_sRol(i) = spRoloff(tdf_v(i,:)); %Spectral Roloff para el frame i
            cE(i) = centroide_espectral(tdf_v(i,:)); %Centroide Espectral para el frame i
            zC(i) = zero_crossing(ventana(i,:)); %Zero crossing de la señal en el fame i
            cM(i,:) = coeficientes_Mel (tdf_v(i,:), fm); %Coeficientes de Mel
    end
        
    carac(end+1) = mean(m_sRol);%Media m_sR
	carac(end+1) = var(m_sRol);%Varianza v_sR
    carac(end+1) = mean(cE);%Media m_cE
	carac(end+1) = var(cE);%Varianza v_cE
    carac(end+1) = mean(zC);%Media m_zC
    carac(end+1) = var(zC);%Varianza v_zC
    
    %inicializo con cero los vectores
    m_cM = zeros(1,length(cM(1,:)));
    v_cM = zeros(1,length(cM(1,:)));
    
    for i=1:length(cM(1,:))
       m_cM(i) = mean(cM(:,i)); 
       v_cM(i) = var(cM(:,i)); 
    end
    carac = [carac m_cM v_cM];
    
    [A0, A1, RA, P1, P2, SUM] = histogramaDWT (cancion, fm);
    carac = [carac A0, A1, RA, P1, P2, SUM];
end

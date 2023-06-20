clear all
clc
% Parámetros del sistema
fs = 40000; % Frecuencia de muestreo (Hz)
n_fft = 1024;
w = 0.02;
solapamiento = 128;
% Leer señal desde archivo WAV
[y, fs_orig] = audioread('Ruido Blanco.wav');
% Asegurarse de que la señal tenga la misma frecuencia de muestreo que se especifica
y = resample(y, fs, fs_orig);

puntos = n_fft;
puntos_1 = puntos-1;
puntos_2 = puntos/2;
j = 1;
for t = 1:solapamiento:(length(y)-puntos)
    Y(:,j) = fft (w.*y(t:(t+puntos_1))); % puntos de la FFT = muestras usadas.
    modulo_Y(:,j) = abs(Y(:,j)); % devuelve el modulo
    fase_Y(:,j) = angle(Y(:,j)); % devuelve la fase en radianes
    j = j+1;
end
Y = modulo_Y; % Modulo de la FFT
Y(:,j) = fft (w.*y(1:(1+puntos_1)));

tramas = size(Y,2);
Y_promedio = Y;
for t = 2:(tramas-1)
    Y_promedio(:,t) = mean(Y(:,(t-1):(t+1)),2); % Promediado de 3 tramas
end
Y = Y_promedio;

n = 30; % estimacion de ruido haber si es esto
r_media = Y(:,n);

D_voz = vad_ZCR(y,puntos,16,fs);

i = 0;
for t = 1:tramas
    if D_voz(t) == 0 % Aquellos valores iguales a cero los entenderemos como ruido(VAD)
        i = i+1; % numero de ventanas sin voz del array ruido i = n-2;
        r_media = alfa*r_media + (1-alfa)*Y(:,t);
        Y(:,t) = c*Y(:,t); % Reemplazar estos por tramas con ruido atenuado
        Array_ruido(:,i) = Y(:,t);
    end
end
r_media = abs(r_media);

umbral_ruido = beta*Y;
[I,J] = find(X < umbral_ruido);
X(sub2ind(size(X),I,J)) = umbral_ruido(sub2ind(size(X),I,J));

function [D_voz] = vad_ZCR(s,L,bits,fs)
    % Detector de actividad vocal (VAD).
    v = ones(1,L); %ventana rectangular.
    M = length(s);
    max_s = max(abs(s));
    M1 = M+L;
    c = zeros(1,L);
    aux = round(s/max_s*2^(bits-7));
    T = abs(s).^2; %modulo de la señal de entrada al cuadrado
    T_ZCR = 1/2*abs(sign(aux(1:M-1)) - sign(aux(2:M)));
    T_ZCR = [c T_ZCR' c]; %Metemos L ceros por delante y detrás de T (la señal)

    T = [c T' c]; %Metemos L ceros por delante y detrás de T (la señal)
    for n = L:(M1-1)
        sum_E = 0;
        sum_ZCR = 0;
        for k = (n-L+1):n
            sum_E = sum_E + T(k);
            sum_ZCR = sum_ZCR + T_ZCR(k);
        end
        E(n-L+1) = sum_E;
        zcr(n-L+1) = sum_ZCR;
    end
    zcr = zcr*(1/L)*fs;
    
    D_E = std(E) * max(sign(E - max(E)/10),0);
    D_zcr = std(zcr) * max(sign(zcr - max(zcr)/10),0);
    aux = (D_E | D_zcr);
    L = L/2;
    i = 1;
    for t = 1:L:M
        D_voz(i) = aux(t); %0's y 1's
        i = i+1;
    end
end

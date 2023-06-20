
B1 = 'A1';
save banda1.mat;

[Audio, fs] = audioread('Ruido-Blanco.mp3');
L = length(Audio);
nfourier = 2^nextpow2(L);
AudioF = fft(Audio, nfourier) / L;

% Vector tiempo para la señal de audio y para dominio en frecuencia
t = (0:L-1) / fs;
n = fs * linspace(0, 1, nfourier/2+1);

%%
% Asignación de los filtros a variables
MediasAltas = FMediasAltas;
sub = subgrave;
pre = presencia;
Grave = FGrave;
MediasBajas = FMediasBajas;
Brillo = FBrillo;

% Aplicación de los filtros
AuMeAl = filter(MediasAltas, Audio);
AuMeAlF = fft(AuMeAl, nfourier) / L;

Asub = filter(sub, Audio);
AsubF = fft(Asub, nfourier) / L;

Apre = filter(pre, Audio);
ApreF = fft(Apre, nfourier) / L;

AuGra = filter(Grave, Audio);
AuGraF = fft(AuGra, nfourier) / L;

AuMeBa = filter(MediasBajas, Audio);
AuMeBaF = fft(AuMeBa, nfourier) / L;

AuBrillo = filter(Brillo, Audio);
AuBrilloF = fft(AuBrillo, nfourier) / L;

%%
% Detección y reducción de ruido

% Parámetros para la detección de ruido
umbral = 0.1;  % Umbral para considerar una muestra como ruido
factorReduccion = 0.5;  % Factor de reducción del ruido

% Detección de muestras de ruido
muestrasRuido = abs(Audio) < umbral;

% Reducción de ruido
AudioReducido = Audio;
AudioReducido(muestrasRuido) = factorReduccion * Audio(muestrasRuido);

% Transformada del audio con reducción de ruido
AudioReducidoF = fft(AudioReducido, nfourier) / L;

%%
% Ploteo de la forma de onda y espectro del audio original y con reducción de ruido
figure(1);
subplot(2,2,1);
plot(t, Audio);
title('Audio Original');
subplot(2,2,2);
plot(n, 2*abs(AudioF(1:nfourier/2+1)));
title('Espectro audio original');
subplot(2,2,3);
plot(t, AudioReducido);
title('Audio Reducido de Ruido');
subplot(2,2,4);
plot(n, 2*abs(AudioReducidoF(1:nfourier/2+1)));
title('Espectro audio con reducción de ruido');

%%
% Ploteo de la forma de onda y espectro del audio filtrado con cada filtro pasa banda
figure(2);
subplot(3, 2, 1);
plot(t, Audio);
title('Audio Original');
subplot(3, 2, 2);
plot(n, 2*abs(AudioF(1:nfourier/2+1)));
title('Espectro audio original');

subplot(3, 2, 3);
plot(t, AuGra);
title('Audio filtro Grave');
subplot(3, 2, 4);
plot(n, 2*abs(AuGraF(1:nfourier/2+1)));
title('Espectro audio filtro Grave');

subplot(3, 2, 5);
plot(t, AuMeBa);
title('Audio filtro Medias-Bajas');
subplot(3, 2, 6);
plot(n, 2*abs(AuMeBaF(1:nfourier/2+1)));
title('Espectro audio filtro Medias-Bajas');

figure(3);
subplot(3, 2, 1);
plot(t, Audio);
title('Audio Original');
subplot(3, 2, 2);
plot(n, 2*abs(AudioF(1:nfourier/2+1)));
title('Espectro audio original');

subplot(3, 2, 3);
plot(t, AuMeAl);
title('Audio filtro Medias-Altas');
subplot(3, 2, 4);
plot(n, 2*abs(AuMeAlF(1:nfourier/2+1)));
title('Espectro audio filtro Medias-Altas');

subplot(3, 2, 5);
plot(t, Asub);
title('Audio filtro sub grave');
subplot(3, 2, 6);
plot(n, 2*abs(AsubF(1:nfourier/2+1)));
title('Espectro audio filtro sub grave');

figure(4);
subplot(3, 2, 1);
plot(t, Audio);
title('Audio Original');
subplot(3, 2, 2);
plot(n, 2*abs(AudioF(1:nfourier/2+1)));
title('Espectro audio original');

subplot(3, 2, 3);
plot(t, Apre);
title('Audio filtro presencia');
subplot(3, 2, 4);
plot(n, 2*abs(ApreF(1:nfourier/2+1)));
title('Espectro audio filtro presencia');

subplot(3, 2, 5);
plot(t, AuBrillo);
title('Audio filtro Brillo');
subplot(3, 2, 6);
plot(n, 2*abs(AuBrilloF(1:nfourier/2+1)));
title('Espectro audio filtro Brillo');

yd = AuBrillo + AuMeAl + AuGra + AuMeBa + Asub + Apre;
sound(yd, fs);

figure(5);
subplot(2, 2, 1);
plot(t, Audio);
title('Audio Original');
subplot(2, 2, 2);
plot(t, yd);
title('Audio Filtrado');
subplot(2, 2, 3);
plot(n, 2*abs(AudioF(1:nfourier/2+1)));
title('Espectro audio original');
subplot(2, 2, 4);
plot(n, 2*abs(fft(yd, nfourier)/L(1:nfourier/2+1)));
title('Espectro audio filtrado');

% Reproducir la señal de audio sin ruido
sound(AudioSinRuido, fs);


audiowrite('audio_sin_ruido.wav', AudioSinRuido, fs);

figure;
subplot(2,1,1);
plot(t, AudioSinRuido);
title('Audio sin ruido');
xlabel('Tiempo');
ylabel('Amplitud');
subplot(2,1,2);
plot(n, 2*abs(fft(AudioSinRuido, nfourier) / L(1:nfourier/2+1)));
title('Espectro audio sin ruido');
xlabel('Frecuencia');
ylabel('Amplitud');

% Guardar la señal de audio sin ruido en un archivo
filename = 'audio_sin_ruido.wav';
audiowrite(filename, AudioSinRuido, fs);
disp(['La señal de audio sin ruido se ha guardado en el archivo: ' filename]);
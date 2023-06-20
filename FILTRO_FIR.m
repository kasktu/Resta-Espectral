clc;
clear all;
close all;
% Parámetros del sistema
fs = 20000; % Frecuencia de muestreo (Hz)
% Leer señal desde archivo WAV
[datos2, fs_orig] = audioread('Ruido Blanco.wav');
% Asegurarse de que la señal tenga la misma frecuencia de muestreo que se especifica
 datos2= resample(datos2, fs, fs_orig);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
r=16;                       % numero de bits (r)
numcan= 4;                           % numero de canales
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
             
%%%%%%%%%%%%%%%%%%%%%%%%%
p = (2^r)/2 -1;
x = datos2/p;
%%%%%%%%%%%%%%
fc= 500;
h = fir1(40,2*fc/fs,'LOW')   %Filtro FIR
y = conv(x,h);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
NN=8192;
frec=0:NN/2-1;
frec=frec*fs/NN;
Hx=abs(fft(x,NN));
Hx=Hx(1:NN/2);
%%%%%%%%%%%%%%
Hy=abs(fft(y,NN));
Hy=Hy(1:NN/2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(1)
subplot(3,1,1),plot(x),title('Mensaje en el tiempo continuo');
subplot(3,1,2),stem(x),title('Mensaje en el tiempo discreto');
subplot(3,1,3),plot(frec,Hx),title('Espectro del Mensaje');
figure(2)
subplot(3,1,1),plot(y),title('Mensaje en el tiempo continuo');
subplot(3,1,2),stem(y),title('Mensaje en el tiempo discreto');
subplot(3,1,3),plot(frec,Hy),title('Espectro del Mensaje');
figure(3)
subplot(2,1,1),plot(frec,Hx),title('Espectro del Mensaje de entrada');
subplot(2,1,2),plot(frec,Hy),title('Espectro del Mensaje de salida');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sound(x,fs)
disp('Precione Enter para reproducir el siguiente mensaje');
pause();
sound(y,fs)

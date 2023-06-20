% Parámetros del sistema
fs = 3000; % Frecuencia de muestreo (Hz)
f1 = 50; % Frecuencia de la señal limpia (Hz)
f2 = 2000; % Frecuencia del ruido (Hz)
T = 2; % Duración de la señal (segundos)

% Generación de señal limpia
t = 0:1/fs:T-1/fs; % Vector de tiempo
clean_signal = sin(2*pi*f1*t); % Señal senoidal limpia
noise = 0.5*sin(2*pi*f2*t); % Ruido senoidal
noise_2= 0.7*cos(2*pi*500*t);% Ruido 2 senoidal
noise_3= 0.2*sin(2*pi*10*t);% Ruido 3 senoidal

% Señal con ruido
noisy_signal = clean_signal+noise_2;

% División en bandas de frecuencia
num_bands = 3; % Número de bandas de frecuencia
frequencies = linspace(0, fs/2, num_bands+1); % Frecuencias de corte de las bandas
filtered_signals = cell(1, num_bands); % Celdas para almacenar las señales filtradas
max_signal = max(noisy_signal);
min_signal = min(noisy_signal);
if abs(min_signal) > max_signal
    max_signal = abs(min_signal);
end
noisy_signal = noisy_signal / max_signal;
cutoff_low = max(frequencies(1), 0.0000001);
for i = 1:num_bands
    % Diseño del filtro IIR para cada banda de frecuencia
    cutoff_low = frequencies(i); % Frecuencia de corte inferior
    cutoff_high = min(frequencies(i+1)); % Frecuencia de corte superior
    
    Wp = [cutoff_low cutoff_high] / (fs/2); % Frecuencias de corte normalizadas
    if Wp(1) == 0
        Wp(1) = 0.000001;
    elseif Wp(2) == 1
        Wp(2) = 0.999999;
    end
    
    filter_order = 4; % Orden del filtro IIR (puedes ajustarlo según sea necesario)
    [b, a] = butter(filter_order, Wp, 'bandpass'); % Coeficientes del filtro IIR
    
    % Almacenar los coeficientes del filtro en la celda correspondiente
    filtered_signals{i} = filtfilt(b, a, noisy_signal);
    
end
prueba=filtered_signals{1}-filtered_signals{2};
% Combinación de las señales filtradas de las bandas de frecuencia
denoised_signal = sum(cat(3, filtered_signals{:}), 3);


% Señal final filtrada
filtered_signal = noisy_signal - denoised_signal;


% Aumentar el volumen de la señal filtrada
amplification_factor = 1; % Factor de amplificación (ajusta según sea necesario)
filtered_signal_amplified = filtered_signal * amplification_factor;

% Gráficos de las señales
figure;

subplot(num_bands+4, 1, 1);
plot(t, clean_signal);
title('Señal original');

subplot(num_bands+4, 1, 2);
plot(t, noisy_signal);
title('Señal con ruido');

for i = 1:num_bands
    subplot(num_bands+4, 1, i+2);
    plot(t, filtered_signals{i});
    title(sprintf('Señal Filtrada Banda %d', i));
end

subplot(num_bands+4, 1, num_bands+3);
plot(t, denoised_signal);
title('Señal sin ruido');

subplot(num_bands+4, 1,num_bands+4);
plot(t,prueba);
title('Señal con ruido menos la sin ruido');

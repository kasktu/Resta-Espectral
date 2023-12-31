% Parámetros del sistema
fs = 40000; % Frecuencia de muestreo (Hz)

% Leer señal desde archivo WAV
[y, fs_orig] = audioread('Ruido Blanco.wav');
% Asegurarse de que la señal tenga la misma frecuencia de muestreo que se especifica
y = resample(y, fs, fs_orig);

% División en bandas de frecuencia
num_bands = 3; % Número de bandas de frecuencia
frequencies = linspace(0, fs/2, num_bands+1); % Frecuencias de corte de las bandas
filtered_signals = cell(1, num_bands); % Celdas para almacenar las señales filtradas

% Generar vector de tiempo
t = (1/fs:1/fs:length(y)/fs);

for i = 1:num_bands
    % Diseño del filtro IIR para cada banda de frecuencia
    cutoff_low = max(frequencies(i), 0.1); % Frecuencia de corte inferior
    cutoff_high = min(frequencies(i+1), 0.9); % Frecuencia de corte superior
    
    % Orden del filtro IIR
    filter_order = 2;
    
    % Coeficientes del filtro IIR con regularización
    lambda = 0.01; % Valor de regularización
    filter_freqs = [0, cutoff_low, cutoff_high, fs/2];
    [~, idx] = sort(filter_freqs);
    filter_coeffs = firls(filter_order, filter_freqs(idx)/(fs/2), [0 0 1 1], [1 lambda]);
        
    % Almacenar los coeficientes del filtro en la celda correspondiente
    filtered_signals{i} = filtfilt(filter_coeffs, 1, y);
end

% Combinación de las señales filtradas de las bandas de frecuencia
denoised_signal = sum(cat(num_bands, filtered_signals{:}), num_bands);
% Señal final filtrada
excluded_signals = y - denoised_signal;

% % Aumentar el volumen de la señal filtrada
% amplification_factor = 1; % Factor de amplificación (ajusta según sea necesario)
% filtered_signal_amplified = filtered_signal * amplification_factor;

% Gráficos de las señales
figure;

subplot(num_bands+3, 1, 1);
plot(t, y);
title('Señal con ruido');

for i = 1:num_bands
    subplot(num_bands+3, 1, i+1);
    plot(t, filtered_signals{i});
    title(sprintf('Señal Filtrada Banda %d', i));
end

subplot(num_bands+3, 1, num_bands+2);
plot(t, excluded_signals);
title('Señal excluida');
subplot(num_bands+3, 1, num_bands+3);
plot(t, denoised_signal);
title('Señal filtrada');

figure
hold on
plot(t,y);
plot(t,denoised_signal);
plot(t,excluded_signals);

% Guardar la señal filtrada en un archivo WAV
%output_filename = 'Ruido Blanco_filtrado_IIR.wav';
%audiowrite(output_filename, filtered_signal, fs);

% Reproducir la señal filtrada
sound(denoised_signal, fs);


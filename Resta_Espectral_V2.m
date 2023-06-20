% Parámetros del sistema
fs = 40000; % Frecuencia de muestreo (Hz)
% Leer señal desde archivo WAV
[y, fs_orig] = audioread('Ruido Blanco.wav');
% Asegurarse de que la señal tenga la misma frecuencia de muestreo que se especifica
y = resample(y, fs, fs_orig);

% División en bandas de frecuencia
num_bands = 9; % Número de bandas de frecuencia
frequencies = linspace(0, fs/2, num_bands+1); % Frecuencias de corte de las bandas
filtered_signals = cell(1, num_bands); % Celdas para almacenar las señales filtradas

% Generar vector de tiempo
t = (1/fs:1/fs:length(y)/fs);

for i = 1:num_bands
    % Diseño del filtro FIR para cada banda de frecuencia
    cutoff_low = max(frequencies(i), 0.1); % Frecuencia de corte inferior
    cutoff_high = min(frequencies(i+1), 0.9); % Frecuencia de corte superior
    
    normalized_cutoffs = [cutoff_low cutoff_high] / (fs/2); % Frecuencias de corte normalizadas
    
    % Asegurarse de que los valores de las frecuencias de corte estén dentro del rango
    normalized_cutoffs(2) = max(normalized_cutoffs(2), normalized_cutoffs(1) + 0.001);
    normalized_cutoffs(2) = min(normalized_cutoffs(2), 1);
    
    filter_order = 80; % Orden del filtro FIR
    filter_coeffs = fir1(filter_order, normalized_cutoffs); % Coeficientes del filtro FIR
    
    % Almacenar los coeficientes del filtro en la celda correspondiente
    filtered_signals{i} = filtfilt(filter_coeffs, 1, y);
end

% Combinación de las señales filtradas de las bandas de frecuencia
denoised_signal = sum(cat(3, filtered_signals{:}), 3);
% Señal final filtrada
filtered_signal = y - denoised_signal;

% Aumentar el volumen de la señal filtrada
amplification_factor = 2; % Factor de amplificación (ajusta según sea necesario)
filtered_signal_amplified = filtered_signal * amplification_factor;

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
plot(t, denoised_signal);
title('Señal excluida');
subplot(num_bands+3, 1, num_bands+3);
plot(t, filtered_signal_amplified);
title('Señal filtrada amplificada');

% Guardar la señal filtered_signal_amplified en un archivo WAV
output_filename = 'Ruido Blanco_filtrado.wav';
audiowrite(output_filename, filtered_signal_amplified, fs);

% Reproducir la señal filtered_signal_amplified
sound(filtered_signal_amplified, fs);



figure
hold on
plot(t,filtered_signal_amplified)
plot(t,y)
plot(t,denoised_signal);


% Parámetros del sistema
fs = 1000; % Frecuencia de muestreo (Hz)
f2 = 120; % Frecuencia del ruido (Hz)

% Leer señal desde archivo WAV
[y, fs_orig] = audioread('Ruido Blanco.wav');
% Asegurarse de que la señal tenga la misma frecuencia de muestreo que se especifica
y = resample(y, fs, fs_orig);

% División en bandas de frecuencia
num_bands = 1; % Número de bandas de frecuencia
frequencies = linspace(0, fs/2, num_bands+1); % Frecuencias de corte de las bandas
filtered_signals = cell(1, num_bands); % Celdas para almacenar las señales filtradas

for i = 1:num_bands
    % Diseño del filtro IIR para cada banda de frecuencia
    cutoff_low = max(frequencies(i), 0.1); % Frecuencia de corte inferior
    cutoff_high = min(frequencies(i+1), 0.9); % Frecuencia de corte superior
    
    [b, a] = butter(8, [cutoff_low cutoff_high]/(fs/2)); % Coeficientes del filtro IIR
    
    % Filtrar la señal
    filtered_signals{i} = filtfilt(b, a, y);
end

% Combinación de las señales filtradas de las bandas de frecuencia
denoised_signal = sum(cat(3, filtered_signals{:}), 3);
% Señal final filtrada
filtered_signal = y - denoised_signal;

% Gráficos de las señales
figure;

subplot(num_bands+3, 1, 1);
plot(y);
title('Señal con ruido');

for i = 1:num_bands
    subplot(num_bands+3, 1, i+1);
    plot(filtered_signals{i});
    title(sprintf('Señal Filtrada Banda %d', i));
end

subplot(num_bands+3, 1, num_bands+2);
plot(denoised_signal);
title('Señal excluida');
subplot(num_bands+3, 1, num_bands+3);
plot(filtered_signal);
title('Señal filtrada');

% Guardar la señal filtrada en un archivo WAV
output_filename = 'Señal_filtrada_IIR.wav';
audiowrite(output_filename, filtered_signal, fs);

% Reproducir la señal filtrada
sound(filtered_signal, fs);

% Parámetros del sistema
fs = 40000; % Frecuencia de muestreo (Hz)
% Leer señal desde archivo WAV
[y, fs_orig] = audioread('Ruido Rosa.wav');
% Asegurarse de que la señal tenga la misma frecuencia de muestreo que se especifica
y = resample(y, fs, fs_orig);

% Generar vector de tiempo
t = (1/fs:1/fs:length(y)/fs);

% División en bandas de frecuencia
num_bands = 6; % Número de bandas de frecuencia
frequencies = linspace(0, fs/2, num_bands+1); % Frecuencias de corte de las bandas
filtered_signals = cell(1, num_bands); % Celdas para almacenar las señales filtradas
cutoff_low = max(frequencies(1), 0);
for i = 1:num_bands
    % Diseño del filtro FIR para cada banda de frecuencia
    cutoff_low = frequencies(i); % Frecuencia de corte inferior
    cutoff_high = min(frequencies(i+1)); % Frecuencia de corte superior
    
    normalized_cutoffs = [cutoff_low cutoff_high] / (fs/2); % Frecuencias de corte normalizadas
    if normalized_cutoffs(1)==0
        normalized_cutoffs=0.000001;
    elseif normalized_cutoffs(2)==1
        normalized_cutoffs=0.999999;
    end
    
    filter_order = 600; % Orden del filtro FIR
    filter_coeffs = fir1(filter_order, normalized_cutoffs, 'bandpass'); % Coeficientes del filtro FIR
    
    % Almacenar los coeficientes del filtro en la celda correspondiente
    filtered_signals{i} = filtfilt(filter_coeffs, 1, y);
end
% Combinación de las señales filtradas de las bandas de frecuencia
denoised_signal = sum(cat(3, filtered_signals{:}), 3)/2;
% Señal final filtrada
filtered_signal = y - denoised_signal;
% Aumentar el volumen de la señal filtrada
amplification_factor = 2; % Factor de amplificación (ajusta según sea necesario)
filtered_signal_amplified = filtered_signal * amplification_factor;


% Gráficos de las señales
figure;

subplot(5, 2, 1);
plot(t, y);
title('Señal con ruido');

for i = 1:num_bands
    subplot(5, 2, i+1);
    plot(t, filtered_signals{i});
    title(sprintf('Señal Filtrada Banda %d', i));
end

subplot(5, 2, num_bands+2);
plot(t, denoised_signal);
title('Señal excluida');
subplot(5, 2, num_bands+3);
plot(t, filtered_signal_amplified);
title('Señal filtrada amplificada');

figure
hold on
plot(t,y);
plot(t,denoised_signal);
plot(t,filtered_signal)


% Guardar la señal filtered_signal_amplified en un archivo WAV
output_filename = 'Ruido Rosa_filtrado_IFR.wav';
audiowrite(output_filename, filtered_signal_amplified, fs);

% Reproducir la señal filtered_signal_amplified
sound(filtered_signal, fs);


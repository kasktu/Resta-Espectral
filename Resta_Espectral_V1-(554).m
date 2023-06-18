function varargout = resta_espectral(varargin)
% Funcion principal RESTA_ESPECTRAL M-file for resta_espectral.fig
% RESTA_ESPECTRAL, by itself, creates a new RESTA_ESPECTRAL or raises the existing
% singleton*.
%
% H = RESTA_ESPECTRAL returns the handle to a new RESTA_ESPECTRAL or the handle to
% the existing singleton*.
%
% RESTA_ESPECTRAL('CALLBACK',hObject,eventData,handles,...) calls the local
% function named CALLBACK in RESTA_ESPECTRAL.M with the given input arguments.
%
% RESTA_ESPECTRAL('Property','Value',...) creates a new RESTA_ESPECTRAL or raises the
% existing singleton*. Starting from the left, property value pairs are
% applied to the GUI before resta_espectral_OpeningFunction gets called. An
% unrecognized property name or invalid value makes property application
% stop. All inputs are passed to resta_espectral_OpeningFcn via varargin.
%
% Codigo de inicializacion - NO EDITAR
gui_Singleton = 1;
gui_State = struct('gui_Name', mfilename, ...
            'gui_Singleton', gui_Singleton, ...
            'gui_OpeningFcn', @resta_espectral_OpeningFcn, ...
            'gui_OutputFcn', @resta_espectral_OutputFcn, ...
            'gui_LayoutFcn', [] , ...
            'gui_Callback', []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Se ejecuta antes de que el programa sea visible
function resta_espectral_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject handle to figure
% eventdata reserved - to be defined in a future version of MATLAB
% handles structure with handles and user data
% varargin command line arguments to resta_espectral

% Choose default command line output for resta_espectral
handles.output = hObject;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Leemos los parametros iniciales para     %
% que se almacenen en las variables los    %
% datos que estan por defecto en los       %
% cuadros de los parametros                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Parametros de la estimacion del ruido

n_estim=str2double(get(handles.n_estimacion_edit,'string'));
handles.n_estim=n_estim;
M_estim=str2double(get(handles.M_estimacion_edit,'string'));
handles.M_estim=M_estim;
bandas_estim=str2double(get(handles.B_estimacion_edit,'string'));
handles.bandas_estim=bandas_estim;
alfa_estim=str2double(get(handles.alfa_estimacion_edit,'string'));
handles.alfa_estim=alfa_estim;
gamma_estim=str2double(get(handles.gamma_estim_edit,'string'));
handles.gamma_estim=gamma_estim;

% Parametros del VAD

umbral_VAD=str2double(get(handles.um_VAD_edit,'string'));
handles.umbral_VAD=umbral_VAD;
l_cep=str2double(get(handles.l_cep_edit,'string'));
handles.l_cep=l_cep;
landa=str2double(get(handles.landa_edit,'string'));
handles.landa=landa;

% Parametros de la resta espectral

alfa_resta=str2double(get(handles.alfa_resta_edit,'string'));
handles.alfa_resta=alfa_resta;
gamma_resta=str2double(get(handles.gamma_resta_edit,'string'));
handles.gamma_resta=gamma_resta;

% Parametros de la rectificacion de media onda

beta_rectif=str2double(get(handles.beta_rectif_edit,'string'));
handles.beta_rectif=beta_rectif;

% Leemos los valores iniciales de los campos ventana,señal y metodo

handles.ventana_i=get(handles.ventana_popup,'Value');
handles.metodo=get(handles.metodo_menu,'Value');
handles.senales_i=get(handles.senales_menu,'Value');
handles.met_VAD=get(handles.metodos_VAD,'Value');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes resta_espectral wait for user response (see UIRESUME)
% uiwait(handles.main);

% --- Outputs from this function are returned to the command line.

function varargout = resta_espectral_OutputFcn(hObject, eventdata, handles)
    % varargout cell array for returning output args (see VARARGOUT);
    % hObject handle to figure
    % eventdata reserved - to be defined in a future version of MATLAB
    % handles structure with handles and user data (see GUIDATA)
    % Get default command line output from handles structure
    varargout{1} = handles.output;
    % --- Esta funcion se ejecuta al pulsar el boton play de la zona de señal
    % original
    function play_antes_btn_Callback(hObject, eventdata, handles)
        % hObject handle to play_antes_btn (see GCBO)
        % eventdata reserved - to be defined in a future version of MATLAB
        % handles structure with handles and user data (see GUIDATA)
        if handles.senales_i == 1
            fallo(3);
            return;
        end
        y = handles.senal;
        fs=handles.fs;
        sound(y,fs);
        % --- Esta funcion se ejecuta al pulsar el boton espectrograma de la zona
        % de señal original
        function fft_antes_btn_Callback(hObject, eventdata, handles)
        % hObject handle to fft_antes_btn (see GCBO)
        % eventdata reserved - to be defined in a future version of MATLAB
        % handles structure with handles and user data (see GUIDATA)
            if handles.senales_i == 1
                fallo(3);
                return;
            end
            if handles.ventana_i == 1
                fallo(1);
                return;
            end
            if isnan(str2double(get(handles.solap_edit,'string')))
                fallo(4);
                return;
            end
            nombre_vent=handles.nombres_vent{handles.ventana_i}
            n_fft=handles.n_fft;
            n_fft_2=n_fft/2;
            n_fft_1=n_fft-1;
            y=handles.senal;
            solapm=handles.solap;
            w=feval(nombre_vent,n_fft,'periodic');
            figure;
            specgram(y,n_fft,handles.fs,w,solapm);
            guidata(hObject,handles);
            % --- Esta funcion se ejcuta al pulsar play en la zona de señal restaurada
            function play_dspues_btn_Callback(hObject, eventdata, handles)
                % hObject handle to play_dspues_btn (see GCBO)
                % eventdata reserved - to be defined in a future version of MATLAB
                % handles structure with handles and user data (see GUIDATA)
                if handles.senales_i == 1
                    fallo(3);
                    return;
                end
                x = handles.final;
                fs=handles.fs;
                sound(x,fs);
                % --- Executes on button press in fft_dspues_btn.
                function fft_dspues_btn_Callback(hObject, eventdata, handles)
                    % hObject handle to fft_dspues_btn (see GCBO)
                    % eventdata reserved - to be defined in a future version of MATLAB
                    % handles structure with handles and user data (see GUIDATA)
                    n_fft=handles.n_fft;
                    n_fft_2=n_fft/2;
                    n_fft_1=n_fft-1;
                    x=handles.final;
                    solap=handles.solap;
                    nombre_vent=handles.nombres_vent{handles.ventana_i};
                    w=feval(nombre_vent,n_fft,'periodic');
                    figure;
                    specgram(x,n_fft,handles.fs,w,solap);
                    % --- Esta funcion se ejecuta cuando pulsamos el boton resta.
                    function resta_boton_Callback(hObject, eventdata, handles)
                        % hObject handle to resta_boton (see GCBO)
                        % eventdata reserved - to be defined in a future version of MATLAB
                        % handles structure with handles and user data (see GUIDATA)
                        % Comprobamos que haya informacion en todos los campos
                        if handles.senales_i == 1
                            fallo(3);
                            return;
                        end
                        if handles.ventana_i == 1
                            fallo(1);
                            return;
                        end
                        if isnan(str2double(get(handles.solap_edit,'string')))
                            fallo(4);
                            return;
                        end
                        if handles.metodo == 1
                            fallo(2);
                        return;
                        end
                        if handles.met_VAD == 1
                            fallo(5);
                            return;
                        end
                        aviso;
                        % Aparecera un aviso para indicar al usuario que espere mientras se realiza
                        % la resta
                        aviso
                        % Importamos variables de otras funciones a la funcion resta.
                        senal = handles.senal;
                        fs = handles.fs;
                        n_fft = handles.n_fft;
                        solap = handles.solap;
                        w = handles.ventana;
                        n = handles.n_estim;
                        M = handles.M_estim;
                        alfa_estim = handles.alfa_estim;
                        B = handles.bandas_estim;
                        gamma_estim = handles.gamma_estim;
                        beta_rectif = handles.beta_rectif;
                        gamma_resta = handles.gamma_resta;
                        alfa_resta = handles.alfa_resta;
                        umbral_VAD = handles.umbral_VAD;
                        metodo_VAD = handles.met_VAD;
                        l_cep = handles.l_cep;
                        landa = handles.landa;
                        bits = handles.bits;

                        
                        % Seleccionamos el metodo de resta espectral.

                        switch handles.metodo
                            case 1
                                return;
                            case 2 % Metodo de Boll
                                [x] = resta_boll(senal,n_fft,solap,w,n,metodo_VAD,bits,fs,l_cep,landa,alfa_estim, ...
                                umbral_VAD,alfa_resta,beta_rectif);
                            case 3 %Metodo de Berouti
                                [x] = resta_berouti(senal,n_fft,solap,w,n,metodo_VAD,bits,fs,l_cep,landa,umbral_VAD, ...
                                alfa_estim,gamma_resta,beta_rectif);
                            case 4 %Metodo de Lockwood y Boudy
                                [x] = resta_lb(senal,n_fft,solap,w,n,metodo_VAD,bits,fs,l_cep,landa,M,gamma_estim,umbral_VAD, ...
                                beta_rectif);
                            case 5 % Metodo de resta espectral multibanda
                                [x] = resta_mb(senal,n_fft,solap,w,n,metodo_VAD,bits,fs,l_cep,landa,umbral_VAD,alfa_estim, ...
                                B,beta_rectif);
                            case 6 % Metodo de resta espectral mejorada
                                [x] = resta_mejorada(senal,n_fft,solap,w,n,metodo_VAD,bits,fs,l_cep,landa,alfa_estim,umbral_VAD, ...
                                beta_rectif,gamma_resta);
                        end

                        % Cerramos la ventana de aviso
                        
                        close(aviso);
                        
                        %dibujamos el resultado de la resta
                        
                        axes(handles.modificado_ejes);
                        plot(x);
                        xx = get(handles.modificado_ejes,'xtick')/fs;
                        [cs,eu] = convert2engstrs(xx,'time');
                        set(handles.modificado_ejes,'xticklabel',cs);
                        set(handles.tiempo_despues_titulo,'string',['Tiempo, ' eu]);
                        set(handles.modificado_ejes,'XMinorTick','on');
                        grid on
                        handles.final=x;
                        guidata(hObject,handles);

                        % --- Executes during object creation, after setting all properties.
                        function metodo_menu_CreateFcn(hObject, eventdata, handles)
                            % hObject handle to metodo_menu (see GCBO)
                            % eventdata reserved - to be defined in a future version of MATLAB
                            % handles empty - handles not created until after all CreateFcns called

                            % Hint: popupmenu controls usually have a white background on Windows.
                            % See ISPC and COMPUTER.
                            if ispc
                                set(hObject,'BackgroundColor','white');
                            else
                                set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
                            end

                            % --- Con funcion leemos el metodo de resta espectral elegido

                            function metodo_menu_Callback(hObject, eventdata, handles)
                                % hObject handle to metodo_menu (see GCBO)
                                % eventdata reserved - to be defined in a future version of MATLAB
                                % handles structure with handles and user data (see GUIDATA)
    
                                % Hints: contents = get(hObject,'String') returns metodo_menu contents as cell array
                                % contents{get(hObject,'Value')} returns selected item from metodo_menu
                                metodo=get(hObject,'Value');% Almacenamos el numero de la seleccion
                                % Segun el metodo seleccionado habilitamos o deshabilitamos parametros
                                switch metodo
                                case 1

                                case 2 % Boll
                                    set(handles.M_estimacion_edit,'enable','off');
                                    set(handles.B_estimacion_edit,'enable','off');
                                    set(handles.gamma_resta_edit,'enable','off');
                                    set(handles.gamma_estim_edit,'enable','off');
                                    % habilitamos sus parametros
                                    set(handles.alfa_resta_edit,'enable','on');
                                    set(handles.alfa_estimacion_edit,'enable','on');
                                case 3 % Berouti
                                    set(handles.M_estimacion_edit,'enable','off');
                                    set(handles.B_estimacion_edit,'enable','off');
                                    set(handles.alfa_resta_edit,'enable','off');
                                    set(handles.gamma_estim_edit,'enable','off');
                                    % habilitamos sus parametros
                                    set(handles.alfa_estimacion_edit,'enable','on');
                                    set(handles.gamma_resta_edit,'enable','on');
                                case 4 % Lockwood y Boudy
                                    set(handles.B_estimacion_edit,'enable','off');
                                    set(handles.gamma_resta_edit,'enable','off');
                                    set(handles.alfa_resta_edit,'enable','off');
                                    set(handles.alfa_estimacion_edit,'enable','off');
                                    % habilitamos sus parametros
                                    set(handles.M_estimacion_edit,'enable','on');
                                    set(handles.gamma_estim_edit,'enable','on');
                                case 5 % Multibanda
                                    set(handles.gamma_estim_edit,'enable','off');
                                    set(handles.alfa_resta_edit,'enable','off');
                                    set(handles.M_estimacion_edit,'enable','off');
                                    set(handles.gamma_resta_edit,'enable','off');
                                    set(handles.gamma_estim_edit,'enable','off');
                                    % habilitamos sus parametros
                                    set(handles.B_estimacion_edit,'enable','on');
                                    set(handles.alfa_estimacion_edit,'enable','on');
                                case 6 % Mejorada
                                    set(handles.M_estimacion_edit,'enable','off');
                                    set(handles.B_estimacion_edit,'enable','off');
                                    set(handles.alfa_resta_edit,'enable','off');
                                    set(handles.gamma_estim_edit,'enable','off');
                                    % habilitamos sus parametros
                                    set(handles.alfa_estimacion_edit,'enable','on');
                                    set(handles.gamma_resta_edit,'enable','on');
                                end

                                handles.metodo=metodo;
                                guidata(hObject,handles);

                                % --- Executes during object creation, after setting all properties.
                                function senales_menu_CreateFcn(hObject, eventdata, handles)
                                    % hObject handle to senales_menu (see GCBO)
                                    % eventdata reserved - to be defined in a future version of MATLAB
                                    % handles empty - handles not created until after all CreateFcns called
                                   
                                    % Hint: popupmenu controls usually have a white background on Windows.
                                    % See ISPC and COMPUTER.
                                    if ispc
                                        set(hObject,'BackgroundColor','white');
                                    else
                                        set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
                                    end

                                    % --- Con esta funcion leemos la señal seleccionada por el usuario
                                   
                                    function senales_menu_Callback(hObject, eventdata, handles)
                                        % hObject handle to senales_menu (see GCBO)
                                        % eventdata reserved - to be defined in a future version of MATLAB
                                        % handles structure with handles and user data (see GUIDATA)
                                       
                                        % Hints: contents = get(hObject,'String') returns senales_menu contents as cell array
                                        % contents{get(hObject,'Value')} returns selected item from senales_menu
                                        
                                        % Leemos la señal elegida
                                        
                                        senales_i=get(hObject,'Value'); % Guardamos el valor de la señal elegida
                                        handles.senales_i=senales_i;
                                        switch get(handles.senales_menu,'Value')
                                            case 1
                                                senal=0;
                                                fs=0;
                                            case 2 % Señal de 1khz
                                                [senal,fs,bits] = wavread('1khz_ruido');
                                                % Señales de voz
                                            case 3
                                                [senal,fs,bits] = wavread('voz_paradas');
                                            case 4
                                                [senal,fs,bits] = wavread('voz_grandes_paradas');
                                            case 5
                                                [senal,fs,bits] = wavread('voz_sin_paradas');
                                            case 6
                                                [senal,fs,bits] = wavread('voz_mucho_ruido');
                                        end
                                        handles.bits=bits;
                                        
                                        % Calculamos el Numero de puntos
                                        
                                        n_fft=fs*(0.02);
                                        if n_fft==0
                                            n_fft=0;
                                        elseif( (n_fft>0) & (n_fft<=2))
                                            n_fft=2;
                                        elseif ( (n_fft>2) & (n_fft <=4))
                                            n_fft=4;
                                        elseif ( (n_fft>4) & (n_fft <=8))
                                            n_fft=8;
                                        elseif ( (n_fft>8) & (n_fft <=16))
                                            n_fft=16;
                                        elseif ( (n_fft>16) & (n_fft <=32))
                                            n_fft=32;
                                        elseif ( (n_fft>32) & (n_fft <=64))
                                            n_fft=64;
                                        elseif ( (n_fft>64) & (n_fft <=128))
                                            n_fft=128;
                                        elseif ( (n_fft>128) & (n_fft <=256))
                                            n_fft=256;
                                        elseif ( (n_fft>256) & (n_fft <=512))
                                            n_fft=512;
                                        elseif ( (n_fft>512) & (n_fft <=1024))
                                            n_fft=1024;
                                        elseif ( (n_fft>1024) & (n_fft <=2048))
                                            n_fft=2048;
                                        else
                                            n_fft=4092;
                                        end
                                        
                                        % dibujamos la señal elegida
                                        
                                        axes(handles.original_ejes);
                                        plot(senal);
                                        
                                        % para que no ponga inf y Nan en los ejes
                                        
                                        if fs>0
                                            yy=get(handles.original_ejes,'xtick')/fs;
                                            [cs,eu] = convert2engstrs(yy,'time');
                                            set(handles.original_ejes,'xticklabel',cs);
                                            set(handles.tiempo_ant_titulo,'string',['Tiempo, ' eu]);
                                            set(handles.original_ejes,'XMinorTick','on');
                                            grid on
                                        end

                                        handles.senal=senal;
                                        handles.fs=fs;
                                        set(handles.fs_edit,'string',fs);
                                        handles.n_fft=n_fft;
                                        set(handles.puntos_fft_edit,'string',n_fft);
                                        guidata(hObject,handles);

                                        % --- Executes during object creation, after setting all properties.
                                        function puntosFFT_edit_CreateFcn(hObject, eventdata, handles)
                                            % hObject handle to puntosFFT_edit (see GCBO)
                                            % eventdata reserved - to be defined in a future version of MATLAB
                                            % handles empty - handles not created until after all CreateFcns called
                                            
                                            % Hint: edit controls usually have a white background on Windows.
                                            % See ISPC and COMPUTER.
                                            if ispc
                                                set(hObject,'BackgroundColor','white');
                                            else
                                                set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
                                            end

                                            function puntosFFT_edit_Callback(hObject, eventdata, handles)
                                                % hObject handle to puntosFFT_edit (see GCBO)
                                                % eventdata reserved - to be defined in a future version of MATLAB
                                                % handles structure with handles and user data (see GUIDATA)
                                            
                                                % Hints: get(hObject,'String') returns contents of puntosFFT_edit as text
                                                % str2double(get(hObject,'String')) returns contents of puntosFFT_edit as a double
                                                
                                                % --- Executes during object creation, after setting all properties.
                                                function alfa_estimacion_edit_CreateFcn(hObject, eventdata, handles)
                                                    % hObject handle to alfa_estimacion_edit (see GCBO)
                                                    % eventdata reserved - to be defined in a future version of MATLAB
                                                    % handles empty - handles not created until after all CreateFcns called
                                                    % Hint: edit controls usually have a white background on Windows.
                                                    % See ISPC and COMPUTER.
                                                    if ispc
                                                        set(hObject,'BackgroundColor','white');
                                                    else
                                                        set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
                                                    end
                                                    function alfa_estimacion_edit_Callback(hObject, eventdata, handles)
                                                    % hObject handle to alfa_estimacion_edit (see GCBO)
                                                    % eventdata reserved - to be defined in a future version of MATLAB
                                                    % handles structure with handles and user data (see GUIDATA)
                                                  
                                                    % Hints: get(hObject,'String') returns contents of alfa_estimacion_edit as text
                                                    % str2double(get(hObject,'String')) returns contents of alfa_estimacion_edit as a double
                                                    
                                                    alfa_estim=str2double(get(hObject,'string'));
                                                    handles.alfa_estim=alfa_estim;
                                                    guidata(hObject,handles);
                                                    
                                                    % --- Executes during object creation, after setting all properties.
                                                    
                                                    function um_VAD_edit_CreateFcn(hObject, eventdata, handles)
                                                        % hObject handle to um_VAD_edit (see GCBO)
                                                        % eventdata reserved - to be defined in a future version of MATLAB
                                                        % handles empty - handles not created until after all CreateFcns called
                                                        % Hint: edit controls usually have a white background on Windows.
                                                        % See ISPC and COMPUTER.
                                                        if ispc
                                                            set(hObject,'BackgroundColor','white');
                                                        else
                                                            set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
                                                        end
                                                        function um_VAD_edit_Callback(hObject, eventdata, handles)
                                                            % hObject handle to um_VAD_edit (see GCBO)
                                                            % eventdata reserved - to be defined in a future version of MATLAB
                                                            % handles structure with handles and user data (see GUIDATA)
                                                          
                                                            % Hints: get(hObject,'String') returns contents of um_VAD_edit as text
                                                            % str2double(get(hObject,'String')) returns contents of um_VAD_edit as a double
                                                            
                                                            umbral_VAD=str2double(get(hObject,'string'));
                                                            handles.umbral_VAD=umbral_VAD;
                                                            guidata(hObject,handles);
                                                            
                                                            % --- Executes during object creation, after setting all properties.
                                                            function alfa_resta_edit_CreateFcn(hObject, eventdata, handles)
                                                                % hObject handle to alfa_resta_edit (see GCBO)
                                                                % eventdata reserved - to be defined in a future version of MATLAB
                                                                % handles empty - handles not created until after all CreateFcns called
                                                                
                                                                % Hint: edit controls usually have a white background on Windows.
                                                                % See ISPC and COMPUTER.
                                                                
                                                                if ispc
                                                                    set(hObject,'BackgroundColor','white');
                                                                else
                                                                    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
                                                                end
                                                                
                                                                function alfa_resta_edit_Callback(hObject, eventdata, handles)
                                                                % hObject handle to alfa_resta_edit (see GCBO)
                                                                % eventdata reserved - to be defined in a future version of MATLAB
                                                                % handles structure with handles and user data (see GUIDATA)
                                                              
                                                                % Hints: get(hObject,'String') returns contents of alfa_resta_edit as text
                                                                % str2double(get(hObject,'String')) returns contents of alfa_resta_edit as a double
                                                                
                                                                alfa_resta=str2double(get(hObject,'string'));
                                                                handles.alfa_resta=alfa_resta;
                                                                guidata(hObject,handles);
                                                                
                                                                % --- Executes during object creation, after setting all properties.
                                                                function gamma_resta_edit_CreateFcn(hObject, eventdata, handles)
                                                                    % hObject handle to gamma_resta_edit (see GCBO)
                                                                    % eventdata reserved - to be defined in a future version of MATLAB
                                                                    % handles empty - handles not created until after all CreateFcns called
                                                              
                                                                    % Hint: edit controls usually have a white background on Windows.
                                                                    %   See ISPC and COMPUTER.
                                                                    if ispc
                                                                        set(hObject,'BackgroundColor','white');
                                                                    else
                                                                        set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
                                                                    end

                                                                    function gamma_resta_edit_Callback(hObject, eventdata, handles)
                                                                        % hObject handle to gamma_resta_edit (see GCBO) 
                                                                        % eventdata reserved - to be defined in a future version of MATLAB
                                                                        % handles structure with handles and user data (see GUIDATA)

                                                                        % Hints: get(hObject,'String') returns contents of gamma_resta_edit as text
                                                                        % str2double(get(hObject,'String')) returns contents of gamma_resta_edit as a double
                                                                        
                                                                        gamma_resta=str2double(get(hObject,'string'));
                                                                        handles.gamma_resta=gamma_resta;
                                                                        guidata(hObject,handles);
                                                                      
                                                                        % --- Executes during object creation, after setting all properties.
                                                                        function n_estimacion_edit_CreateFcn(hObject, eventdata, handles)
                                                                            % hObject handle to n_estimacion_edit (see GCBO)
                                                                            % eventdata reserved - to be defined in a future version of MATLAB
                                                                            % handles empty - handles not created until after all CreateFcns called
                                                                        
                                                                            % Hint: edit controls usually have a white background on Windows.
                                                                            % See ISPC and COMPUTER.
                                                                            
                                                                            if ispc
                                                                                set(hObject,'BackgroundColor','white');
                                                                            else
                                                                                set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
                                                                            end

                                                                            function n_estimacion_edit_Callback(hObject, eventdata, handles)
                                                                                % hObject handle to n_estimacion_edit (see GCBO)
                                                                                % eventdata reserved - to be defined in a future version of MATLAB
                                                                                % handles structure with handles and user data (see GUIDATA)
                                                                               
                                                                                % Hints: get(hObject,'String') returns contents of n_estimacion_edit as text
                                                                                % str2double(get(hObject,'String')) returns contents of
                                                                                % n_estimacion_edit as a double
                                                                                
                                                                                n_estim=str2double(get(hObject,'string'));
                                                                                handles.n_estim=n_estim;
                                                                                guidata(hObject,handles);
                                                                                
                                                                                % --- Executes during object creation, after setting all properties.
                                                                                function B_estimacion_edit_CreateFcn(hObject, eventdata, handles)
                                                                                    % hObject handle to B_estimacion_edit (see GCBO)
                                                                                    % eventdata reserved - to be defined in a future version of MATLAB
                                                                                    % handles empty - handles not created until after all CreateFcns called
                                                                                    
                                                                                    % Hint: edit controls usually have a white background on Windows.
                                                                                    % See ISPC and COMPUTER.
                                                                                    
                                                                                    if ispc
                                                                                        set(hObject,'BackgroundColor','white');
                                                                                    else
                                                                                        set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
                                                                                    end

                                                                                    function B_estimacion_edit_Callback(hObject, eventdata, handles)
                                                                                        % hObject handle to B_estimacion_edit (see GCBO)
                                                                                        % eventdata reserved - to be defined in a future version of MATLAB
                                                                                        % handles structure with handles and user data (see GUIDATA)
                                                                                    
                                                                                        % Hints: get(hObject,'String') returns contents of B_estimacion_edit as text
                                                                                        % str2double(get(hObject,'String')) returns contents of
                                                                                        % B_estimacion_edit as a double

                                                                                        bandas_estim=str2double(get(hObject,'string'));
                                                                                        handles.bandas_estim=bandas_estim;
                                                                                        guidata(hObject,handles);
                                                                                        
                                                                                        % --- Executes during object creation, after setting all properties.
                                                                                        function ventana_popup_CreateFcn(hObject, eventdata, handles)
                                                                                            % hObject handle to ventana_popup (see GCBO)
                                                                                            % eventdata reserved - to be defined in a future version of MATLAB
                                                                                            % handles empty - handles not created until after all CreateFcns called
                                                                                            
                                                                                            % Hint: popupmenu controls usually have a white background on Windows.
                                                                                            % See ISPC and COMPUTER.
                                                                                            
                                                                                            if ispc
                                                                                              set(hObject,'BackgroundColor','white');
                                                                                            else
                                                                                                set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
                                                                                            end

                                                                                            % --- Leemos la ventana seleccionada y la calculamos
                                                                                            
                                                                                            function ventana_popup_Callback(hObject, eventdata, handles)
                                                                                                % hObject handle to ventana_popup (see GCBO)
                                                                                                % eventdata reserved - to be defined in a future version of MATLAB
                                                                                                % handles structure with handles and user data (see GUIDATA)
                                                                                            
                                                                                                % Hints: contents = get(hObject,'String') returns ventana_popup contents as cell array
                                                                                                % contents{get(hObject,'Value')} returns selected item from ventana_popup
                                                                                                
                                                                                                n_fft=handles.n_fft;
                                                                                                ind=get(hObject,'Value');% para los errores
                                                                                                handles.ventana_i=ind;
                                                                                                handles.nombres_vent=get(hObject,'string');
                                                                                                
                                                                                                % Calculamos la ventana seleccionada
                                                                                                
                                                                                                switch ind
                                                                                                
                                                                                                    case 1
                                                                                                        guidata(hObject,handles);
                                                                                                        return;
                                                                                                    case 2 %'Hanning'
                                                                                                        ventana=hanning(n_fft);
                                                                                                    case 3 %'Hamming'
                                                                                                        ventana=hamming(n_fft);
                                                                                                    case 4 %'Blackman'
                                                                                                        ventana=blackman(n_fft);
                                                                                                    case 5 %'Rectwin'
                                                                                                        ventana=rectwin(n_fft);
                                                                                                    case 6 %'Bartlett'
                                                                                                        ventana=bartlett(n_fft);
                                                                                                end
                                                                                                handles.ventana=ventana;% enventanado
                                                                                                guidata(hObject,handles);
                                                                                                
                                                                                                % --- Executes during object creation, after setting all properties.
                                                                                                function solap_edit_CreateFcn(hObject, eventdata, handles)
                                                                                                    % hObject handle to solap_edit (see GCBO)
                                                                                                    % eventdata reserved - to be defined in a future version of MATLAB
                                                                                                    % handles empty - handles not created until after all CreateFcns called
                                                                                                    
                                                                                                    % Hint: edit controls usually have a white background on Windows.
                                                                                                    % See ISPC and COMPUTER.
                                                                                                    if ispc
                                                                                                        set(hObject,'BackgroundColor','white');
                                                                                                    else
                                                                                                        set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
                                                                                                    end
                                                                                                    
                                                                                                    function solap_edit_Callback(hObject, eventdata, handles)
                                                                                                        % hObject handle to solap_edit (see GCBO)
                                                                                                        % eventdata reserved - to be defined in a future version of MATLAB
                                                                                                        % handles structure with handles and user data (see GUIDATA)
                                                                                                        % Hints: get(hObject,'String') returns contents of solap_edit as text
                                                                                                        % str2double(get(hObject,'String')) returns contents of solap_edit as a double
                                                                                                        if handles.senales_i == 1
                                                                                                            fallo(3);
                                                                                                            return;
                                                                                                        end
                                                                                                        solapm=str2double(get(hObject,'string')) ;
                                                                                                        handles.solap=solapm;
                                                                                                        guidata(hObject,handles);
                                                                                                        % --- Executes during object creation, after setting all properties.
                                                                                                        function beta_rectif_edit_CreateFcn(hObject, eventdata, handles)
                                                                                                            % hObject handle to beta_rectif_edit (see GCBO)
                                                                                                            % eventdata reserved - to be defined in a future version of MATLAB
                                                                                                            % handles empty - handles not created until after all CreateFcns called
                                                                                                            % Hint: edit controls usually have a white background on Windows.
                                                                                                            % See ISPC and COMPUTER.
                                                                                                            if ispc
                                                                                                                set(hObject,'BackgroundColor','white');
                                                                                                            else
                                                                                                                set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
                                                                                                            end
                                                                                                            function beta_rectif_edit_Callback(hObject, eventdata, handles)
                                                                                                                % hObject handle to beta_rectif_edit (see GCBO)
                                                                                                                % eventdata reserved - to be defined in a future version of MATLAB
                                                                                                                % handles structure with handles and user data (see GUIDATA)
                                                                                                                % Hints: get(hObject,'String') returns contents of beta_rectif_edit as text
                                                                                                                % str2double(get(hObject,'String')) returns contents of
                                                                                                                % beta_rectif_edit as a double
                                                                                                                beta_rectif=str2double(get(hObject,'string'));
                                                                                                                handles.beta_rectif=beta_rectif;
                                                                                                                guidata(hObject,handles);
                                                                                                                % --- Executes during object creation, after setting all properties.
                                                                                                                function M_estimacion_edit_CreateFcn(hObject, eventdata, handles)
                                                                                                                    % hObject handle to M_estimacion_edit (see GCBO)
                                                                                                                    % eventdata reserved - to be defined in a future version of MATLAB
                                                                                                                    % handles empty - handles not created until after all CreateFcns called
                                                                                                                    % Hint: edit controls usually have a white background on Windows.
                                                                                                                    % See ISPC and COMPUTER.
                                                                                                                    if ispc
                                                                                                                        set(hObject,'BackgroundColor','white');
                                                                                                                    else
                                                                                                                        set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
                                                                                                                    end
                                                                                                                    function M_estimacion_edit_Callback(hObject, eventdata, handles)
                                                                                                                        % hObject handle to M_estimacion_edit (see GCBO)
                                                                                                                        % eventdata reserved - to be defined in a future version of MATLAB
                                                                                                                        % handles structure with handles and user data (see GUIDATA)
                                                                                                                        % Hints: get(hObject,'String') returns contents of M_estimacion_edit as text
                                                                                                                        % str2double(get(hObject,'String')) returns contents of
                                                                                                                        % M_estimacion_edit as a double
                                                                                                                        M_estim=str2double(get(hObject,'string'));
                                                                                                                        handles.M_estim=M_estim;
                                                                                                                        guidata(hObject,handles);
                                                                                                                        % --- Executes during object creation, after setting all properties.
                                                                                                                        function gamma_estim_edit_CreateFcn(hObject, eventdata, handles)
                                                                                                                            % hObject handle to gamma_estim_edit (see GCBO)
                                                                                                                            % eventdata reserved - to be defined in a future version of MATLAB
                                                                                                                            % handles empty - handles not created until after all CreateFcns called
                                                                                                                            % Hint: edit controls usually have a white background on Windows.
                                                                                                                            % See ISPC and COMPUTER.
                                                                                                                            if ispc
                                                                                                                                set(hObject,'BackgroundColor','white');
                                                                                                                            else
                                                                                                                                set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
                                                                                                                            end
                                                                                                                            function gamma_estim_edit_Callback(hObject, eventdata, handles)
                                                                                                                                % hObject handle to gamma_estim_edit (see GCBO)
                                                                                                                                % eventdata reserved - to be defined in a future version of MATLAB
                                                                                                                                % handles structure with handles and user data (see GUIDATA)
                                                                                                                                % Hints: get(hObject,'String') returns contents of gamma_estim_edit as text
                                                                                                                                % str2double(get(hObject,'String')) returns contents of gamma_estim_edit as a double
                                                                                                                                gamma_estim=str2double(get(hObject,'string'));
                                                                                                                                handles.gamma_estim=gamma_estim;
                                                                                                                                guidata(hObject,handles);
                                                                                                                                %funcion fallo, recoge los fallos debidos a campos sin rellenar
                                                                                                                                function fallo (tipo)
                                                                                                                                    switch tipo
                                                                                                                                    case 1
                                                                                                                                    msgbox('Introducir un tipo de Ventana','CAMPO VACIO','error');
                                                                                                                                    case 2
                                                                                                                                    msgbox('Introducir un Metodo de Resta Espectral','CAMPO VACIO','error');
                                                                                                                                    case 3
                                                                                                                                    msgbox('Introducir un tipo de señal para evaluar','CAMPO VACIO','error');
                                                                                                                                    case 4
                                                                                                                                        msgbox('Introducir el procentaje de solapamiento','CAMPO VACIO','error');
                                                                                                                                    case 5
                                                                                                                                    msgbox('Introducir un Metodo de Deteccion de actividad vocal','CAMPO VACIO','error');
end
% Funcion que nos permite variar el tamaño de la ventana resta_espectral
function ResizeFcn(hObject, eventdata, handles)
% Get the figure size and position
Figure_Size = get(hObject, 'Position');
% Set the figure's original size in character units
Original_Size = [ 0 0 94 19.230769230769234];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% metodos de resta espectral
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Resta espectral segun boll79
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [x] = resta_boll(y,n_fft,solp,w,n,met_VAD,bits,fs,l_cep,landa,alfa,limite,a,beta)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Constantes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
puntos = n_fft;
puntos_1 = puntos-1;
puntos_2 = puntos/2;
r_unos = ones(puntos,1);
c = 10^(-30/20); % Atenuacion de la señal durante los momentos
% sin actividad vocal (Constante de atenuacion)
solapamiento = puntos-solp; % numero que tendremos que poner durante el
% enventanado para que se produzca el solapamiento
% de "solp"(numero de muestras solapadas)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FFT de las señales con el solapamaiento indicado por el usuario
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
j = 1; % Indica el numero de tramas de Y teniendo cada una de ellas
% "puntos" filas
for t = 1:solapamiento:(length(y)-puntos)
Y(:,j) = fft (w.*y(t:(t+puntos_1))); % puntos de la FFT = muestras usadas.
modulo_Y(:,j) = abs(Y(:,j)); % devuelve el modulo
fase_Y(:,j) = angle(Y(:,j)); % devuelve la fase en radianes
j = j+1;
end
Y = modulo_Y; % Modulo de la FFT
% filas = numero de puntos de la FFT
% columnas = j
tramas = size(Y,2); % numero de tramas
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Promediado de la señal de entrada :
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Llevaremos a cabo el promediado de 3 tramas la actual, con la anterior
% y la posterior
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Y_promedio = Y;
for t = 2:(tramas-1) % empieza por 2 por el t-1 de despues
% para no dar un indice = 0
Y_promedio(:,t) = mean(Y(:,(t-1):(t+1)),2); % Promediado de 3 tramas
end
Y = Y_promedio;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Estimacion de ruido + VAD(Detector de Actividad Vocal)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Suponemos que las primeras tramas de señal van a ser ruido
r_media = Y(:,n); % Inicializamos r_media con "n" introducida por el
% usuario. Esta es una de las primeras tramas.
% Es aconsejable no tomar n = 1 ya que seguramente esta no
% represente correctamente el ruido que tendremos en la
% señal.
% Aplicamos el metodo de VAD seleccionado por el usuario
switch met_VAD
case 2
D_voz = vad_boll(Y,limite,n);
case 3
D_voz = vad_ZCR(y,puntos,bits,fs); % n_fft se corresponde con el tamaño de
% la ventana de analisis
case 4
D_voz = vad_homo(Y,puntos,l_cep,landa);
end
i = 0;
for t = 1:tramas
if D_voz(t) == 0 % Aquellos valores iguales a cero los entenderemos como ruido(VAD)
i = i+1; % numero de ventanas sin voz del array ruido i = n-2;
r_media = alfa*r_media + (1-alfa)*Y(:,t);
n = n+1; % numero de ventanas sin voz
Y(:,t) = c*Y(:,t); % Reemplazar estos por cuadros con ruido atenuado
Array_ruido(:,i) = Y(:,t);
end
end
r_media = abs(r_media);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculo de la maxima desviacion para usar en el paso de reduccion de
% ruido residual. ruido residual = Array_ruido - r_media
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
r = r_media*ones(1,i);
r_residual = max(Array_ruido(:,1:i)-r,[],2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Resta espectral
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
X = Y - a*r_media*ones(1,size(Y,2)); %256*i = 256*i - (256*1 - 256*1)*(1*i)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Rectificacion de media onda
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
umbral_ruido = beta*Y; %(256*1)*(1*i)==> n_flor = 256*i
[I,J] = find(X < umbral_ruido);
X(sub2ind(size(X),I,J)) = umbral_ruido(sub2ind(size(X),I,J));% Devuelve las filas y las columnas
% de la entrada segun la condicion entre parentesis.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Restamos el ruido residual
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Un tipo de filtrado de media
% Si el ruido es menor que N_r, usaremos el valor minimo mas cercano
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
X_rr = X;
for t = 2:(tramas-1)
I = find(X(:,t) < r_residual + r_unos); % Solo nos da filas.
X_rr(I,t) = min (X(I,(t-1:t+1)),[],2);
end
X = X_rr;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Volver al dominio temporal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x = zeros(length(y),1); % N*1
k = sqrt(-1);
s = 1;
for t = 1:solapamiento:(length(y)-puntos)
x(t:t+puntos_1) = x(t:t+puntos_1) + real(ifft(X(:,s).*exp(k*fase_Y(:,s))));
s = s+1;
end
% x es un array del tipo N*1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Resta espectral segun Berouti
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [x] = resta_berouti(y,n_fft,solp,w,n,met_VAD,bits,fs,l_cep,landa,limite,alfa,gamma,beta)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Constantes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
puntos = n_fft;
puntos_1 = puntos-1;
puntos_2 = puntos/2;
r_unos = ones(puntos,1);
alfa_1=1-alfa;
c = 10^(-30/20); % Atenuacion de la señal durante los momentos
% sin actividad vocal (Constante de atenuacion)
solapamiento = puntos-solp; % numero que tendremos que poner durante el
% enventanado para que se produzca el solapamiento
% de "solp"(numero de muestras solapadas)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FFT de las señales con el solapamaiento indicado por el usuario
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
j = 1; % Indica el numero de tramas de Y teniendo cada una de ellas
% "puntos" filas
for t = 1:solapamiento:(length(y)-puntos)
Y(:,j) = fft (w.*y(t:(t+puntos_1))); % puntos de la FFT = muestras usadas.
modulo_Y(:,j) = abs(Y(:,j)); % devuelve el modulo
fase_Y(:,j) = angle(Y(:,j)); % devuelve la fase en radianes
j = j+1;
end
Y = modulo_Y; % Modulo de la FFT
% filas = numero de puntos de la FFT
% columnas = j
tramas=size(Y,2); % numero de tramas
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Promediado de la señal de entrada :
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Llevaremos a cabo el promediado de 3 tramas la actual, con la anterior
% y la posterior
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Y_promedio = Y;
for t = 2:(tramas-1) % empieza por 2 por el t-1 de despues para no
% dar un indice = 0
Y_promedio(:,t) = mean(Y(:,(t-1):(t+1)),2); % Promediado de 3 tramas
end
Y = Y_promedio;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Estimacion de ruido + VAD(Detector de Actividad Vocal)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Suponemos que las primeras tramas de señal van a ser ruido
r_media = Y(:,n); % Inicializamos r_media con "n" introducida por el
% usuario. Esta es una de las primeras tramas.
% Es aconsejable no tomar n = 1 ya que seguramente esta no
% represente correctamente el ruido que tendremos en la
% señal.
% Aplicamos el metodo de VAD seleccionado por el usuario
switch met_VAD
case 2
D_voz = vad_boll(Y,limite,n);
case 3
D_voz = vad_ZCR(y,puntos,bits,fs); % n_fft se corresponde con el tamaño de la ventana de analisis
case 4
D_voz = vad_homo(Y,puntos,l_cep,landa);
end
i = 0;
for t = 1:tramas
if D_voz(t) == 0 % Aquellos valores iguales a cero los entenderemos como ruido(VAD)
i = i+1; % numero de ventanas sin voz del array ruido i = n-2;
r_media = alfa*r_media + alfa_1*Y(:,t);
n = n+1; % numero de ventanas sin voz
Y(:,t) = c*Y(:,t); % Reemplazar estos por cuadros con ruido atenuado
Array_ruido(:,i) = Y(:,t);
end
end
r_media=abs(r_media);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculo de la maxima desviacion para usar en el paso de reduccion de
% ruido residual. ruido residual = Array_ruido - r_media
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
r = r_media*ones(1,i);
r_residual = max(Array_ruido(:,1:i)-r,[],2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Resta espectral
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Suma de los valores de N_mean
suma_r=sum(r_media.^2);
% Suma de los valores de Y
suma_Y=sum((Y.^2),1);
% Calculo de a_SNR segun version 2 con cuadrados
for t = 1:tramas
SNR(t) = 10*log10(suma_Y(t)/suma_r);
if (SNR(t) < -5)
    a_SNR(t) = 4.75;
elseif (SNR(t) > 20)
a_SNR(t) = 1;
else
a_SNR(t) = 4 - ((3/20)*SNR(t)) ;
end
Trama(:,t) = Y(:,t).^(2*gamma) - (a_SNR(t)* ((r_media.^(2*gamma))) );
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Rectificacion de media onda
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
umbral_ruido = beta*abs(Y);
X = Trama.^(1/(2*gamma));
[I,J]=find(X < umbral_ruido);
X(sub2ind(size(X),I,J)) = umbral_ruido(sub2ind(size(X),I,J));% Devuelve las filas y las
% columnas de la entrada
% segun la condicion entre
% parentesis.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Restamos el ruido residual
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Un tipo de filtrado de media
% Si el ruido es menor que N_r, usaremos el valor minimo mas cercano
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
X_rr = X;
for t = 2:(tramas-1)
I = find(X(:,t) < r_residual + r_unos); % Solo nos da filas.
X_rr(I,t) = min (X(I,(t-1:t+1)),[],2);
end
X = X_rr;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Volver al dominio temporal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x = zeros(length(y),1); % N*1
k = sqrt(-1);
s = 1;
for t = 1:solapamiento:(length(y)-puntos)
x(t:t+puntos_1) = x(t:t+puntos_1) + real(ifft(X(:,s).*exp(k*fase_Y(:,s))));
s = s+1;
end
% x es un array del tipo N*1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Resta espectral segun Lockwood y Boudy
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [x] = resta_lb(y,n_fft,solp,w,n,met_VAD,bits,fs,l_cep,landa,M,gamma,limite,beta)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Constantes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
puntos = n_fft;
puntos_1 = puntos-1;
puntos_2 = puntos/2;
r_unos = ones(puntos,1);
c = 10^(-30/20); % Atenuacion de la señal durante los momentos
% sin actividad vocal (Constante de atenuacion)
solapamiento = puntos-solp; % numero que tendremos que poner durante el
% enventanado para que se produzca el solapamiento
% de "solp"(numero de muestras solapadas)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FFT de las señales con el solapamaiento indicado por el usuario
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
j = 1; % Indica el numero de tramas de Y teniendo cada una de ellas
% "puntos" filas
for t = 1:solapamiento:(length(y)-puntos)
Y(:,j) = fft (w.*y(t:(t+puntos_1))); % puntos de la FFT = muestras usadas.
modulo_Y(:,j) = abs(Y(:,j)); % devuelve el modulo
fase_Y(:,j) = angle(Y(:,j)); % devuelve la fase en radianes
j = j+1;
end
Y = modulo_Y; % Modulo de la FFT
% filas = numero de puntos de la FFT
% columnas = j
tramas=size(Y,2); % numero de tramas
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Promediado de la señal de entrada :
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Llevaremos a cabo el promediado de 3 tramas la actual, con la anterior
% y la posterior
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Y_promedio = Y;
for t = 2:(tramas-1) % empieza por 2 por el t-1 de despues para no
% dar un indice = 0
Y_promedio(:,t) = mean(Y(:,(t-1):(t+1)),2); % Promediado de 3 tramas
end
Y = Y_promedio;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Estimacion de ruido + VAD(Detector de Actividad Vocal)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Suponemos que las primeras tramas de señal van a ser ruido
r_media = Y(:,n); % Inicializamos r_media con "n" introducida por el
% usuario. Esta es una de las primeras tramas.
% Es aconsejable no tomar n = 1 ya que seguramente esta no
% represente correctamente el ruido que tendremos en la
% señal.
% Aplicamos el metodo de VAD seleccionado por el usuario
switch met_VAD
case 2
D_voz = vad_boll(Y,limite,n);
case 3
D_voz = vad_ZCR(y,puntos,bits,fs); % n_fft se corresponde con el tamaño de la ventana de analisis
case 4
D_voz = vad_homo(Y,puntos,l_cep,landa);
end
i = 0;
for t = 1:tramas
if D_voz(t) == 0 % Aquellos valores iguales a cero los entenderemos como ruido(VAD)
i = i+1 % numero de ventanas sin voz del array ruido i = n-2;
n = n+1; % numero de ventanas sin voz
Y(:,t) = c*Y(:,t); % Reemplazar estos por cuadros con ruido atenuado
Array_ruido(:,i) = Y(:,t);
end % end if
SNR(:,t)=10*log10((Y(:,t))./Array_ruido(:,i));
for f=1:puntos
if (SNR(f,t) < -5)
a_SNR(f,t) = 5;
elseif (SNR(f,t) > 20)
a_SNR(f,t) = 1;
else
a_SNR(f,t) = 4 - ((3/20).*SNR(f,t)) ;
end
end % end for frecuencias
end % end for Tramas
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Alfa_i:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% maximo valor de los ultimos M espectros
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
r=1;
i_M=i-M;
for t = i_M:i
aux_i(:,r)=Array_ruido(:,t);
r=r+1;
end
for f = 1:puntos
alfa_i(f) = max(aux_i(f,:),[],2);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculo de Ruido
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
SNR=gamma.*SNR; % gamma = parametro de diseño
alfa_i=alfa_i';
for t = 1:tramas
r_media(:,t) = alfa_i ./ (1+SNR(:,t));
end
r_media=abs(r_media);
%%%%%%%%%%%%%%%%%%%
% Resta espectral %
%%%%%%%%%%%%%%%%%%%
X = Y - a_SNR.*r_media;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Rectificacion de media onda %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
umbral_ruido = beta*Y; %(256*1)*(1*i)==> n_flor = 256*i
[I,J] = find(X < umbral_ruido);
X(sub2ind(size(X),I,J)) = umbral_ruido(sub2ind(size(X),I,J));% Devuelve las filas y las columnas
% de la entrada segun la condicion entre parentesis.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Volver al dominio temporal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x = zeros(length(y),1); % N*1
k = sqrt(-1);
s = 1;
for t = 1:solapamiento:(length(y)-puntos)
x(t:t+puntos_1) = x(t:t+puntos_1) + real(ifft(X(:,s).*exp(k*fase_Y(:,s))));
s = s+1;
end
% x es un array del tipo N*1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Resta espectral multibanda
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [x] = resta_mb(y,n_fft,solp,w,n,met_VAD,bits,fs,l_cep,landa,limite,a,B,beta);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Constantes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
puntos = n_fft;
puntos_1 = puntos-1;
puntos_2 = puntos/2;
a_1=1-a;
r_unos = ones(puntos,1);
c = 10^(-30/20); % Atenuacion de la señal durante los momentos
% sin actividad vocal (Constante de atenuacion)
solapamiento = puntos-solp; % numero que tendremos que poner durante el
% enventanado para que se produzca el solapamiento
% de "solp"(numero de muestras solapadas)
AB=puntos/(2*B); % Ancho de banda teniendo en cuenta el espectro
% negativo
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FFT de las señales con el solapamaiento indicado por el usuario
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
j = 1; % Indica el numero de tramas de Y teniendo cada una de ellas
% "puntos" filas
for t = 1:solapamiento:(length(y)-puntos)
Y(:,j) = fft (w.*y(t:(t+puntos_1))); % puntos de la FFT = muestras usadas.
modulo_Y(:,j) = abs(Y(:,j)); % devuelve el modulo
fase_Y(:,j) = angle(Y(:,j)); % devuelve la fase en radianes
j = j+1;
end
Y = modulo_Y; % Modulo de la FFT
% filas = numero de puntos de la FFT
% columnas = j
tramas=size(Y,2); % numero de tramas
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Promediado de la señal de entrada :
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Llevaremos a cabo el promediado de 3 tramas la actual, con la anterior
% y la posterior
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Y_promedio = Y;
    for t = 2:(tramas-1) %empieza por 2 por el t-1 de despues para no dar un indice = 0
    Y_promedio(:,t) = mean(Y(:,(t-1):(t+1)),2); % Promediado de 3 tramas
    end
Y = Y_promedio;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Estimacion de ruido + VAD(Detector de Actividad Vocal)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Suponemos que las primeras tramas de señal van a ser ruido
r_media = Y(:,n); % Inicializamos r_media con "n" introducida por el
% usuario. Esta es una de las primeras tramas.
% Es aconsejable no tomar n = 1 ya que seguramente esta no
% represente correctamente el ruido que tendremos en la
% señal.
% Aplicamos el metodo de VAD seleccionado por el usuario
switch met_VAD
    case 2
    D_voz = vad_boll(Y,limite,n);
    case 3
    D_voz = vad_ZCR(y,puntos,bits,fs); % n_fft se corresponde con el
    % tamaño de la ventana de analisis
    case 4
    D_voz = vad_homo(Y,puntos,l_cep,landa);
    end
i = 0;
B = 2*B;
f = fs/puntos*(0:puntos_1);
    for t = (n+1):tramas
        if D_voz(t) == 0 % Aquellos valores iguales a cero los entenderemos como ruido(VAD)
        i = i+1; % Numero de ventanas sin voz del array ruido i = n-2;
        r_media = a*r_media + a_1*Y(:,t);
        Y(:,t) = c*Y(:,t); % Reemplazar estos por cuadros con ruido atenuado
        Array_ruido(:,i) = Y(:,t);
        end
    Y_2=Y.^2;
    inicial=1;
    final=AB;
    r_media_2 = abs(r_media).^2;
    %%%%% Doblamos el numero de bandas ya que consideraremos todos los %%%%%
    %%%%% puntos de la FFT %%%%%
        for j = 1: B % se repite por banda
        suma_Y = 0;
        suma_r = 0;
            for k = inicial : final
            suma_Y = Y_2(k,t)+suma_Y;
            suma_r = r_media_2(k)+suma_r;
            end
        SNR = 10*log(suma_Y/suma_r);
        delta = 2.5;
        end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Resta espectral de la trama i y de la banda j
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        for k = inicial : final
        X(k,t) = Y_2(k,t) - alfa*delta*(r_media(k));% esta X esta elevada al cuadrado
        end
    inicial = final+1;
    final = final+AB;
    end % for para las bandas
end % for tramas
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Rectificacion de media onda
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
umbral_ruido = beta*Y_2; %(256*1)*(1*i)==> n_flor = 256*i
[I,J] = find(X < 0);
X(sub2ind(size(X),I,J)) = umbral_ruido(sub2ind(size(X),I,J));% Devuelve las filas y las columnas
X = sqrt(abs(X));
% de la entrada segun la condicion entre parentesis.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Volver al dominio temporal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x = zeros(length(y),1); % N*1
k = sqrt(-1);
s = 1;
for t = 1:solapamiento:(length(y)-puntos);
x(t:t+puntos_1) = x(t:t+puntos_1) + real(ifft(X(:,s).*exp(k*fase_Y(:,s))));
s = s+1;
end
% x es un array del tipo N*1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Resta espectral segun Berouti mejorada
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [x] = resta_mejorada(y,n_fft,solp,w,n,met_VAD,bits,fs,l_cep,landa,alfa,limite,beta,gamma);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Constantes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
puntos = n_fft;
puntos_1 = puntos-1;
puntos_2 = puntos/2;
r_unos = ones(puntos,1);
alfa_1 = 1-alfa;
gamma_2=gamma*2;
c = 10^(-30/20); %Atenuacion adicional de la señal durante los momentos sin actividad vocal
%Constante de atenuacion
solapamiento = puntos-solp; % numero que tendremos que poner durante el
% enventanado para que se produzca el solapamiento
% de "solp"(numero de muestras solapadas)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FFT de las señales con el solapamaiento indicado por el usuario
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
j = 1; % Indica el numero de tramas de Y teniendo cada una de ellas
% "puntos" filas
for t = 1:solapamiento:(length(y)-puntos)
Y(:,j) = fft (w.*y(t:(t+puntos_1))); % puntos de la FFT = muestras usadas.
modulo_Y(:,j) = abs(Y(:,j)); % devuelve el modulo
fase_Y(:,j) = angle(Y(:,j)); % devuelve la fase en radianes
j = j+1;
end
Y = modulo_Y; % Modulo de la FFT
% filas = numero de puntos de la FFT
% columnas = j
tramas = size(Y,2); % numero de tramas
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Promediado de la señal de entrada :
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Llevaremos a cabo el promediado de 3 tramas la actual, con la anterior
% y la posterior
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Y_promedio = Y;
for t = 2:(tramas-1) %empieza por 2 por el t-1 de despues para no dar un indice = 0
Y_promedio(:,t) = mean(Y(:,(t-1):(t+1)),2); % Promediado de 3 tramas
end
Y = Y_promedio;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Estimacion de ruido + VAD(Detector de Actividad Vocal)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Suponemos que las primeras tramas de señal van a ser ruido
r_media = Y(:,n); % Inicializamos r_media con "n" introducida por el
% usuario. Esta es una de las primeras tramas.
% Es aconsejable no tomar n = 1 ya que seguramente esta no
% represente correctamente el ruido que tendremos en la
% señal.
% Aplicamos el metodo de VAD seleccionado por el usuario
switch met_VAD
case 2
D_voz = vad_boll(Y,limite,n);

%%%%% Calculamos alfa %%%%%
if SNR < -5
alfa = 5;
elseif SNR > 20
alfa = 1;
else
alfa = 4-(3/20)*SNR;
end
%%%%% Calculamos delta siendo f(final)= a f_i teniendo en cuenta la parte %%%%%
%%%%% negativa del espectro %%%%%
if f(final) <= (1000||(fs-1000))
delta = 1;
elseif f(final) > (((fs/2)-2000)||((fs/2)+2000))
delta = 1.5;
else
case 3
D_voz = vad_ZCR(y,puntos,bits,fs); % n_fft se corresponde con el tamaño de la ventana de analisis
case 4
D_voz = vad_homo(Y,puntos,l_cep,landa);
end
i = 0;
for t = 1:tramas
if D_voz(t) == 0; % Aquellos valores iguales a cero los entenderemos como ruido(VAD)
i = i+1; % numero de ventanas sin voz del array ruido i = n-2;
r_media = alfa*r_media + (1-alfa)*Y(:,t);
n = n+1; % numero de ventanas sin voz
Y(:,t) = c*Y(:,t); % Reemplazar estos por cuadros con ruido atenuado
Array_ruido(:,i) = Y(:,t);
end
end
r_media = abs(r_media);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculo de la maxima desviacion para usar en el paso de reduccion de
% ruido residual. ruido residual = Array_ruido - r_media
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
r = r_media*ones(1,i);
r_residual = max(Array_ruido(:,1:i)-r,[],2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Resta espectral
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
umbral_ruido = beta*Y;
for t=1:tramas
a_SNR = 1;
X(:,t) = Y(:,t).^gamma_2 - (a_SNR * (r_media.^gamma_2) );
T = X(:,t).^(1/gamma);
while ((T < umbral_ruido(:,t)) & (a_SNR <= 4.75))
a_SNR = a_SNR + 0.1;
X(:,t) = Y(:,t).^gamma_2 - (a_SNR * (r_media.^gamma_2) );
T = X(:,t).^(1/gamma);
end
if(T >= umbral_ruido(:,t))
X(:,t) = T;
end
if (a_SNR >= 4.75)
X(:,t) = umbral_ruido(:,t);
end
end
X=abs(sqrt(X));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Restamos el ruido residual
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Un tipo de filtrado de media
% Si el ruido es menor que N_r, usaremos el valor minimo mas cercano
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
X_rr = X;
for t = 2:(tramas-1)
I = find(X(:,t) < r_residual + r_unos); % Solo nos da filas.
X_rr(I,t) = min (X(I,(t-1:t+1)),[],2);
end
X = X_rr;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Volver al dominio temporal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x = zeros(length(y),1); % N*1
k = sqrt(-1);
s = 1;
for t = 1:solapamiento:(length(y)-puntos);
x(t:t+puntos_1) = x(t:t+puntos_1) + real(ifft(X(:,s).*exp(k*fase_Y(:,s))));
s = s+1;
end
% x es un array del tipo N*1
% --- Executes during object creation, after setting all properties.
function metodos_VAD_CreateFcn(hObject, eventdata, handles)
% hObject handle to metodos_VAD (see GCBO)
% eventdata reserved - to be defined in a future version of MATLAB
% handles empty - handles not created until after all CreateFcns called
% Hint: popupmenu controls usually have a white background on Windows.
% See ISPC and COMPUTER.
if ispc
set(hObject,'BackgroundColor','white');
else
set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
% --- Executes on selection change in metodos_VAD.
function metodos_VAD_Callback(hObject, eventdata, handles)
% hObject handle to metodos_VAD (see GCBO)
% eventdata reserved - to be defined in a future version of MATLAB
% handles structure with handles and user data (see GUIDATA)
% Hints: contents = get(hObject,'String') returns metodos_VAD contents as cell array
% contents{get(hObject,'Value')} returns selected item from metodos_VAD
met_VAD=get(hObject,'Value');
switch met_VAD
case 1
case 2 % VAD Simple
set(handles.l_cep_edit,'enable','off');
set(handles.landa_edit,'enable','off');
% habilitamos sus parametros    
set(handles.um_VAD_edit,'enable','on');
case 3 % VAD Energia y ZCR
set(handles.l_cep_edit,'enable','off');
set(handles.landa_edit,'enable','off');
set(handles.um_VAD_edit,'enable','off');
case 4 % VAD Homomorfico
set(handles.um_VAD_edit,'enable','off');
% habilitamos sus parametros
set(handles.l_cep_edit,'enable','on');
set(handles.landa_edit,'enable','on');
end
handles.met_VAD=met_VAD;
guidata(hObject,handles);
% --------------------------------------------------------------------
% --------------------------------------------------------------------
function solapamiento_Callback(hObject, eventdata, handles)
% hObject handle to solapamiento (see GCBO)
% eventdata reserved - to be defined in a future version of MATLAB
% handles structure with handles and user data (see GUIDATA)
% --------------------------------------------------------------------
function menu_solap_Callback(hObject, eventdata, handles)
% hObject handle to menu_solap (see GCBO)
% eventdata reserved - to be defined in a future version of MATLAB
% handles structure with handles and user data (see GUIDATA)
%The GUI Help Button
%The GUI Help button callback displays an HTML file in the MATLAB Help
%browser. It uses two commands:
%The which command returns the full path to the file when it is on the
%MATLAB path
%The web command displays the file in the Help browser.
%ayuda= which('solap.html');
web C:/ayuda/solap.htm
%You can also display the help document in a Web browser or load an external
%URL. See the Web documentation for a description of these options.
% --- Executes during object creation, after setting all properties.
function l_cep_edit_CreateFcn(hObject, eventdata, handles)
% hObject handle to l_cep (see GCBO)
% eventdata reserved - to be defined in a future version of MATLAB
% handles empty - handles not created until after all CreateFcns called
% Hint: edit controls usually have a white background on Windows.
% See ISPC and COMPUTER.
if ispc
set(hObject,'BackgroundColor','white');
else
set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
function l_cep_edit_Callback(hObject, eventdata, handles)
% hObject handle to l_cep (see GCBO)
% eventdata reserved - to be defined in a future version of MATLAB
% handles structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of l_cep as text
% str2double(get(hObject,'String')) returns contents of l_cep as a double
l_cep=str2double(get(hObject,'string'));
handles.l_cep=l_cep;
guidata(hObject,handles);
% --- Executes during object creation, after setting all properties.
function landa_edit_CreateFcn(hObject, eventdata, handles)
% hObject handle to landa_edit (see GCBO)
% eventdata reserved - to be defined in a future version of MATLAB
% handles empty - handles not created until after all CreateFcns called
% Hint: edit controls usually have a white background on Windows.
% See ISPC and COMPUTER.
if ispc
set(hObject,'BackgroundColor','white');
else
set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
function landa_edit_Callback(hObject, eventdata, handles)
% hObject handle to landa_edit (see GCBO)
% eventdata reserved - to be defined in a future version of MATLAB
% handles structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of landa_edit as text
% str2double(get(hObject,'String')) returns contents of landa_edit as a double
landa=str2double(get(hObject,'string'));
handles.landa=landa;
guidata(hObject,handles);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% VAD simple obtenido de boll
%
% Entradas:
%
% s : Señal de entrada en el dominio de la frecuencia
% limite : valor en dB por debajo del cual tomamos una muestra como ruido
% n : trama que consideramos como primera trama solo con ruido
%
% Salidas:
%
% D_voz : señal cuyas muestras valen 0(ruido) o 1(señal ruidosa)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [D_voz] = vad_boll(s,limite,n);
    tramas = size(s,2);
%% Deteccion de voz
r_media = s(:,n); % Usamos como muestra de ruido la segunda trama
% ya que suponemos que esta sera ruido
T = 20*log10(mean(s./(r_media*ones(1,tramas))));
D_voz=ones(1,tramas);
i = 0;
for t = 1:tramas
if T(t) < limite % Aquellos valores menos que limite los entenderemos como ruido(VAD)
D_voz(t)=0;
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% VAD mediante calculo de energia y tasa de cruces por cero(ZCR)
%
% Entradas:
%
% s : Señal de entrada en el dominio del tiempo
% L : longitud de la ventana de analisis.
% bits : numero de bits
%
% Salidas:
%
% D_voz : señal cuyas muestras valen 0(ruido) o 1(señal ruidosa)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [D_voz] = vad_ZCR(s,L,bits,fs);
% Detector de actividad vocal (VAD).
v = ones(1,L); %ventana rectangular.
M = length(s);
max_s = max(abs(s));
M1=M+L;
c=zeros(1,L);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculo de la energia localizada y calculo de la tasa de cruces por cero ZCR
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ponemos un nivel para filt. ruido
aux = round(s/max_s*2^(bits-7));
% SIGN(X) devulve 1 si el elemento es
% mayor de cero, 0 si este es igual a cero y menos uno
% X(x1:x2) elementos de x1 a x2 pertenecientes a X
T = abs(s).^2; %modulo de la señal de entrada al cuadrado
T_ZCR = 1/2*abs(sign(aux(1:M-1)) - sign(aux(2:M)));
T_ZCR=[c T_ZCR' c]; %Metemos L ceros por delante y detras de T(la señal)
%Calculo de la energia localizada y Calculo de la tasa de cruces por cero ZCR
T=[c T' c]; %Metemos L ceros por delante y detras de T(la señal)
for n = L:(M1-1)
sum_E=0;
sum_ZCR=0;
for k = (n-L+1):n
sum_E = sum_E + T(k);
sum_ZCR = sum_ZCR + T_ZCR(k);
end
E(n-L+1) = sum_E;
zcr(n-L+1) = sum_ZCR;
end
zcr=zcr*(1/L)*fs;
% max(x,0) devuelve array con los valores que esten por encima de cero del
% array x, los que estan por debajo los pone a cero en este caso, si pusiera
% -1 los pondria a este valor
D_E = std(E) * max(sign(E - max(E)/10),0);
D_zcr = std(zcr) * max(sign(zcr - max(zcr)/10),0);
aux = (D_E | D_zcr);
L=L/2;
i=1;
for t =1:L:M
D_voz(i) = aux(t); %0's y 1's
i=i+1;
end
%D_voz=D_voz';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Detector de Actividad Vocal homomorfico
% basado en algoritmo resta espectral en dsp.pdf
%
% Entradas:
%
% s : Señal de entrada en el dominio de la frecuencia
% puntos : Numero de puntos de la FFT
% L_cep : longitud del vector espectral
% a_cep : Alfa para el calculo del promedio
%
%
% Salidas:
%
% D_voz : señal cuyas muestras valen 0(ruido) o 1(señal ruidosa)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [D_voz] = vad_homo(s,puntos,l_cep,landa);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Constantes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
puntos_1 = puntos-1;
puntos_2 = puntos/2;
ceros = zeros(puntos,1);
%L_cep = 11; % Longitud del vector cepstral
a_cep = 0.05; % Para calculo del promedio exponencial del vector cepstrum (entre 0.05 y 0.3)
a_cep_1 = a_cep-1;
tramas = size(s,2);
% D_voz nos muestra los puntos en los que hay voz "1" o no "0"
D_voz = zeros(1,tramas);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Obtenemos los Vectores Cepstrales, uno por trama
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for t = 1 : tramas
log_S = log(s(:,t));
cep(:,t) = abs(fft(log_S));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calulo del promedio inicial del vector cepstral
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inicializamos la estimacion del coeficiente cepstral del ruido
% "P_cep" a cero
P_cep = zeros(puntos,1);
for n = 2:(l_cep + 1)
P_cep(n) = (a_cep_1).*P_cep(n) + a_cep.*cep(n,1);
end
r = 1; % indice que reccorre media y desviacion
a = 1; % para calcular el thr inicial
for m = 2 : tramas % columnas==>tramas
d = 0;
for n = 2:(l_cep + 1)
d = (cep(n,m)-P_cep(n))^2 + d;
end
d=sqrt(d);
%%%% El vector v guarda los valores de "d" para aplicarles las media y la
%%%% desviacion estandar
if a == 1
thr = mean(d) + landa*std(d);
a = 0;
end
if(d <= thr) % hay una pausa se vuelve a calcular el promedio de Cep
for n = 2:(l_cep + 1)
P_cep(n) = (a_cep_1)*P_cep(n) + a_cep*cep(n,m);
end
v(r) = d;
thr = mean(v) + landa*std(v); % se actualiza en los silencios
r = r+1;
else
D_voz(m) = 1;
end % if
end
% --------------------------------------------------------------------
function Ventana_Callback(hObject, eventdata, handles)
% hObject handle to Ventana (see GCBO)
% eventdata reserved - to be defined in a future version of MATLAB
% handles structure with handles and user data (see GUIDATA)
% --------------------------------------------------------------------
function menu_context_ventana_Callback(hObject, eventdata, handles)
% hObject handle to menu_context_ventana (see GCBO)
% eventdata reserved - to be defined in a future version of MATLAB
% handles structure with handles and user data (see GUIDATA)
web c:/ayuda/Tventanas.htm
% --------------------------------------------------------------------
function Puntos_FFT_txt_Callback(hObject, eventdata, handles)
% hObject handle to Puntos_FFT_txt (see GCBO)
% eventdata reserved - to be defined in a future version of MATLAB
% handles structure with handles and user data (see GUIDATA)
% --------------------------------------------------------------------
function landa_cepstral_context_Callback(hObject, eventdata, handles)
% hObject handle to alfa_cepstral_context (see GCBO)
% eventdata reserved - to be defined in a future version of MATLAB
% handles structure with handles and user data (see GUIDATA)
web c:/ayuda/landa_cepstral.htm;
% --------------------------------------------------------------------
function longitud_cepstral_contxt_Callback(hObject, eventdata, handles)
% hObject handle to longitud_cepstral_contxt (see GCBO)
% eventdata reserved - to be defined in a future version of MATLAB
% handles structure with handles and user data (see GUIDATA)
web c:/ayuda/Lcepstral.htm
% --------------------------------------------------------------------
function Umbral_context_Callback(hObject, eventdata, handles)
% hObject handle to Umbral_context (see GCBO)
% eventdata reserved - to be defined in a future version of MATLAB
% handles structure with handles and user data (see GUIDATA)
web c:/ayuda/Umbral.htm
% --------------------------------------------------------------------
function n_context_Callback(hObject, eventdata, handles)
% hObject handle to n_context (see GCBO)
% eventdata reserved - to be defined in a future version of MATLAB
% handles structure with handles and user data (see GUIDATA)
web c:/ayuda/N.htm
% --------------------------------------------------------------------
function m_context_Callback(hObject, eventdata, handles)
% hObject handle to m_context (see GCBO)
% eventdata reserved - to be defined in a future version of MATLAB
% handles structure with handles and user data (see GUIDATA)
web c:/ayuda/M.htm
% --------------------------------------------------------------------
function Alfa_estim_context_Callback(hObject, eventdata, handles)
% hObject handle to Alfa_estim_context (see GCBO)
% eventdata reserved - to be defined in a future version of MATLAB
% handles structure with handles and user data (see GUIDATA)
web c:/ayuda/Alfa.htm
% --------------------------------------------------------------------
function Gamma_estim_context_Callback(hObject, eventdata, handles)
% hObject handle to Gamma_estim_context (see GCBO)
% eventdata reserved - to be defined in a future version of MATLAB
% handles structure with handles and user data (see GUIDATA)
web c:/ayuda/Gamma.htm
% --------------------------------------------------------------------
function bandas_context_Callback(hObject, eventdata, handles)
% hObject handle to bandas_context (see GCBO)
% eventdata reserved - to be defined in a future version of MATLAB
% handles structure with handles and user data (see GUIDATA)
web c:/ayuda/Bandas.htm
% --------------------------------------------------------------------
function Alfa_resta_context_Callback(hObject, eventdata, handles)
% hObject handle to Alfa_resta_context (see GCBO)
% eventdata reserved - to be defined in a future version of MATLAB
% handles structure with handles and user data (see GUIDATA)
web c:/ayuda/alfa_resta.htm
% --------------------------------------------------------------------
function Gamma_resta_context_Callback(hObject, eventdata, handles)
% hObject handle to Gamma_resta_context (see GCBO)
% eventdata reserved - to be defined in a future version of MATLAB
% handles structure with handles and user data (see GUIDATA)
web c:/ayuda/Gamma_resta.htm
% --------------------------------------------------------------------
function Beta_context_Callback(hObject, eventdata, handles)
% hObject handle to Beta_context (see GCBO)
% eventdata reserved - to be defined in a future version of MATLAB
% handles structure with handles and user data (see GUIDATA)
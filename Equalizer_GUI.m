% Digital Signal Processing
% Spring - 2021
% Semester Project - Audio Equalizer
% The GUI creates a creatFCN function and a callback function for the components
% The code is incorporated in call back functions which respond to button
% pushes or slider manipulation etc.
% The createFcn is the function that creates components in the GUI i.e push
% buttons and sliders etc.

function varargout = Equalizer_GUI(varargin)
% EQUALIZER_GUI MATLAB code for Equalizer_GUI.fig
%      EQUALIZER_GUI, by itself, creates a new EQUALIZER_GUI or raises the existing
%      singleton*.
%
%      H = EQUALIZER_GUI returns the handle to a new EQUALIZER_GUI or the handle to
%      the existing singleton*.
%
%      EQUALIZER_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EQUALIZER_GUI.M with the given input arguments.
%
%      EQUALIZER_GUI('Property','Value',...) creates a new EQUALIZER_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Equalizer_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Equalizer_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Equalizer_GUI

% Last Modified by GUIDE v2.5 10-May-2021 00:52:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Equalizer_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @Equalizer_GUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Equalizer_GUI is made visible.
function Equalizer_GUI_OpeningFcn(hObject, eventdata, handles, varargin)    % Initialize Plot labels here
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Equalizer_GUI (see VARARGIN)

% Choose default command line output for Equalizer_GUI
handles.output = hObject;
axes(handles.axes1_original_plot);
title('Input Signal');
xlabel('frequency(Hz)');
ylabel('Magnitude');
xlim([0,22000]);
xticks(2000*(0:11));
xticklabels({'0','2k','4k','6k','8k','10k','12k','14k','16k','18k','20k','22k'})
axes(handles.axes2_post_equalization_plot);
title('Output Signal');
xlabel('frequency(Hz)');
ylabel('Magnitude');
xlim([0,22000]);
xticks(2000*(0:11));
xticklabels({'0','2k','4k','6k','8k','10k','12k','14k','16k','18k','20k','22k'})

guidata(hObject, handles);                                                  % Update handles
                                                                            % Call this function when a new handles. object is created to update handles

% End of Equalizer Opening Function

% UIWAIT makes Equalizer_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Equalizer_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in browser_pushbutton.
function browser_pushbutton_Callback(hObject, eventdata, handles)           % This function contains the operations to import sound file
% hObject    handle to browser_pushbutton (see GCBO)                        % initialize audio data and sampling frequency                   
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Reset_Pushbutton_Callback(hObject, eventdata, handles);                     % Reset sliders when new audio file is added.

[filename, pathname] = uigetfile({'*.wav'},'File Selector');                % Import button opens matlab's current directory
set(handles.edit1_filename_display,'string',filename);                      % and looks for .wav files

[x,Fs]=audioread(filename);                                                 % Read the selected file 
 
handles.x = resample(x,44100,Fs);                                           % Resample files with different sampling frequency to 44100 Hz
                                                                            % Files at 44100Hz are not affected
handles.Fs = 44100;                                                         % sampling rate.
%handles.playback_Fs = 44100;

guidata(hObject, handles);                                                  % Update handles

% End of browser call back function

% --- Executes on button press in playAudio_pushbutton2.
function playAudio_pushbutton2_Callback(hObject, eventdata, handles)        % The computation of output and playing
% hObject    handle to playAudio_pushbutton2 (see GCBO)                     % of audio is carried out here.   
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.g1 = get(handles.LP_slider,'value');                                % Get gain values from sliders
handles.g2 = get(handles.BP_60_to_200_slider,'value');
handles.g3 = get(handles.BP_200_to_600_slider,'value');
handles.g4 = get(handles.BP_600_to_1k_slider,'value');
handles.g5 = get(handles.BP_1k_to_2k_slider,'value');
handles.g6 = get(handles.BP_2k_to_4k_slider,'value');
handles.g7 = get(handles.BP_4k_to_8k_slider,'value');
handles.g8 = get(handles.BP_8k_to_16k_slider,'value');
handles.g9 = get(handles.HP_slider,'value');
% LOW PASS FILTER with cutoff frequency = f_low
order = 1000;                                                               % Order = 1000
                                                                            % Length = 1001
                                                                            % High order is necassary to minimize transition width 
                                                                            
f_LP = 60;                                                                  % Cutoff frequency of the low pass filter 
h1 = fir1(order,f_LP/(handles.Fs/2),'low');                                 % Low Pass Filter 
handles.y_LP = handles.g1*filter(h1,1,handles.x);                           % The output is the gain from the slider multiplied by the filter function whose parameters are the filter, order, and the input signal 
                                                                            % This code will be implemented for all our filters
%bandpass1
fc_BP1=61;                                                                  % Lower cutoff frequency of first band pass filter
fc2_BP1=200;                                                                % Upper cutoff frequency of first band pass filter
h2=fir1(order,[fc_BP1/(handles.Fs/2) fc2_BP1/(handles.Fs/2)],'bandpass');   % Band Pass Filter 1
handles.y_BP1=handles.g2*filter(h2,1,handles.x);                            

%bandpass2
fc_BP2=201;                                                                 % Lower cutoff frequency of second band pass filter
fc2_BP2=600;                                                                % Upper cutoff frequency of second band pass filter
h3=fir1(order,[fc_BP2/(handles.Fs/2) fc2_BP2/(handles.Fs/2)],'bandpass');   % Band Pass Filter 2
handles.y_BP2=handles.g3*filter(h3,1,handles.x);                            
 
%bandpass3
fc_BP3=601;                                                                 % Lower cutoff frequency of third band pass filter
fc2_BP3=1000;                                                               % Upper cutoff frequency of third band pass filter
h4=fir1(order,[fc_BP3/(handles.Fs/2) fc2_BP3/(handles.Fs/2)],'bandpass');   % Band Pass Filter 3
handles.y_BP3=handles.g4*filter(h4,1,handles.x);                            
 
%bandpass4
fc_BP4=1000;                                                                % Lower cutoff frequency of fourth band pass filter
fc2_BP4=2000;                                                               % Upper cutoff frequency of fourth band pass filter
h5=fir1(order,[fc_BP4/(handles.Fs/2) fc2_BP4/(handles.Fs/2)],'bandpass');   % Band Pass Filter 4
handles.y_BP4=handles.g5*filter(h5,1,handles.x);                            


%bandpass5
fc_BP5=2000;                                                                % Lower cutoff frequency of fifth band pass filter
fc2_BP5=4000;                                                               % Upper cutoff frequency of fifth band pass filter
h6=fir1(order,[fc_BP5/(handles.Fs/2) fc2_BP5/(handles.Fs/2)],'bandpass');   % Band Pass Filter 5
handles.y_BP5=handles.g6*filter(h6,1,handles.x);                            
 

%bandpass6
fc_BP6=4001;                                                                % Lower cutoff frequency of sixth band pass filter
fc2_BP6=8000;                                                               % Upper cutoff frequency of sixth band pass filter
h7=fir1(order,[fc_BP6/(handles.Fs/2) fc2_BP6/(handles.Fs/2)],'bandpass');   % Band Pass Filter 6
handles.y_BP6=handles.g7*filter(h7,1,handles.x);                             

%bandpass7
fc_BP7=8001;                                                                % Lower cutoff frequency of seventh band pass filter
fc2_BP7=16000;                                                              % Upper cutoff frequency of seventh band pass filter
h8=fir1(order,[fc_BP7/(handles.Fs/2) fc2_BP7/(handles.Fs/2)],'bandpass');   % Band Pass Filter 7
handles.y_BP7=handles.g8*filter(h8,1,handles.x);                             

%highpass
fc_HP=16001;                                                                % Cutoff frequency of high pass filter
h9=fir1(order,fc_HP/(handles.Fs/2),'high');                                 % High Pass Filter
handles.y_HP=handles.g9*filter(h9,1,handles.x);                              

 
% The output value is set to a variable for each filter, and is then summed up below to produce a reconstructed, plottable, and playable signal
handles.y_equalized=handles.y_LP+handles.y_BP1+handles.y_BP2+handles.y_BP3+handles.y_BP4+handles.y_BP5+handles.y_BP6+handles.y_BP7+handles.y_HP;
                                                                            
handles.player = audioplayer(handles.y_equalized,handles.Fs);      % Play equalized signal
                                                                            % When sliders are at initial state
                                                                            % y_equalized = x i.e input audio will be played.
guidata(hObject, handles);                                                  % Update handles 
play(handles.player);                                                       % Play audio

% End of Play Audio

% --- Executes on button press in pause_pushbutton4.
function pause_pushbutton4_Callback(hObject, eventdata, handles)            
% hObject    handle to pause_pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pause(handles.player)

% --- Executes on button press in resume_pushbutton5.
function resume_pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to resume_pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
resume(handles.player)

% --- Executes on button press in stop_pushbutton6.
function stop_pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to stop_pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stop(handles.player)

% --- Executes on button press in timeplot_original_Pushbutton.
function timeplot_original_Pushbutton_Callback(hObject, eventdata, handles) % Time plot of input signal
% hObject    handle to timeplot_original_Pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.timeplot_original_Pushbutton,'BackgroundColor','green');        % Update color
set(handles.plot_original_pushbutton3,'BackgroundColor','white'); 

t = 0:length(handles.x)-1;                                                  
plot(handles.axes1_original_plot,t,handles.x)
axes(handles.axes1_original_plot);
title('Input Signal');
xlabel('time(sec)');
ylabel('Magnitude');
xlim([0,length(handles.x)]);
%xticks(2000*(0:11));
%xticklabels({'0','2k','4k','6k','8k','10k','12k','14k','16k','18k','20k','22k'})


% --- Executes on button press in timeplot_equalized_Pushbutton.
function timeplot_equalized_Pushbutton_Callback(hObject, eventdata, handles)% Time plot of equalized signal
% hObject    handle to timeplot_equalized_Pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.Plot_Output,'BackgroundColor','white');                         % Update color
set(handles.timeplot_equalized_Pushbutton,'BackgroundColor','green');   

t = 0:length(handles.y_equalized)-1;
plot(handles.axes2_post_equalization_plot,t,handles.y_equalized)
axes(handles.axes2_post_equalization_plot);
title('Output Signal');
xlabel('time(sec)');
ylabel('Magnitude');
xlim([0,length(handles.y_equalized)]);
%xticks(2000*(0:11));
%xticklabels({'0','2k','4k','6k','8k','10k','12k','14k','16k','18k','20k','22k'})

% End of time plots


% --- Executes on button press in plot_original_pushbutton3.
function plot_original_pushbutton3_Callback(hObject, eventdata, handles)    % Frequency plot of original audio
% hObject    handle to plot_original_pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%axes(handles.axes1_original_plot)
set(handles.timeplot_original_Pushbutton,'BackgroundColor','white');        % change color of buttons
set(handles.plot_original_pushbutton3,'BackgroundColor','green'); 
%audio_FFT = fft(handles.x,handles.Fs);
audio_FFT = fft(handles.x);                                                 % Compute N-point DFT using fft

f = 0:(length(handles.x)/2);                                                % axis for positive frequencies


plot(handles.axes1_original_plot,f*handles.Fs/length(handles.x),abs(audio_FFT((1:length(f)))))
axes(handles.axes1_original_plot);
title('Input Signal');
xlabel('frequency(Hz)');
ylabel('Magnitude');
xlim([0,22000]);
xticks(2000*(0:11));
xticklabels({'0','2k','4k','6k','8k','10k','12k','14k','16k','18k','20k','22k'})

% --- Executes on button press in Plot_Output.
function Plot_Output_Callback(hObject, eventdata, handles)                  % Frequency plot of equalized signal
% hObject    handle to Plot_Output (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.Plot_Output,'BackgroundColor','green');                         % Change color of buttons
set(handles.timeplot_equalized_Pushbutton,'BackgroundColor','white'); 

audio_equalized_FFT = fft(handles.y_equalized);                             % Compute N-point DFT using fft

f = 0:(length(handles.y_equalized)/2);                                      % axis for positive frequencies

plot(handles.axes2_post_equalization_plot,f*(handles.Fs/length(handles.y_equalized)),abs(audio_equalized_FFT((1:length(f)))))
axes(handles.axes2_post_equalization_plot);
title('Output Signal');
xlabel('frequency(Hz)');
ylabel('Magnitude');
xlim([0,22000]);
xticks(2000*(0:11));
xticklabels({'0','2k','4k','6k','8k','10k','12k','14k','16k','18k','20k','22k'})

% End of frequency plots

function edit1_filename_display_Callback(hObject, eventdata, handles)       
% hObject    handle to edit1_filename_display (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1_filename_display as text
%        str2double(get(hObject,'String')) returns contents of edit1_filename_display as a double


% --- Executes during object creation, after setting all properties.
function edit1_filename_display_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1_filename_display (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function volume_slider7_Callback(hObject, eventdata, handles)               % Adjust volume
% hObject    handle to volume_slider7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
volume = get(handles.volume_slider7,'value');
handles.x = volume.*handles.x;                                              % multiply slider value to signal
guidata(hObject, handles);                                                  % to amplify sound

% --- Executes during object creation, after setting all properties.
function volume_slider7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to volume_slider7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in Reset_Pushbutton.
function Reset_Pushbutton_Callback(hObject, eventdata, handles)             % Resets all slider/text box values to 1
% hObject    handle to Reset_Pushbutton (see GCBO)                          
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.Jazz_Pushbutton,'BackgroundColor','white'); 
set(handles.HipHop_Pushbutton,'BackgroundColor','white'); 
set(handles.Pop_Pushbutton,'BackgroundColor','white'); 
set(handles.Rock_Pushbutton,'BackgroundColor','white'); 
set(handles.Reggae_Pushbutton,'BackgroundColor','white'); 
set(handles.Classical_Pushbutton,'BackgroundColor','white');
set(handles.LP_slider,'value',1);                                           
set(handles.BP_60_to_200_slider,'value',1);
set(handles.BP_200_to_600_slider,'value',1);
set(handles.BP_600_to_1k_slider,'value',1);
set(handles.BP_1k_to_2k_slider,'value',1);
set(handles.BP_2k_to_4k_slider,'value',1);
set(handles.BP_4k_to_8k_slider,'value',1);
set(handles.BP_8k_to_16k_slider,'value',1);
set(handles.HP_slider,'value',1);

set(handles.LP_Textbox,'string',num2str(1));                                           
set(handles.BP_60_to_200_Textbox,'string',num2str(1));
set(handles.BP_200_to_600_Textbox,'string',num2str(1));
set(handles.BP_600_to_1k_Textbox,'string',num2str(1));
set(handles.BP_1k_to_2k_Textbox,'string',num2str(1));
set(handles.BP_2k_to_4k_Textbox,'string',num2str(1));
set(handles.BP_4k_to_8k_Textbox,'string',num2str(1));
set(handles.BP_8k_to_16k_Textbox,'string',num2str(1));
set(handles.HP_Textbox,'string',num2str(1));

% End of Reset button


% Slider functions
% --- Executes on slider movement.
function LP_slider_Callback(hObject, eventdata, handles)                    
% hObject    handle to LP_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

set(handles.LP_Textbox,'string',num2str(get(handles.LP_slider,'value')));   % Update text box value when slider is modified

% --- Executes during object creation, after setting all properties.
function LP_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LP_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function BP_60_to_200_slider_Callback(hObject, eventdata, handles)
% hObject    handle to BP_60_to_200_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set(handles.BP_60_to_200_Textbox,'string',num2str(get(handles.BP_60_to_200_slider,'value')));% Update text box value when slider is modified

% --- Executes during object creation, after setting all properties.
function BP_60_to_200_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BP_60_to_200_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function BP_200_to_600_slider_Callback(hObject, eventdata, handles)
% hObject    handle to BP_200_to_600_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set(handles.BP_200_to_600_Textbox,'string',num2str(get(handles.BP_200_to_600_slider,'value')));

% --- Executes during object creation, after setting all properties.
function BP_200_to_600_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BP_200_to_600_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function BP_600_to_1k_slider_Callback(hObject, eventdata, handles)
% hObject    handle to BP_600_to_1k_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set(handles.BP_600_to_1k_Textbox,'string',num2str(get(handles.BP_600_to_1k_slider,'value')));

% --- Executes during object creation, after setting all properties.
function BP_600_to_1k_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BP_600_to_1k_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function BP_1k_to_2k_slider_Callback(hObject, eventdata, handles)
% hObject    handle to BP_1k_to_2k_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set(handles.BP_1k_to_2k_Textbox,'string',num2str(get(handles.BP_1k_to_2k_slider,'value')));

% --- Executes during object creation, after setting all properties.
function BP_1k_to_2k_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BP_1k_to_2k_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function BP_2k_to_4k_slider_Callback(hObject, eventdata, handles)
% hObject    handle to BP_2k_to_4k_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set(handles.BP_2k_to_4k_Textbox,'string',num2str(get(handles.BP_2k_to_4k_slider,'value')));

% --- Executes during object creation, after setting all properties.
function BP_2k_to_4k_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BP_2k_to_4k_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function BP_4k_to_8k_slider_Callback(hObject, eventdata, handles)
% hObject    handle to BP_4k_to_8k_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set(handles.BP_4k_to_8k_Textbox,'string',num2str(get(handles.BP_4k_to_8k_slider,'value')));

% --- Executes during object creation, after setting all properties.
function BP_4k_to_8k_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BP_4k_to_8k_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function BP_8k_to_16k_slider_Callback(hObject, eventdata, handles)
% hObject    handle to BP_8k_to_16k_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set(handles.BP_8k_to_16k_Textbox,'string',num2str(get(handles.BP_8k_to_16k_slider,'value')));

% --- Executes during object creation, after setting all properties.
function BP_8k_to_16k_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BP_8k_to_16k_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function HP_slider_Callback(hObject, eventdata, handles)
% hObject    handle to HP_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set(handles.HP_Textbox,'string',num2str(get(handles.HP_slider,'value')));

% --- Executes during object creation, after setting all properties.
function HP_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to HP_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
% End of slider functions

% Textbox functions
function LP_Textbox_Callback(hObject, eventdata, handles)
% hObject    handle to LP_Textbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of LP_Textbox as text
%        str2double(get(hObject,'String')) returns contents of LP_Textbox as a double
LP_textvalue = str2double(get(hObject,'string'));                           % Get text box value and convert to double for slider
if (~isnan(LP_textvalue))                                                   % Check for incorrect value i.e alphabets etc.
    if (LP_textvalue < get(handles.LP_slider,'min')|| LP_textvalue > get(handles.LP_slider,'max')) % Values outside range of slider are discarded.
        set(handles.LP_TextBox,'string',num2str(get(handles.LP_slider,'value')));
    else
        set(handles.LP_slider,'value',LP_textvalue);                        % Update slider if correct value in text box
    end
else
    set(handles.LP_TextBox,'string',num2str(get(handles.LP_slider,'value')));
end

% --- Executes during object creation, after setting all properties.
function LP_Textbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LP_Textbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function BP_60_to_200_Textbox_Callback(hObject, eventdata, handles)
% hObject    handle to BP_60_to_200_Textbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of BP_60_to_200_Textbox as text
%        str2double(get(hObject,'String')) returns contents of BP_60_to_200_Textbox as a double
BP_60_to_200_textvalue = str2double(get(hObject,'string'));
if (~isnan(BP_60_to_200_textvalue))
if (BP_60_to_200_textvalue < get(handles.BP_60_to_200_slider,'min')|| BP_60_to_200_textvalue > get(handles.BP_60_to_200_slider,'max'))
    set(handles.BP_60_to_200_Textbox,'string',num2str(get(handles.BP_60_to_200_slider,'value')));
else
    set(handles.BP_60_to_200_slider,'value',BP_60_to_200_textvalue);
end
else
    set(handles.BP_60_to_200_Textbox,'string',num2str(get(handles.BP_60_to_200_slider,'value')));
end


% --- Executes during object creation, after setting all properties.
function BP_60_to_200_Textbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BP_60_to_200_Textbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function BP_200_to_600_Textbox_Callback(hObject, eventdata, handles)
% hObject    handle to BP_200_to_600_Textbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of BP_200_to_600_Textbox as text
%        str2double(get(hObject,'String')) returns contents of BP_200_to_600_Textbox as a double

BP_200_to_600_textvalue = str2double(get(hObject,'string'));
if (~isnan(BP_200_to_600_textvalue))
if (BP_200_to_600_textvalue < get(handles.BP_200_to_600_slider,'min')|| BP_200_to_600_textvalue > get(handles.BP_200_to_600_slider,'max'))
    set(handles.BP_200_to_600_Textbox,'string',num2str(get(handles.BP_200_to_600_slider,'value')));
else
    set(handles.BP_200_to_600_slider,'value',BP_200_to_600_textvalue);
end
else
    set(handles.BP_200_to_600_Textbox,'string',num2str(get(handles.BP_200_to_600_slider,'value')));
end

% --- Executes during object creation, after setting all properties.
function BP_200_to_600_Textbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BP_200_to_600_Textbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function BP_600_to_1k_Textbox_Callback(hObject, eventdata, handles)
% hObject    handle to BP_600_to_1k_Textbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of BP_600_to_1k_Textbox as text
%        str2double(get(hObject,'String')) returns contents of BP_600_to_1k_Textbox as a double
BP_600_to_1k_textvalue = str2double(get(hObject,'string'));
if (~isnan(BP_600_to_1k_textvalue))
if (BP_600_to_1k_textvalue < get(handles.LP_slider,'min')|| BP_600_to_1k_textvalue > get(handles.BP_600_to_1k_slider,'max'))
    set(handles.BP_600_to_1k_Textbox,'string',num2str(get(handles.BP_600_to_1k_slider,'value')));
else
    set(handles.BP_600_to_1k_slider,'value',BP_600_to_1k_textvalue);
end
else
    set(handles.BP_600_to_1k_Textbox,'string',num2str(get(handles.BP_600_to_1k_slider,'value')));
end


% --- Executes during object creation, after setting all properties.
function BP_600_to_1k_Textbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BP_600_to_1k_Textbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function BP_1k_to_2k_Textbox_Callback(hObject, eventdata, handles)
% hObject    handle to BP_1k_to_2k_Textbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of BP_1k_to_2k_Textbox as text
%        str2double(get(hObject,'String')) returns contents of BP_1k_to_2k_Textbox as a double

BP_1k_to_2k_textvalue = str2double(get(hObject,'string'));
if (~isnan(BP_1k_to_2k_textvalue))
if (BP_1k_to_2k_textvalue < get(handles.BP_1k_to_2k_slider,'min')|| BP_1k_to_2k_textvalue > get(handles.BP_1k_to_2k_slider,'max'))
    set(handles.BP_1k_to_2k_Textbox,'string',num2str(get(handles.BP_1k_to_2k_slider,'value')));
else
    set(handles.BP_1k_to_2k_slider,'value',BP_1k_to_2k_textvalue);
end
else
    set(handles.BP_1k_to_2k_Textbox,'string',num2str(get(handles.BP_1k_to_2k_slider,'value')));
end

% --- Executes during object creation, after setting all properties.
function BP_1k_to_2k_Textbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BP_1k_to_2k_Textbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function BP_2k_to_4k_Textbox_Callback(hObject, eventdata, handles)
% hObject    handle to BP_2k_to_4k_Textbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of BP_2k_to_4k_Textbox as text
%        str2double(get(hObject,'String')) returns contents of BP_2k_to_4k_Textbox as a double

BP_2k_to_4k_textvalue = str2double(get(hObject,'string'));
if (~isnan(BP_2k_to_4k_textvalue))
if (BP_2k_to_4k_textvalue < get(handles.BP_2k_to_4k_slider,'min')|| BP_2k_to_4k_textvalue > get(handles.BP_2k_to_4k_slider,'max'))
    set(handles.BP_2k_to_4k_Textbox,'string',num2str(get(handles.BP_2k_to_4k_slider,'value')));
else
    set(handles.BP_2k_to_4k_slider,'value',BP_2k_to_4k_textvalue);
end
else
    set(handles.BP_2k_to_4k_Textbox,'string',num2str(get(handles.BP_2k_to_4k_slider,'value')));
end

% --- Executes during object creation, after setting all properties.
function BP_2k_to_4k_Textbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BP_2k_to_4k_Textbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function BP_4k_to_8k_Textbox_Callback(hObject, eventdata, handles)
% hObject    handle to BP_4k_to_8k_Textbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of BP_4k_to_8k_Textbox as text
%        str2double(get(hObject,'String')) returns contents of BP_4k_to_8k_Textbox as a double
BP_4k_to_8k_textvalue = str2double(get(hObject,'string'));
if (~isnan(BP_4k_to_8k_textvalue))
if (BP_4k_to_8k_textvalue < get(handles.BP_4k_to_8k_slider,'min')|| BP_4k_to_8k_textvalue > get(handles.BP_4k_to_8k_slider,'max'))
    set(handles.BP_4k_to_8k_Textbox,'string',num2str(get(handles.BP_4k_to_8k_slider,'value')));
else
    set(handles.BP_4k_to_8k_slider,'value',BP_4k_to_8k_textvalue);
end
else
    set(handles.BP_4k_to_8k_Textbox,'string',num2str(get(handles.BP_4k_to_8k_slider,'value')));
end


% --- Executes during object creation, after setting all properties.
function BP_4k_to_8k_Textbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BP_4k_to_8k_Textbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function BP_8k_to_16k_Textbox_Callback(hObject, eventdata, handles)
% hObject    handle to BP_8k_to_16k_Textbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of BP_8k_to_16k_Textbox as text
%        str2double(get(hObject,'String')) returns contents of BP_8k_to_16k_Textbox as a double
BP_8k_to_16k_textvalue = str2double(get(hObject,'string'));
if (~isnan(BP_8k_to_16k_textvalue))
if (BP_8k_to_16k_textvalue < get(handles.BP_8k_to_16k_slider,'min')|| BP_8k_to_16k_textvalue > get(handles.BP_8k_to_16k_slider,'max'))
    set(handles.BP_8k_to_16k_Textbox,'string',num2str(get(handles.BP_8k_to_16k_slider,'value')));
else
    set(handles.BP_8k_to_16k_slider,'value',BP_8k_to_16k_textvalue);
end
else
    set(handles.BP_8k_to_16k_Textbox,'string',num2str(get(handles.BP_8k_to_16k_slider,'value')));
end


% --- Executes during object creation, after setting all properties.
function BP_8k_to_16k_Textbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BP_8k_to_16k_Textbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function HP_Textbox_Callback(hObject, eventdata, handles)
% hObject    handle to HP_Textbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of HP_Textbox as text
%        str2double(get(hObject,'String')) returns contents of HP_Textbox as a double
HP_textvalue = str2double(get(hObject,'string'));
if (~isnan(HP_textvalue))
if (HP_textvalue < get(handles.HP_slider,'min')|| HP_textvalue > get(handles.HP_slider,'max'))
    set(handles.HP_Textbox,'string',num2str(get(handles.HP_slider,'value')));
else
    set(handles.HP_slider,'value',HP_textvalue);
end
else
    set(handles.HP_Textbox,'string',num2str(get(handles.HP_slider,'value')));
end


% --- Executes during object creation, after setting all properties.
function HP_Textbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to HP_Textbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% End of Text box functions


% Preset buttons 
% --- Executes on button press in Jazz_Pushbutton.
function Jazz_Pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to Jazz_Pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.Jazz_Pushbutton,'BackgroundColor','green'); 
set(handles.HipHop_Pushbutton,'BackgroundColor','white'); 
set(handles.Pop_Pushbutton,'BackgroundColor','white'); 
set(handles.Rock_Pushbutton,'BackgroundColor','white'); 
set(handles.Reggae_Pushbutton,'BackgroundColor','white'); 
set(handles.Classical_Pushbutton,'BackgroundColor','white'); 
C = [-3 2.5 -1.5 1.5 0.5 1.5 3 2.5 0.5];

set(handles.LP_slider,'value',C(1));                                        % This code is to set the variables that correspond to the sliders to
set(handles.BP_60_to_200_slider,'value',C(2));                              % certain values according to which preset is used
set(handles.BP_200_to_600_slider,'value',C(3));
set(handles.BP_600_to_1k_slider,'value',C(4));
set(handles.BP_1k_to_2k_slider,'value',C(5));
set(handles.BP_2k_to_4k_slider,'value',C(6));
set(handles.BP_4k_to_8k_slider,'value',C(7));
set(handles.BP_8k_to_16k_slider,'value',C(8));
set(handles.HP_slider,'value',C(9));

set(handles.LP_Textbox,'string',num2str(C(1)));
set(handles.BP_60_to_200_Textbox,'string',num2str(C(2)));
set(handles.BP_200_to_600_Textbox,'string',num2str(C(3)));
set(handles.BP_600_to_1k_Textbox,'string',num2str(C(4)));
set(handles.BP_1k_to_2k_Textbox,'string',num2str(C(5)));
set(handles.BP_2k_to_4k_Textbox,'string',num2str(C(6)));
set(handles.BP_4k_to_8k_Textbox,'string',num2str(C(7)));
set(handles.BP_8k_to_16k_Textbox,'string',num2str(C(8)));
set(handles.HP_Textbox,'string',num2str(C(9)));


% --- Executes on button press in HipHop_Pushbutton.
function HipHop_Pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to HipHop_Pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.Jazz_Pushbutton,'BackgroundColor','white'); 
set(handles.HipHop_Pushbutton,'BackgroundColor','green'); 
set(handles.Pop_Pushbutton,'BackgroundColor','white'); 
set(handles.Rock_Pushbutton,'BackgroundColor','white'); 
set(handles.Reggae_Pushbutton,'BackgroundColor','white'); 
set(handles.Classical_Pushbutton,'BackgroundColor','white'); 
C = [-4 -3 -2 0.5 3 2.7 -3.2 -1.7 1.3];

set(handles.LP_slider,'value',C(1));                                        % This code is to set the variables that correspond to the sliders to
set(handles.BP_60_to_200_slider,'value',C(2));                              % certain values according to which preset is used
set(handles.BP_200_to_600_slider,'value',C(3)); 
set(handles.BP_600_to_1k_slider,'value',C(4));
set(handles.BP_1k_to_2k_slider,'value',C(5));
set(handles.BP_2k_to_4k_slider,'value',C(6));
set(handles.BP_4k_to_8k_slider,'value',C(7));
set(handles.BP_8k_to_16k_slider,'value',C(8));
set(handles.HP_slider,'value',C(9));

set(handles.LP_Textbox,'string',num2str(C(1)));
set(handles.BP_60_to_200_Textbox,'string',num2str(C(2)));
set(handles.BP_200_to_600_Textbox,'string',num2str(C(3)));
set(handles.BP_600_to_1k_Textbox,'string',num2str(C(4)));
set(handles.BP_1k_to_2k_Textbox,'string',num2str(C(5)));
set(handles.BP_2k_to_4k_Textbox,'string',num2str(C(6)));
set(handles.BP_4k_to_8k_Textbox,'string',num2str(C(7)));
set(handles.BP_8k_to_16k_Textbox,'string',num2str(C(8)));
set(handles.HP_Textbox,'string',num2str(C(9)));


% --- Executes on button press in Classical_Pushbutton.
function Classical_Pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to Classical_Pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.Jazz_Pushbutton,'BackgroundColor','white'); 
set(handles.HipHop_Pushbutton,'BackgroundColor','white'); 
set(handles.Pop_Pushbutton,'BackgroundColor','white'); 
set(handles.Rock_Pushbutton,'BackgroundColor','white'); 
set(handles.Reggae_Pushbutton,'BackgroundColor','white'); 
set(handles.Classical_Pushbutton,'BackgroundColor','green');
C = [-0.3 1.2 -0.5 -1.8 -3 -0.2 3 2.5 1.7];

set(handles.LP_slider,'value',C(1));                                        % This code is to set the variables that correspond to the sliders to
set(handles.BP_60_to_200_slider,'value',C(2));                              % certain values according to which preset is used
set(handles.BP_200_to_600_slider,'value',C(3));
set(handles.BP_600_to_1k_slider,'value',C(4));
set(handles.BP_1k_to_2k_slider,'value',C(5));
set(handles.BP_2k_to_4k_slider,'value',C(6));
set(handles.BP_4k_to_8k_slider,'value',C(7));
set(handles.BP_8k_to_16k_slider,'value',C(8));
set(handles.HP_slider,'value',C(9));

set(handles.LP_Textbox,'string',num2str(C(1)));
set(handles.BP_60_to_200_Textbox,'string',num2str(C(2)));
set(handles.BP_200_to_600_Textbox,'string',num2str(C(3)));
set(handles.BP_600_to_1k_Textbox,'string',num2str(C(4)));
set(handles.BP_1k_to_2k_Textbox,'string',num2str(C(5)));
set(handles.BP_2k_to_4k_Textbox,'string',num2str(C(6)));
set(handles.BP_4k_to_8k_Textbox,'string',num2str(C(7)));
set(handles.BP_8k_to_16k_Textbox,'string',num2str(C(8)));
set(handles.HP_Textbox,'string',num2str(C(9)));


% --- Executes on button press in Reggae_Pushbutton.
function Reggae_Pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to Reggae_Pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.Jazz_Pushbutton,'BackgroundColor','white'); 
set(handles.HipHop_Pushbutton,'BackgroundColor','white'); 
set(handles.Pop_Pushbutton,'BackgroundColor','white'); 
set(handles.Rock_Pushbutton,'BackgroundColor','white'); 
set(handles.Reggae_Pushbutton,'BackgroundColor','green'); 
set(handles.Classical_Pushbutton,'BackgroundColor','white');
C = [3.5 3.3 3.3 -1.4 -1.4 -1.4 1.5 3.3 3.5];

set(handles.LP_slider,'value',C(1));                                        % This code is to set the variables that correspond to the sliders to
set(handles.BP_60_to_200_slider,'value',C(2));                              % certain values according to which preset is used
set(handles.BP_200_to_600_slider,'value',C(3));
set(handles.BP_600_to_1k_slider,'value',C(4));
set(handles.BP_1k_to_2k_slider,'value',C(5));
set(handles.BP_2k_to_4k_slider,'value',C(6));
set(handles.BP_4k_to_8k_slider,'value',C(7));
set(handles.BP_8k_to_16k_slider,'value',C(8));
set(handles.HP_slider,'value',C(9));

set(handles.LP_Textbox,'string',num2str(C(1)));
set(handles.BP_60_to_200_Textbox,'string',num2str(C(2)));
set(handles.BP_200_to_600_Textbox,'string',num2str(C(3)));
set(handles.BP_600_to_1k_Textbox,'string',num2str(C(4)));
set(handles.BP_1k_to_2k_Textbox,'string',num2str(C(5)));
set(handles.BP_2k_to_4k_Textbox,'string',num2str(C(6)));
set(handles.BP_4k_to_8k_Textbox,'string',num2str(C(7)));
set(handles.BP_8k_to_16k_Textbox,'string',num2str(C(8)));
set(handles.HP_Textbox,'string',num2str(C(9)));

% --- Executes on button press in Pop_Pushbutton.
function Pop_Pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to Pop_Pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.Jazz_Pushbutton,'BackgroundColor','white'); 
set(handles.HipHop_Pushbutton,'BackgroundColor','white'); 
set(handles.Pop_Pushbutton,'BackgroundColor','gree'); 
set(handles.Rock_Pushbutton,'BackgroundColor','white'); 
set(handles.Reggae_Pushbutton,'BackgroundColor','white'); 
set(handles.Classical_Pushbutton,'BackgroundColor','white');
C = [4 2.7 0.9 -1.4 -1.4 -1.4 0.9 2.7 3.5];

set(handles.LP_slider,'value',C(1));                                        % This code is to set the variables that correspond to the sliders to
set(handles.BP_60_to_200_slider,'value',C(2));                              % certain values according to which preset is used
set(handles.BP_200_to_600_slider,'value',C(3));
set(handles.BP_600_to_1k_slider,'value',C(4));
set(handles.BP_1k_to_2k_slider,'value',C(5));
set(handles.BP_2k_to_4k_slider,'value',C(6));
set(handles.BP_4k_to_8k_slider,'value',C(7));
set(handles.BP_8k_to_16k_slider,'value',C(8));
set(handles.HP_slider,'value',C(9));

set(handles.LP_Textbox,'string',num2str(C(1)));
set(handles.BP_60_to_200_Textbox,'string',num2str(C(2)));
set(handles.BP_200_to_600_Textbox,'string',num2str(C(3)));
set(handles.BP_600_to_1k_Textbox,'string',num2str(C(4)));
set(handles.BP_1k_to_2k_Textbox,'string',num2str(C(5)));
set(handles.BP_2k_to_4k_Textbox,'string',num2str(C(6)));
set(handles.BP_4k_to_8k_Textbox,'string',num2str(C(7)));
set(handles.BP_8k_to_16k_Textbox,'string',num2str(C(8)));
set(handles.HP_Textbox,'string',num2str(C(9)));


% --- Executes on button press in Rock_Pushbutton.
function Rock_Pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to Rock_Pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.Jazz_Pushbutton,'BackgroundColor','white'); 
set(handles.HipHop_Pushbutton,'BackgroundColor','white'); 
set(handles.Pop_Pushbutton,'BackgroundColor','white'); 
set(handles.Rock_Pushbutton,'BackgroundColor','green'); 
set(handles.Reggae_Pushbutton,'BackgroundColor','white'); 
set(handles.Classical_Pushbutton,'BackgroundColor','white');
C = [2 0.5 -1 -1.5 0.5 1.5 2 2 1.5];

set(handles.LP_slider,'value',C(1));                                        % This code is to set the variables that correspond to the sliders to
set(handles.BP_60_to_200_slider,'value',C(2));                              % certain values according to which preset is used
set(handles.BP_200_to_600_slider,'value',C(3));
set(handles.BP_600_to_1k_slider,'value',C(4));
set(handles.BP_1k_to_2k_slider,'value',C(5));
set(handles.BP_2k_to_4k_slider,'value',C(6));
set(handles.BP_4k_to_8k_slider,'value',C(7));
set(handles.BP_8k_to_16k_slider,'value',C(8));
set(handles.HP_slider,'value',C(9));

set(handles.LP_Textbox,'string',num2str(C(1)));                             
set(handles.BP_60_to_200_Textbox,'string',num2str(C(2)));
set(handles.BP_200_to_600_Textbox,'string',num2str(C(3)));
set(handles.BP_600_to_1k_Textbox,'string',num2str(C(4)));
set(handles.BP_1k_to_2k_Textbox,'string',num2str(C(5)));
set(handles.BP_2k_to_4k_Textbox,'string',num2str(C(6)));
set(handles.BP_4k_to_8k_Textbox,'string',num2str(C(7)));
set(handles.BP_8k_to_16k_Textbox,'string',num2str(C(8)));
set(handles.HP_Textbox,'string',num2str(C(9)));
% End of Preset buttons


% Save file button and text field
% --- Executes on button press in savefile_pushbutton.
function savefile_pushbutton_Callback(hObject, eventdata, handles)          % Save file 
% hObject    handle to savefile_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
editted_file = get(handles.newfile_textbox,'String');                       % Get name from text field
audiowrite(string(editted_file),handles.y_equalized,handles.Fs);            % Create file in current directory


function newfile_textbox_Callback(hObject, eventdata, handles)              % Text field for new file
% hObject    handle to newfile_textbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of newfile_textbox as text
%        str2double(get(hObject,'String')) returns contents of newfile_textbox as a double
%edit_filename = get(hObject,'string')

% --- Executes during object creation, after setting all properties.
function newfile_textbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to newfile_textbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% End of Code
clc
clear all
close all

% ECED 4502 DSP LAB FIR AND IIR Filters
% This script captures signal from MIC and sample it with fs
% DSP tool box and Data Acquization is required
% y is the acquired signal
% L is length of acquired sample
%fs=44100; % maximum sampling from sound card
%L= 1024;  % Default frame size

% Dialogie Box
flag=-1;
TF=0;
%x=0;
while TF==0
    x = inputdlg({'Enter Sampling Frequency in Hz (Maximum = 44100 Hz)',['Enter Frame Size ' ...
    '(default=1024)']},  'ECED 4502 DSP LAB', [1 40; 1 40]); 
    
               if str2num(x{1}) >10 & str2num(x{1}) <44101;
                TF=1;
               end
end


% TF = isempty( x ) 
 if isempty(x{2})==1; 
 %x{1}= 44100;
 x{2}=num2str(1024);
 end


% parameters initializing
fs=str2num(x{1});
L=str2num(x{2});
T= 1/fs;   % Sampling period     
t = (0:L-1)*T; % Time vector

info = audiodevinfo;
recObj = audiorecorder(fs,16,1);

%recObj = audiorecorder

disp('Start Recording');
recordblocking(recObj, 1/fs*(L+4410));
disp('End of Recording.');

play(recObj);

y = getaudiodata(recObj);

y=y([4410:end]);

save('data.txt','y','-ascii');
%type('data.txt');









figure(1)
t= 0:1/fs:L*1/fs;
plot(t,y);
title('Sampled Input Signal  ' )
xlabel('Time in Second')
ylabel('Sampled Signal Amplitude')
grid on


%plot(abs(fft(y)))


figure(2)
%[xn fs]=wavread('signal_name.wav');
%nf=1024; %number of point in DTFT

Y = fft(y);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

f = fs*(  0:(L/2) ) /L;
plot(f/1000,P1) 
title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('f (kHz)')
ylabel('|P1(f)|')
grid on





prompt = 'Press Enter to Run Filter Design ';
str = input(prompt,'s');



filterDesigner



%     fig = uifigure('Position',[680 678 398 271]);
%     bg = uibuttongroup(fig,'Position',[137 113 123 85]);  
%     rb1 = uiradiobutton(bg,'Position',[10 60 91 15]);
%     rb2 = uiradiobutton(bg,'Position',[10 38 91 15]);
%     rb1.Text = 'FIR Filter';
%     rb2.Text = 'IIR Filter';



prompt = 'Press Enter to Apply Designed Filter ';
str = input(prompt,'s');
if isempty(str)
    str = 'Y';
end


try
  
% IIR
yy = filter(Num,Den,y,[],1);
t = 0:length(y)-1;  %index vector
figure(3)
plot(t,y)
hold on
plot(t,yy)
legend('Input Data','IIR Filtered Data')
title('IIR Filtered Data')
grid on

figure(4)
%[xn fs]=wavread('signal_name.wav');
%nf=1024; %number of point in DTFT
YY = fft(yy);
P2 = abs(YY/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = fs*(0:(L/2))/L;
plot(f,P1) 
title('Single-Sided Amplitude Spectrum of Filtered Data')
xlabel('f (Hz)')
ylabel('|P1(f)|')
grid on

catch exception


% FIR filtered
figure(5)
yyy = filter(Num,1,y,[],1);
t = 0:length(y)-1;  %index vector
plot(t,y)
hold on
plot(t,yyy)
legend('Input Data','FIR Filtered Data')
title('Input Data VS. Filtered')
grid on

figure(6)
%[xn fs]=wavread('signal_name.wav');
%nf=1024; %number of point in DTFT
YY = fft(yyy);
P2 = abs(YY/L);
P2 = P2(1:L/2+1);
P2(2:end-1) = 2*P2(2:end-1);
f = fs*(0:(L/2))/L;
plot(f/1000,pow2db(P1),f/1000,pow2db(P2)) 
title('Single-Sided Spectrum of Filtered Data')
xlabel('f (kHz)')
ylabel('|P1(f)|')
legend('Input Data','FIR Filtered Data')
grid on





end












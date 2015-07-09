function[] = fftAnalysis(time, values, fmin, fmax)
% FFT transform and filtering
Signal = values- mean(values);

% Sampling
Period=1;% cycle
SamplingFrequency = 1/Period;
Duration = length(Signal)*1/SamplingFrequency;
% time=0 : Period : Duration;            time = time(1:end-1);
frequency = -SamplingFrequency/2 : 1/Duration : SamplingFrequency/2; 
frequency = frequency(1:end-1);

Signal = Signal'; % Original signal with noise

% FFT
SIG = fft(Signal); SIG_sort = abs(fftshift(SIG));

% Filter
FIL_LP_out = rectpuls(frequency, fmax*2);
FIL_LP_in  = rectpuls(frequency, fmin*2);
FIL_sort = FIL_LP_out - FIL_LP_in;

FIL = ifftshift(FIL_sort); 

fil = ifft(FIL);
fil_sort = fftshift(fil);

% Filtering
SIG2 = SIG.*FIL;
SIG2_sort = abs(fftshift(SIG2));

% iFFT
SignalFiltered = ifft(SIG2);

% plots,   in time domain
figure
subplot(2,2,1)
plot(time, Signal);
grid on
title('Time domain');
xlabel('cycle, [10 days]');
ylabel('Amplitude');

subplot(2,2,3)
plot(time,SignalFiltered)
grid on;
title('Filtered');
ylabel('Amplitude');
xlabel('cycle, [10 days]');

% in freq domain
subplot(2,2,2)
hold on; grid on
plot(frequency, SIG_sort);
plot(frequency, FIL_sort*max(SIG_sort),'r');
xlim([0 SamplingFrequency/2]);
title('Frequency  domain');
ylabel('Amplitude');
xlabel('Frequency, [1/cycle]');
text('Position',[1/36, max(SIG_sort)],'String','Annual')
hold off
subplot(2,2,4)
hold on; grid on
plot(frequency,SIG2_sort);
plot(frequency, FIL_sort*max(SIG_sort),'r');
xlim([0 SamplingFrequency/2]);
title('Filtered -frequency  domain');
ylabel('Amplitude');
xlabel('Frequency, [1/cycle]');
hold off
end
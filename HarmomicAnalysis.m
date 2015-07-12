function[c] = HarmomicAnalysis(values, time,TrendName)
% by Alexandr Sokolov

DataPool = SetGlobalVariables;

Year = 365.25; % days
CyclePeriod = 9.9156; % days 

T1 = (Year / 0.5 )/CyclePeriod;   
T2 = (Year / 1 )/CyclePeriod;   
T3 = (Year / 2 )/CyclePeriod;   
T4 = (Year / 4 )/CyclePeriod;   
T5 = (Year / 6 )/CyclePeriod;

T = [2 1 1/2 1/4 1/6]*Year/CyclePeriod;
NumberOfHarmonics = length(T);

% make Desing Matrix
TrendTerm = [ones(size(time,1),1),  time];
HarmonicsTerms = zeros(size(time,1),length(T)*2);

for index = 1:2:NumberOfHarmonics*2
    HarmonicsTerms(:,index)   = sin(2*pi/T((index+1)/2)*(time))';
    HarmonicsTerms(:,index+1) = cos(2*pi/T((index+1)/2)*(time))';
end

A = [TrendTerm HarmonicsTerms]; 


% A = [ones(size(time,1),1)'; 
%      time';
%      sin(2*pi/T1*(time))';
%      cos(2*pi/T1*(time))';
%      sin(2*pi/T2*(time))'; 
%      cos(2*pi/T2*(time))'; 
%      sin(2*pi/T3*(time))'; 
%      cos(2*pi/T3*(time))'; 
%      sin(2*pi/T4*(time))'; 
%      cos(2*pi/T4*(time))';
%      sin(2*pi/T5*(time))';
%      cos(2*pi/T5*(time))']';
c = (A'*A)^-1*A'*values;

error = A*c-values;
M = size(time,1);
N = 2;
variance = (error'*error)/(M-N);


y = c(1)+c(2)*(time) + c(3)*sin(2*pi/T1*(time)) + c(4)*cos(2*pi/T1*(time)) + c(5)*sin(2*pi/T2*(time)) + c(6)*cos(2*pi/T2*(time)) + c(7)*sin(2*pi/T3*(time)) + c(8)*cos(2*pi/T3*(time)+ c(9)*sin(2*pi/T4*(time)) + c(10)*cos(2*pi/T4*(time)) + c(11)*sin(2*pi/T5*(time)) + c(12)*cos(2*pi/T5*(time)));

f1 = c(1)+c(2)*(time);
f2 = c(1)+c(2)*(time) + c(3)*sin(2*pi/T1*(time)) + c(4)*cos(2*pi/T1*(time));
f3 = c(1)+c(2)*(time) + c(3)*sin(2*pi/T1*(time)) + c(4)*cos(2*pi/T1*(time)) + c(5)*sin(2*pi/T2*(time)) + c(6)*cos(2*pi/T2*(time));
f4 = c(1)+c(2)*(time) + c(3)*sin(2*pi/T1*(time)) + c(4)*cos(2*pi/T1*(time)) + c(5)*sin(2*pi/T2*(time)) + c(6)*cos(2*pi/T2*(time)) + c(7)*sin(2*pi/T3*(time)) + c(8)*cos(2*pi/T3*(time));
f5 = c(1)+c(2)*(time) + c(3)*sin(2*pi/T1*(time)) + c(4)*cos(2*pi/T1*(time)) + c(5)*sin(2*pi/T2*(time)) + c(6)*cos(2*pi/T2*(time)) + c(7)*sin(2*pi/T3*(time)) + c(8)*cos(2*pi/T3*(time)+ c(9)*sin(2*pi/T4*(time)) + c(10)*cos(2*pi/T4*(time)));
f6 = c(1)+c(2)*(time) + c(3)*sin(2*pi/T1*(time)) + c(4)*cos(2*pi/T1*(time)) + c(5)*sin(2*pi/T2*(time)) + c(6)*cos(2*pi/T2*(time)) + c(7)*sin(2*pi/T3*(time)) + c(8)*cos(2*pi/T3*(time)+ c(9)*sin(2*pi/T4*(time)) + c(10)*cos(2*pi/T4*(time)) + + c(11)*sin(2*pi/T5*(time)) + c(12)*cos(2*pi/T5*(time)));


h1 = c(3)*sin(2*pi/T1*(time)) + c(4)*cos(2*pi/T1*(time));
h2 = c(5)*sin(2*pi/T2*(time)) + c(6)*cos(2*pi/T2*(time));
h3 = c(7)*sin(2*pi/T3*(time)) + c(8)*cos(2*pi/T3*(time));
h4 = c(9)*sin(2*pi/T4*(time)) + c(10)*cos(2*pi/T4*(time));
h5 = c(11)*sin(2*pi/T5*(time)) + c(12)*cos(2*pi/T5*(time));

Trend_harmonics = values - h1 - h2 - h3 - h4 - h5;

a_mmPerYear = (c(2) * 1000) * (Year/CyclePeriod); % [m/cycle] -> [mm/year]
SlopeTxt = ([' Global Trend: ',num2str(a_mmPerYear),' [mm/year]']);

if (~strcmp(TrendName,'no'))
    fig1 = figure;
    set(gcf,'PaperPositionMode','auto')
    set(fig1, 'Position', [0 0 1900 1000])
    subplot(4,2,1)
    hold on
    plot(time,values,'.-b')
    plot(time,f1,'r')
    plot(time,f6,'m')
    xlim([min(time) max(time)])
    subplot(4,2,2)
    hold on
    plot(time,h1,'b')
    plot(time,h2,'g')
    plot(time,h3,'black')
    plot(time,h4,'y')
    plot(time,h5,'r')
    xlim([min(time) max(time)])
    subplot(4,2,3)
    hold on
    plot(time,values-f1,'.-b')
    plot(time,h1,'m')
    xlim([min(time) max(time)])
    subplot(4,2,4)
    hold on
    plot(time,values-f2,'.-b')
    plot(time,h2,'g')
    xlim([min(time) max(time)])
    subplot(4,2,5)
    hold on
    plot(time,values-f3,'.-b')
    plot(time,h3,'black')
    xlim([min(time) max(time)])
    subplot(4,2,6)
    hold on
    plot(time,values-f4,'.-b')
    plot(time,h4,'r')
    xlim([min(time) max(time)])
    subplot(4,2,7)
    hold on
    plot(time,values-f5,'.-b')
    plot(time,h5,'r')
    xlim([min(time) max(time)])
    subplot(4,2,8)
    hold on
    plot(time,Trend_harmonics,'.-b')
    plot(time,f1,'r')
    xlabel('Cycle, [1 cycle = 10 days]')
    ylabel('change [m]')
    legend(['Timeseries without harmonics'], 'Trend')
    text('Position',[time(2), max(Trend_harmonics)],'String',SlopeTxt)
    text('Position',[time(2), min(Trend_harmonics)],'String',TrendName)
    xlim([min(time) max(time)])
    % ylim([min(Trend_harmonics) max(Trend_harmonics)])

    
    
    fig2= figure;
    set(gcf,'PaperPositionMode','auto')
    set(fig2, 'Position', [0 0 1900 1000])
    subplot(2,1,1)
    hold on
    plot(time,values,'.-b')
    plot(time,f1,'r')
    plot(time,f6,'m')
    xlabel('Cycle, [1 cycle = 10 days]')
    ylabel('[m]')
    legend('timeseries','trend','approximation')
    xlim([min(time) max(time)])
    subplot(2,1,2)
    hold on
    plot(time,Trend_harmonics,'.-b')
    plot(time,f1,'r')
    xlabel('Cycle, [1 cycle = 10 days]')
    ylabel('[m]')
    legend('Timeseries - harmonics','Trend')
    
    text('Position',[time(2), max(Trend_harmonics)],'String',SlopeTxt)
    text('Position',[time(2), min(Trend_harmonics)],'String',TrendName)    
    xlim([min(time) max(time)])
    %ylim([min(Trend_harmonics) max(Trend_harmonics)])

    print(fig1, '-dpng',[DataPool,'Results\Trends\Trend_All_',TrendName,'.png']);
    print(fig2, '-dpng',[DataPool,'Results\Trends\Trend_',TrendName,'.png']);
end

end
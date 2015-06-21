function[a, b, figTrend] = LinearTrend(x, y)
% === //   y = a*x + b   //===
Year = 365.25; % days
CyclePeriod = 9.9156; % days is 1 cycle of Jason-1
tic
A = [ones(size(x,1),1), (x)];
c = (A'*A)^-1*A'*y
error = A*c-y;
M = size(x,1);
N = 2;
variance = (error'*error)/(M-N);
yFunc = c(1)+c(2)*x;
a = c(2);
b = c(1);
t1 = toc 
a_mmPerYear = (a / CyclePeriod) * Year*1000; % [m/cycle] -> [mm/year]
SlopeTxt = ([' Global Trend: ',num2str(a_mmPerYear),' [mm/year]'])

figTrend = figure
subplot(3,1,1:2)
hold on
plot(x,y,'.-b')
plot(x,yFunc,'r')
xlabel('Cycle, [1 cycle = 10 days]')
ylabel('Global SSH, [m]')
legend('Global SSH timeseries', 'Trend')
text('Position',[x(2), max(y)],'String',SlopeTxt)
xlim([min(x) max(x)])
hold off
subplot(3,1,3)
hold on
plot(x,error)
plot(x,0*x,'g')
xlabel('Cycle, [1 cycle = 10 days]')
ylabel('Error, [m]')
text('Position',[x(2), max(error)],'String',[' Variance: ',num2str(variance)])
legend('error')
xlim([min(x) max(x)])
hold off

%%
% tic
% a2 = (sum((x - mean(x)).*(y - mean(y)))) / sum((x - mean(x)).^2)
% b2 = mean(y) - a2 * mean(x)
% t2 = toc
% % Graphics
% a_mmPerYear = (a2 / CyclePeriod) * Year*1000; % [m/cycle] -> [mm/year]
% GlobalTrendLine = a2*x + b2;
% SlopeTxt = (['Global Trend: ',num2str(a_mmPerYear),' [mm/year]'])
% 
% % figTrend = figure;
% % hold on
% subplot(2,2,2)
% hold on
% plot(x,y,'.-b')
% plot(x,GlobalTrendLine, 'r')
% text('Position',[median(x), median(y)],'String',SlopeTxt)
% xlabel('Cycle, [1 cycle = 10 days]')
% ylabel('Global SSH, [m]')
% legend('Global SSH')
% hold off

end

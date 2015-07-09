function[figStat] = Statistics(Data)
% Plot of Statistics for cycle FILTERED


Number_of_bars = 50;
xlimits = [0 size(Data,1)];



figStat = figure;
subplot(3,8,1:3); hold on
plot(Data(:,6),'b');
plot(sort(Data(:,6),'descend'),'r')
legend('stdalt','stdalt sorted');
ylabel('[m]');
set(gca,'XLim', xlimits);
set(gca,'YLim', [0 0.25]);
hold off

subplot(3,8,4)
hist(Data(:,6),Number_of_bars);
set(gca,'XLim', [0 0.25]);
xlabel('[m]')

subplot(3,8,5:7); hold on
plot(Data(:,21),'b');
plot(sort(Data(:,21),'descend'),'r');
legend('SSH','SSH sorted');
ylabel('[m]');
set(gca,'XLim', xlimits);
set(gca,'YLim', [-100 100]);
hold off; 

subplot(3,8,8)
hist(Data(:,21),Number_of_bars)
xlabel('[m]')
set(gca,'XLim', [-100 100]);

subplot(3,8,9:11); hold on
plot(Data(:,7),'b');
plot(sort(Data(:,7),'descend'),'r');
legend('swh','swh sorted');
ylabel('[m]');
set(gca,'XLim', xlimits);
set(gca,'YLim', [0 12]);
hold off; 

subplot(3,8,12)
hist(Data(:,7),Number_of_bars)
xlabel('[m]')
set(gca,'XLim', [0 12]);

subplot(3,8,13:15); hold on
plot(Data(:,22),'b')
plot(sort(Data(:,22),'descend'),'r');
legend('SSH-mssh','SSH-mssh sorted');
ylabel('[m]');
set(gca,'XLim', xlimits);
set(gca,'YLim', [-1.5 1.5]);
hold off; 

subplot(3,8,16)
hist(Data(:,22),Number_of_bars)
xlabel('[m]')
set(gca,'XLim', [-1.5 1.5]);

subplot(3,8,17:19); hold on
plot(Data(:,20),'b')
plot(sort(Data(:,20),'descend'),'r');
legend('SumOfCorrections','SumOfCorrections sorted');
ylabel('[m]');
set(gca,'XLim', xlimits);
hold off; 

subplot(3,8,20)
hist(Data(:,20),Number_of_bars)
xlabel('[m]')
set(gca,'XLim', [-6 2]);

subplot(3,8,21:23); hold on
plot(Data(:,23),'b')
plot(sort(Data(:,23),'descend'),'r');
legend('SSH-geoh','SSH-geoh sorted');
ylabel('[m]');
set(gca,'XLim', xlimits);
hold off;

subplot(3,8,24)
hist(Data(:,23),Number_of_bars)
xlabel('[m]')
set(gca,'XLim', [-2 3]);

end
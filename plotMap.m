
textLegend = 'grid 1x1, factor 1.6'

FigGrid1 = figure(1);
pcolor(flipud(CounterMatrix));
legend(textLegend);
xlabel('longitude')
ylabel('latitude')
set(gca,'XTickLabel',[40:40:360])
set(gca,'YTickLabel',[-50:20:70])
colorbar


%%

Fig_SSH_Map = figure(2);
pcolor(flipud(Average));
legend(textLegend);
xlabel('longitude')
ylabel('latitude')
set(gca,'XTickLabel',[40:40:360])
set(gca,'YTickLabel',[-50:20:70])
colorbar;


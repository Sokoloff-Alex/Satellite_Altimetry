%% Plot distribution on sample pixels
close all

for row = 60:1:64;
    for column = 100:1:104
        number = CounterMatrix(row, column);
        DistanceVector = DistanceMatrix(row,column,1:number);
        DistanceVector = DistanceVector(:);
        ValuesVector = ValuesMatrix(row,column,1:number);
        ValuesVector = ValuesVector(:);
        Lat = CoordMatrix(row,column,1:number,1);
        Lat = Lat(:);
        Long = CoordMatrix(row,column,1:number,2);
        Long = Long(:);
        Color = rand(1,3);

        figure(1)
        subplot(1,3,1)
        hold on
        plot(DistanceVector, ValuesVector, '.','Color',Color)
        xlabel('Distance, [deg]');
        ylabel('Value,[m]');
        subplot(1,3,2:3)
        hold on
        plot(Long, Lat, '.','Color',Color)
        plot(Grid(row,column,2),Grid(row,column,1),'o','MarkerSize',111,'Color',Color)
        xlabel('Longitude, [deg]')
        ylabel('Latitude, [deg]')
        axis equal
    end
end

% Apllied Computer Science
% Satellite altimetry
% 20.01.2015
% by Sokolov Alexandr, ESPACE, TUM

clear all
clc

SatelliteName = ('envisat')
% SatelliteName = ('jason1');

MetaFileName = ('tu_envisat.rmp');
% [NumberOfParameters, Parameter, LegthOfByte, DataType, Desimal, Unit, ShortCut, DescriptionOfParameter] = ParseRMP(MetaFileName);

var = ['0022 0151 0452 0634 0666 0728 0747 0830 0863 0957'];

filenameSample = ['033_',var(1:4),'tu_',SatelliteName,'.00'];
NameLenght = size(filenameSample,2);
i = 1;
for FileIndex = 1:10
    FileNames(FileIndex,:) = ['033_',var(i:i+3),'tu_',SatelliteName,'.00']; 
    i = i + 5;
end
FileNames

%

for i = 1:10
FilePathName(i,:) = ['D:\TUM\Applied Computer Science\Altimetry\',SatelliteName,'_raw/',FileNames(i,:)];
% FileID = fopen(FilePathName,'r');
% fclose(FileID)
end
FilePathName
% %Parse RMP file 
% MetaFileName = ('tu_envisat.rmp');
% [NumberOfParameters, Parameter, LegthOfByte, DataType, Desimal, Unit, ShortCut, DescriptionOfParameter] = Parser(MetaFileName)

%% Parse Sat Date files
for i = 1:10
     Records = ParseSAT(SatelliteName, var);
    
    figure
    hold on
    plot(Records(2,:),Records(3,:))
end



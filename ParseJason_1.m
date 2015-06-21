function[Records] = ParseJason_1(FilePathName)
% Parse Satellite files using info from RMP file
% Apllied Computer Science 
% 20.01.2015
% by Sokolov Alexandr, ESPACE, TUM

% Files to process
% CurrentDir = cd;
% FilePathName = [FilePathName]; 
FileID = fopen(FilePathName,'r');
Records = zeros(5000,19); % min 3500, Dummy matrix, % Nodal period: 6 745.72 seconds (or 1h52')

counter = 1;
state = isempty(FileID);

while (state ~=1)
    
    jday   = fread(FileID,1,'int32')*100000;
    glat   = fread(FileID,1,'int32')*1000000;
    glon   = fread(FileID,1,'uint32')*1000000;
    hsat   = fread(FileID,1,'uint32')*1000;
    ralt   = fread(FileID,1,'uint32')*1000;
    stdalt = fread(FileID,1,'int16')*1000;
    swh    = fread(FileID,1,'int16')*1000;
    otide  = fread(FileID,1,'int16')*1000;
    etide  = fread(FileID,1,'int16')*1000;
    invb   = fread(FileID,1,'int16')*1000;
    wtrop  = fread(FileID,1,'int16')*1000;
    dtrop  = fread(FileID,1,'int16')*1000;
    ionos  = fread(FileID,1,'int16')*1000; 
    mssh   = fread(FileID,1,'int32')*1000;
    geoh   = fread(FileID,1,'int32')*1000;
    iflags = fread(FileID,1,'uint8');
    oflags = fread(FileID,1,'uint8');
    ptide  = fread(FileID,1,'int16')*1000;
    emb    = fread(FileID,1,'int16')*1000;
    
    Message = [jday,glat,glon,hsat,ralt,stdalt,swh,otide,etide,invb,wtrop,dtrop,ionos,mssh,geoh,iflags,oflags,ptide,emb];
    Records(counter,:) = Message;
    state = feof(FileID);
    counter = counter + 1;
    
    if state == 1
        break
    end
end
% Records = Records(1:counter,:);
Records( all(~Records,2), : ) = []; %Remove zero rows
fclose(FileID);
end


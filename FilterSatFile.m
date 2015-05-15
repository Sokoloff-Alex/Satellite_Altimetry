function[Records] = FilterSatFile(File_A_Path,File_B_Path, iflags, oflags, STD_threshold, SWH_threshold, SSH_mssh_threshold)
% filter Satellite Data file
% by Alexandr Sokolov

File_A_ID = fopen(File_A_Path, 'r');
File_B_ID = fopen(File_B_Path, 'w');

% ===== Add header ========================================================
fprintf(File_B_ID, fgetl(File_A_ID));
fprintf(File_B_ID, '\r\n');
fprintf(File_B_ID, '%18s %22s\r\n',  ' Date of filtering: ', datestr(now,'dd-mmmm-yyyy, HH:MM:SS'));
fprintf(File_B_ID, '%16s %60s \r\n',' Original file: ', File_A_Path);
fprintf(File_B_ID, '%18s %9s \r\n',' Allowed ins. flags:', iflags);
fprintf(File_B_ID, '%18s %9s \r\n',' Allowed orb. flags:', oflags);
fprintf(File_B_ID, '%18s %4s [m] \r\n', ' St. dev. max limit:', num2str(STD_threshold)); 
fprintf(File_B_ID, '%18s %4s [m] \r\n', ' SWH. threshold:', num2str(SWH_threshold)); 
fprintf(File_B_ID, '%18s %4s [m] \r\n', ' abs(SSH - mssh) threshold:', num2str(SSH_mssh_threshold)); 
fprintf(File_B_ID, '\r\n');
iflags = bin2dec(iflags);
oflags = bin2dec(oflags);

fgetl(File_A_ID); % Skip Date of parsing
fprintf(File_B_ID, fgetl(File_A_ID)); % empty line
fprintf(File_B_ID, fgetl(File_A_ID)); % copy ShorCuts
fprintf(File_B_ID, '%15s\t%15s\t%15s\t%15s\r\n','SumOfCorr-s','SSH','SSH - mssh','SSH - geoh'); % ShorCuts
fprintf(File_B_ID, fgetl(File_A_ID)); % copy Units 
fprintf(File_B_ID, '%15s\t%15s\t%15s\t%15s\r\n', 'm','m','m','m'); % Units 
fprintf(File_B_ID, fgetl(File_A_ID)); % separation-line
fprintf(File_B_ID,'=================================================================');
fprintf(File_B_ID, '\r\n');


% ===== Filter all line records ===========================================
state = feof(File_A_ID);

Records = zeros(3500,23);
counter = 0;
while state ~= 1
    counter = counter + 1;
    DataLine = fgetl(File_A_ID);
    Str = strsplit(DataLine);
    STD_Alt = str2double(Str{7});
    swh = str2double(Str{8});
    ifl = str2double(Str{17});
    ofl = str2double(Str{18});
    if ifl <= iflags && ofl < oflags && STD_Alt < STD_threshold && swh < SWH_threshold
        hsat  = str2double(Str{5});
        ralt  = str2double(Str{6});
        etide = str2double(Str{10});
        invb  = str2double(Str{11});
        wtrop = str2double(Str{12});
        dtrop = str2double(Str{13});
        ionos = str2double(Str{14});
        mssh  = str2double(Str{15});
        geoh  = str2double(Str{16});
        ptide = str2double(Str{19});
        emb = str2double(Str{20});
        SumOfCorrections = etide + invb + wtrop + dtrop + ionos + ptide + emb;
        SSH = hsat - ralt - SumOfCorrections;
        SSH_mssh = SSH - mssh;
        SSH_geoh = SSH - geoh;
        if abs(SSH_mssh) < SSH_mssh_threshold % 2 meters threshold in SSH - mssh difference
            fprintf(File_B_ID, DataLine);
            fprintf(File_B_ID,'%15.3f\t%15.3f\t%15.3f\t%15.3f\r\n', SumOfCorrections, SSH, SSH_mssh, SSH_geoh);     
    %         fprintf(File_B_ID, '\r\n');
            [Records(counter,:)] = [str2double(Str(2:20)), SumOfCorrections, SSH, SSH_mssh, SSH_geoh];     
        end
    end
    state = feof(File_A_ID);
end
Records( all(~Records,2), : ) = []; %Remove zero rows
% Record_Size = size(Records)
fclose(File_A_ID);
fclose(File_B_ID);
end
function[DataLineFiltered] = DataLineFilter(DataLine, iflags, oflags, STD_threshold, SWH_threshold, SSH_mssh_threshold)
% Filter data line and output error compensated and filtered data line
% by Alexandr Sokolov
    STD_Alt = DataLine(6);
    swh = DataLine(7);
    ionos = DataLine(13);
    ifl = DataLine(16);
    ofl = DataLine(17);
    if ifl <= iflags && ofl < oflags && STD_Alt < STD_threshold && swh < SWH_threshold && ionos < 0
        hsat  = DataLine(4);
        ralt  = DataLine(5);
        etide = DataLine(9);
        invb  = DataLine(10);
        wtrop = DataLine(11);
        dtrop = DataLine(12);
        mssh  = DataLine(14);
        geoh  = DataLine(15);
        ptide = DataLine(18);
        emb   = DataLine(19);
        SumOfCorrections = etide + invb + wtrop + dtrop + ionos + ptide + emb;
        SSH = hsat - ralt - SumOfCorrections;
        SSH_mssh = SSH - mssh;
        SSH_geoh = SSH - geoh;
        if abs(SSH_mssh) < SSH_mssh_threshold % 2 meters threshold in SSH - mssh diff
            DataLineFiltered = [DataLine, SumOfCorrections, SSH, SSH_mssh, SSH_geoh];   
        end
    else
        DataLineFiltered = 0;
    end
end
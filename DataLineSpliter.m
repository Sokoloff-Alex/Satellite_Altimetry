function[DataLineFiltered_in, DataLineFiltered_out] = DataLineSpliter(DataLine, iflags, oflags, STD_threshold, SWH_threshold, SSH_mssh_threshold)
% Filter data line and output error compensated and filtered data line
% by Alexandr Sokolov
    
    hsat  = DataLine(4);
    ralt  = DataLine(5);
    stdalt= DataLine(6);
    swh   = DataLine(7);
    otide = DataLine(8);
    etide = DataLine(9);
    invb  = DataLine(10);
    wtrop = DataLine(11);
    dtrop = DataLine(12);
    ionos = DataLine(13);
    mssh  = DataLine(14);
    geoh  = DataLine(15);
    ifl   = DataLine(16);
    ofl   = DataLine(17);
    ptide = DataLine(18);
    emb   = DataLine(19);
    SumOfCorrections = otide + etide + invb + wtrop + dtrop + ionos + ptide + emb;
    SSH = hsat - ralt - SumOfCorrections;
    SSH_mssh = SSH - mssh;
    SSH_geoh = SSH - geoh;
    if stdalt < STD_threshold && swh < SWH_threshold && ionos < 0 && abs(SSH_mssh) < SSH_mssh_threshold % remove really contaminated data
        iflStr = dec2bin(ifl,8);
        oflStr = dec2bin(ofl,8);
        if min(iflStr(:) <= iflags(:)) && min(oflStr(:) <= oflags(:))
            DataLineFiltered_in = [DataLine, SumOfCorrections, SSH, SSH_mssh, SSH_geoh];   
            DataLineFiltered_out = 0;
        else
            DataLineFiltered_out = [DataLine, SumOfCorrections, SSH, SSH_mssh, SSH_geoh];   
            DataLineFiltered_in = 0;             
        end
        
        
%         if ifl <= iflags && ofl < oflags   % split data
%             DataLineFiltered_in = [DataLine, SumOfCorrections, SSH, SSH_mssh, SSH_geoh];   
%             DataLineFiltered_out = 0;
%         else
%             DataLineFiltered_out = [DataLine, SumOfCorrections, SSH, SSH_mssh, SSH_geoh];   
%             DataLineFiltered_in = 0; 
%         end
    else
        DataLineFiltered_in = 0;
        DataLineFiltered_out = 0;
    end
end
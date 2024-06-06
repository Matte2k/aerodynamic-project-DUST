function [inPreVars] = inPreTailInit(tailRightFilePath,tailLeftFilePath)
%INPUT PRE TAIL INITIALIZATOR - Write strings to set dust_pre for tail configuration
%
%   Syntax:
%       [inPreVars] = inPreTailInit(tailRightFilePath,tailLeftFilePath)
%
%   Input:
%       tailRightFilePath,  path:  file containing right lerx settings
%       tailLeftFilePath,   path:  file containing left lerx settings
%
%   Output:
%       inPreVars,  cell:  contains all the string that has to be printed in the
%                          dust_pre file to build tail configuration
%
%                               Matteo Baio, Politecnico di Milano, 06/2024
%


    % right tail
    comp_nameR = sprintf('comp_name = tail_right');
    geo_fileR  = sprintf('geo_file = %s',tailRightFilePath);
    ref_tagR   = sprintf('ref_tag = Tail');

    % left tail
    comp_nameL = sprintf('comp_name = tail_left');
    geo_fileL  = sprintf('geo_file = %s',tailLeftFilePath);
    ref_tagL   = sprintf('ref_tag = Tail');
    
    inPreVars = {   comp_nameR, geo_fileR, ref_tagR, ...
                    comp_nameL, geo_fileL, ref_tagL, };

end
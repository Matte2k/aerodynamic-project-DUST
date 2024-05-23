function [inPreVars] = inPreLerxInit(lerxRightFilePath,lerxLeftFilePath)
%INPUT PRE LERX INITIALIZATOR - Write strings to set dust_pre for lerx configuration
%
%   Syntax:
%       [inPreVars] = inPreLerxInit(lerxRightFilePath,lerxLeftFilePath)
%
%   Input:
%       lerxRightFilePath,  path:  file containing right lerx settings
%       lerxLeftFilePath,   path:  file containing left lerx settings
%
%   Output:
%       inPreVars,  cell:  contains all the string that has to be printed in the
%                          dust_pre file to build lerx configuration
%
%                               Matteo Baio, Politecnico di Milano, 06/2024
%


    % right wing
    comp_nameR = sprintf('comp_name = lerx_right');
    geo_fileR  = sprintf('geo_file = %s',lerxRightFilePath);
    ref_tagR   = sprintf('ref_tag = Lerx');

    % left wing
    comp_nameL = sprintf('comp_name = lerx_left');
    geo_fileL  = sprintf('geo_file = %s',lerxLeftFilePath);
    ref_tagL   = sprintf('ref_tag = Lerx');
    
    inPreVars = {   comp_nameR, geo_fileR, ref_tagR, ...
                    comp_nameL, geo_fileL, ref_tagL, };

end
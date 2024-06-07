function [inPreVars] = inPreVortexInit(vortexRightFilePath,vortexLeftFilePath)
%INPUT PRE VORTEX INITIALIZATOR - Write strings to set dust_pre for vortex configuration
%
%   Syntax:
%       [inPreVars] = inPreVortexInit(vortexRightFilePath,vortexLeftFilePath)
%
%   Input:
%       vortexRightFilePath,  path:  file containing right lerx settings
%       vortexLeftFilePath,   path:  file containing left lerx settings
%
%   Output:
%       inPreVars,  cell:  contains all the string that has to be printed in the
%                          dust_pre file to build vortex configuration
%
%                               Matteo Baio, Politecnico di Milano, 06/2024
%


    % right vortex
    comp_nameR = sprintf('comp_name = vortex_right');
    geo_fileR  = sprintf('geo_file = %s',vortexRightFilePath);
    ref_tagR   = sprintf('ref_tag = Vortex');

    % left vortex
    comp_nameL = sprintf('comp_name = vortex_left');
    geo_fileL  = sprintf('geo_file = %s',vortexLeftFilePath);
    ref_tagL   = sprintf('ref_tag = Vortex');
    
    inPreVars = {   comp_nameR, geo_fileR, ref_tagR, ...
                    comp_nameL, geo_fileL, ref_tagL, };

end
function [inPreVars] = inPreVortexInit(vortexRightFilePath,vortexLeftFilePath)
%INPUT PRE VORTEX INITIALIZATOR - Write strings to set dust_pre for vortex part
%
%   Syntax:
%       [inPreVars] = inPreVortexInit(vortexRightFilePath,vortexLeftFilePath)
%
%   Input:
%       vortexRightFilePath,   path:  file containing right vortex settings
%       vortexLeftFilePath(*), path:  file containing left vortex settings
%       
%   Output:
%       inPreVars,  cell:  contains all the string that has to be printed in the
%                          dust_pre file to build vortex part
%
%   Alternative input:
%       vortexRightFilePath(*) as only input build vortex as a single body...
%       NOT two part mirrored as when the inputs are two
%
%                               Matteo Baio, Politecnico di Milano, 06/2024
%


    if nargin == 1 || isempty(vortexLeftFilePath)
        % vortex
        comp_nameF = sprintf('comp_name = vortex_right');
        geo_fileF  = sprintf('geo_file = %s',wingRightFilePath);
        ref_tagF   = sprintf('ref_tag = Vortex');
        inPreVars  = {  comp_nameF, geo_fileF, ref_tagF};

    elseif nargin == 2
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

end
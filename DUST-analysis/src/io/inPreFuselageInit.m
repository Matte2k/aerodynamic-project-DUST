function [inPreVars] = inPreFuselageInit(fuselageRightFilePath,fuselageLeftFilePath)
%INPUT PRE FUSELAGE INITIALIZATOR - Write strings to set dust_pre for fuselage part
%
%   Syntax:
%       [inPreVars] = inPreFuselageInit(fuselageRightFilePath,fuselageLeftFilePath)
%
%   Input:
%       fuselageRightFilePath,   path:  file containing right fuselage settings
%       fuselageLeftFilePath(*), path:  file containing left fuselage settings
%       
%   Output:
%       inPreVars,  cell:  contains all the string that has to be printed in the
%                          dust_pre file to build fuselage part
%
%   Alternative input:
%       fuselageRightFilePath(*) as only input build fuselage as a single body...
%       NOT two part mirrored as when the inputs are two
%
%                               Matteo Baio, Politecnico di Milano, 06/2024
%


    if nargin == 1  || isempty(fuselageLeftFilePath)
        % fuselage
        comp_nameF = sprintf('comp_name = fuselage_right');
        geo_fileF  = sprintf('geo_file = %s',fuselageRightFilePath);
        ref_tagF   = sprintf('ref_tag = Body');
        inPreVars  = {  comp_nameF, geo_fileF, ref_tagF};

    elseif nargin == 2
        % right fuselage part
        comp_nameR = sprintf('comp_name = fuselage_right');
        geo_fileR  = sprintf('geo_file = %s',fuselageRightFilePath);
        ref_tagR   = sprintf('ref_tag = Body');

        % left fuselage part
        comp_nameL = sprintf('comp_name = fuselage_left');
        geo_fileL  = sprintf('geo_file = %s',fuselageLeftFilePath);
        ref_tagL   = sprintf('ref_tag = Body');

        inPreVars = {   comp_nameR, geo_fileR, ref_tagR, ...
                        comp_nameL, geo_fileL, ref_tagL };
    end
    
end
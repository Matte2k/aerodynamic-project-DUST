function [inPreVars] = inPreWingInit(wingRightFilePath,wingLeftFilePath,fuselageFilePath)
%INPUT PRE WING INITIALIZATOR - Write strings to set dust_pre for wing+fuselage configuration
%
%   Syntax:
%       [inPreVars] = inPreWingInit(wingRightFilePath,wingLeftFilePath,fuselageFilePath)
%
%   Input:
%       wingRightFilePath,  path:  file containing right wing settings
%       wingLeftFilePath,   path:  file containing left wing settings
%       fuselageFilePath,   path:  file containing fuselage settings
%
%   Output:
%       inPreVars,  cell:  contains all the string that has to be printed in the
%                          dust_pre file to build wing+fuselage configuration
%
%                               Matteo Baio, Politecnico di Milano, 06/2024
%


    % right wing
    comp_nameR = sprintf('comp_name = wing_right');
    geo_fileR  = sprintf('geo_file = %s',wingRightFilePath);
    ref_tagR   = sprintf('ref_tag = Wing');

    % left wing
    comp_nameL = sprintf('comp_name = wing_left');
    geo_fileL  = sprintf('geo_file = %s',wingLeftFilePath);
    ref_tagL   = sprintf('ref_tag = Wing');

    % fuselage
    comp_nameF = sprintf('comp_name = fuselage');
    geo_fileF  = sprintf('geo_file = %s',fuselageFilePath);
    ref_tagF   = sprintf('ref_tag = Body');
    
    inPreVars = {   comp_nameR, geo_fileR, ref_tagR, ...
                    comp_nameL, geo_fileL, ref_tagL, ...
                    comp_nameF, geo_fileF, ref_tagF  };

end
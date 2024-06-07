function [inPreVars] = inPreWingInit(wingRightFilePath,wingLeftFilePath)
%INPUT PRE WING INITIALIZATOR - Write strings to set dust_pre for wing part
%
%   Syntax:
%       [inPreVars] = inPreWingInit(wingRightFilePath,wingLeftFilePath)
%
%   Input:
%       wingRightFilePath,   path:  file containing right wing settings
%       wingLeftFilePath(*), path:  file containing left wing settings
%       
%   Output:
%       inPreVars,  cell:  contains all the string that has to be printed in the
%                          dust_pre file to build wing part
%
%   Alternative input:
%       wingRightFilePath(*) as only input build wing as a single body...
%       NOT two part mirrored as when the inputs are two
%
%                               Matteo Baio, Politecnico di Milano, 06/2024
%


    if nargin == 1 || isempty(wingLeftFilePath)
        % wing
        comp_nameF = sprintf('comp_name = wing_right');
        geo_fileF  = sprintf('geo_file = %s',wingRightFilePath);
        ref_tagF   = sprintf('ref_tag = Wing');
        inPreVars  = {  comp_nameF, geo_fileF, ref_tagF};

    elseif nargin == 2
        % right wing
        comp_nameR = sprintf('comp_name = wing_right');
        geo_fileR  = sprintf('geo_file = %s',wingRightFilePath);
        ref_tagR   = sprintf('ref_tag = Wing');

        % left wing
        comp_nameL = sprintf('comp_name = wing_left');
        geo_fileL  = sprintf('geo_file = %s',wingLeftFilePath);
        ref_tagL   = sprintf('ref_tag = Wing');

        inPreVars = {   comp_nameR, geo_fileR, ref_tagR, ...
                        comp_nameL, geo_fileL, ref_tagL };
    end

end
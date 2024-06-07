function [inPreVars] = inPreLerxInit(lerxRightFilePath,lerxLeftFilePath)
%INPUT PRE VORTEX INITIALIZATOR - Write strings to set dust_pre for lerx part
%
%   Syntax:
%       [inPreVars] = inPreLerxInit(lerxRightFilePath,lerxLeftFilePath)
%
%   Input:
%       lerxRightFilePath,   path:  file containing right lerx settings
%       lerxLeftFilePath(*), path:  file containing left lerx settings
%       
%   Output:
%       inPreVars,  cell:  contains all the string that has to be printed in the
%                          dust_pre file to build lerx part
%
%   Alternative input:
%       lerxRightFilePath(*) as only input build lerx as a single body...
%       NOT two part mirrored as when the inputs are two
%
%                               Matteo Baio, Politecnico di Milano, 06/2024
%


    if nargin == 1 || isempty(lerxLeftFilePath)
        % lerx
        comp_nameF = sprintf('comp_name = lerx_right');
        geo_fileF  = sprintf('geo_file = %s',lerxRightFilePath);
        ref_tagF   = sprintf('ref_tag = Lerx');
        inPreVars  = {  comp_nameF, geo_fileF, ref_tagF};

    elseif nargin == 2
        % right lerx
        comp_nameR = sprintf('comp_name = lerx_right');
        geo_fileR  = sprintf('geo_file = %s',lerxRightFilePath);
        ref_tagR   = sprintf('ref_tag = Lerx');

        % left lerx
        comp_nameL = sprintf('comp_name = lerx_left');
        geo_fileL  = sprintf('geo_file = %s',lerxLeftFilePath);
        ref_tagL   = sprintf('ref_tag = Lerx');
    
        inPreVars = {   comp_nameR, geo_fileR, ref_tagR, ...
                        comp_nameL, geo_fileL, ref_tagL, };
    end

end
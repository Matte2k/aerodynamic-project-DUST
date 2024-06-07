function [inPreVars] = inPreTailInit(tailRightFilePath,tailLeftFilePath)
%INPUT PRE TAIL INITIALIZATOR - Write strings to set dust_pre for tail part
%
%   Syntax:
%       [inPreVars] = inPreTailInit(tailRightFilePath,tailLeftFilePath)
%
%   Input:
%       tailRightFilePath,   path:  file containing right tail settings
%       tailLeftFilePath(*), path:  file containing left fuselatailge settings
%       
%   Output:
%       inPreVars,  cell:  contains all the string that has to be printed in the
%                          dust_pre file to build tail part
%
%   Alternative input:
%       tailRightFilePath(*) as only input build tail as a single body...
%       NOT two part mirrored as when the inputs are two
%
%                               Matteo Baio, Politecnico di Milano, 06/2024
%


    if nargin == 1 || isempty(tailLeftFilePath)
        % tail
        comp_nameF = sprintf('comp_name = tail_right');
        geo_fileF  = sprintf('geo_file = %s',tailRightFilePath);
        ref_tagF   = sprintf('ref_tag = Tail');
        inPreVars  = {  comp_nameF, geo_fileF, ref_tagF};

    elseif nargin == 2
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

end
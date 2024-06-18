function [reference] = runReferenceValue(absVelocity,rhoInf,Cref,Sref)
%RUN REFERENCE VALUE - Create a struct containing all the reference value
%needed to 'dataParser_DUST'
%
%   Syntax:
%       [reference] = runReferenceValue(absVelocity,rhoInf,Cref,Sref)
%
%   Input:
%       absVelocity,  double:  absolute value of wind velocity 
%       rhoInf,       double:  reference air density used to adimensionalize
%       Sref,         double:  reference surface used to adimensionalize
%       Cref,         double:  reference chord used to adimensionaize
%
%   Output:
%       reference,   struct:  group all the different reference values in a
%                             single struct
%
%                               Matteo Baio, Politecnico di Milano, 06/2024
%
    
    reference = struct;
        reference.absVelocity = absVelocity;
        reference.rhoInf      = rhoInf;
        reference.Cref        = Cref;
        reference.Sref        = Sref;
    
end


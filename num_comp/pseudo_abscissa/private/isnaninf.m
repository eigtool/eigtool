function bval = isnaninf(A)
% call : bval = isnaninf(A)
%  returns 1 if A contains an inifinite or a nan entry, otherwise
%  returna 0

%  input 
%     A         input matrix, vector or scalar
%  output
%     bval      1 if A has a infinite or a nan entry, 0 otherwise.


if isnan(A) | isinf(A)
    bval = 1;
else
    bval = 0;
end
    

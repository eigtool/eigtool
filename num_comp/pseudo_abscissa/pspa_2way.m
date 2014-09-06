function [f, z] = pspa_2way(A, epsln, prtlevel, plotfig, keyb)
% James Burke, Adrian Lewis, Emre Mengi and Michael Overton (Last update on September 2 2014)
% call:  [f, z] = pspa_2way(A, epsln, prtlevel, plotfig, keyb)
%  Quadratically convergent two-way Hamiltonian method to
%  compute the eps-pseudospectral abscissa of A.
%
% 
% note: This version calls Matlab's built-in routine 'eig' to
% compute eigenvalues of the Hamiltonian matrices. The accuracy
% of the algorithm heavily depends on detecting the imaginary 
% eigenvalues of the Hamiltonian matrices successfully. This
% implementation uses a tolerance to decide whether an 
% eigenvalue has zero real part or not. 
%       There is another version of the algorithm available on the 
% web site
%           http://www.cs.nyu.edu/faculty/overton/software/    
% That version calls mex object files to compute the eigenvalues
% of the Hamiltonian matrices. Mex files implemented by Peter
% Benner have the capability of returning imaginary eigenvalues
% exactly. For small epsln(such as 10^-9) and input matrices with 
% big norms(e.g 10^5), we strongly suggest you using the version 
% on the web.
%
%
%
%  The epsln-pseudospectral abscissa of A is the globally optimal value of: 
%      max Re z
%      s.t. sigma_min(A - z I) = epsln     (smallest singular value)
%
%
%  input
%     A         square matrix
%     epsln     real >= 0 (0 implies f is spectral abscissa)
%     prtlevel  1: chatty; 0: prints only if problems arise (default)
%     plotfig   0: no plot, otherwise figure number for plot
%     keyb      0: no keyboard mode(default), otherwise after each 
%		iteration enter keyboard mode
%              
%  output
%     f         the epsln-pseudospectral abscissa of A
%     z         one of the global maximizers except when
%               the matrix is real. If the input matrix is real 
%               it contains either a global optimizer on the
%               real axis or a complex conjugate pair.

if nargin <= 4
    keyb = 0;       % default: don't interact with the user
end

if nargin <= 3
   plotfig = 0;     % default: no plot
end
if nargin <= 2
   prtlevel = 0;    % default: no printing
end

if isnaninf(A)|isnaninf([epsln prtlevel plotfig])
   error('pspa_2way: nan or inf arguments not allowed')
end
if epsln < 0 | imag(epsln) ~= 0    
   error('pspa_2way: epsln must be nonnegative real')
end

n = length(A);
if size(A) ~= [n n]
   error('A must be square')
end

if (n >= 40)
    h = waitbar(0,'Computing Pseudospectral Abscissa...(initializing)');
else
    h = 0;
end



eA = eig(A);
if plotfig > 0
   figure(plotfig);
   plot(real(eA), imag(eA), 'ko')
   hold on
end



smalltol = 1e-10*max(norm(A),epsln);
purespa = max(real(eA));     % pure spectral abscissa
if epsln == 0  % pseudospectrum is just the spectrum
   [sortreal, indx] = sort(-real(eA));
   eA = eA(indx);
   f = purespa;
   ind = find(real(eA) >= f - smalltol);
   z = eA(ind);
   if (n >= 40)
       waitbar(1,h,'Computing Pseudospectral Abscissa...(completed)')
   end
   
   if (n >= 40)
        close(h)
   end
else   % much faster than bisection, but just as reliable        
   
   if (epsln < 10^-9)    
        warning('epsilon is too small, the accuracy may not be satisfactory')
        warning('please use the version on the web site http://www.cs.nyu.edu/faculty/overton/software/')
   end
    
   xold = -inf;
   [x,ind] = max(real(eA));  % initial iterate
   y = imag(eA(ind));
   if prtlevel > 0
      fprintf('\npspa_2way: x = %22.15f   ', x);
   end
   iter = 0;
   no_imageig = 0;
   ybest = [];
   E = epsln*eye(n);
   Areal = isreal(A);

   % imagtol is used to detect zero real parts
   imagtol = smalltol; 

   while ~no_imageig & x > xold    % x is increasing in exact arithmetic
      iter = iter + 1;
      if iter > 20
          if (n >= 40)
                close(h)
          end
         error('pspa_2way: too many steps')
      end
      yold = y;
      % given current x, look for all relevant intersections of vertical 
      % line with the pseudospectrum, process and return pair midpoints.
      % note: input x is a scalar, but output y is a vector.
      % the input ybest is a scalar.
      [y,imagtol] = pspa_2way_imag(A, E, epsln, x, ybest, iter, imagtol, ...
          plotfig, prtlevel,h);
      
      
      ptout = sprintf('Computing Pseudospectral Abscissa...(iteration %d)',iter);
      
      if (n >= 40)
          waitbar((2*(iter-1)+1)/12,h,ptout)
      end
      
      if keyb ~= 0
          keyboard
      end
      
      no_imageig = isempty(y);
      if ~no_imageig
         if prtlevel > 0
            fprintf('pspa_2way: y = %22.15f  ', y);    % y may be a vector
         end
         % given the resulting y values, look for rightmost intersection of
         % the corresponding horizontal lines with the pseudospectrum
         % note: input y is a vector, but output x is a scalar: the max
         % of the max values.  ybest is the corresponding y value and is
         % a scalar, even if there was a tie e.g. from a complex conjugate pair.
         xold = x;
         ybestt = ybest;
         [x, ybest] = pspa_2way_real(A, E, y, imagtol, plotfig, xold,h);
         
         if (n >= 40)
             waitbar((2*(iter-1)+2)/12,h)
         end
         
         if prtlevel > 0
            fprintf('\npspa_2way: x = %22.15f   ', x);
         end
         
         if x < xold
            x = xold;    % causes while loop to terminate
            ybest = ybestt;

            if prtlevel > 0
               fprintf('\npspa_2way: could not find bigger x')
            end
         end % end of if x < xold
      end % end of if ~no_imageig
   end % end of while
   
   
   if isempty(ybest) 
       if (n >= 40)
            close(h)
       end
       error('Failed in the first iteration(please use the version on the web site)');
   end

   if (n >= 40)
       waitbar(1,h,'Computing Pseudospectral Abscissa...(completed)')
   end


   f = x;
   z = x+i*ybest;
   if isreal(A) & ~isreal(z)
      z = [z; x-i*ybest];
   end
   

    if (n >= 40)
        close(h)
    end
      
end


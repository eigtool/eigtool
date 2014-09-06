function [f, z] = pspr_2way(A, epsln, prtlevel, plotfig, keyb)
% Michael Overton and Emre Mengi (Last Update on Spetember 2 2014)
% call: function [f, z] = pspr_2way(A, epsln, prtlevel, plotfig, keyb)
%  Quadratically convergent two-way method to compute
%  the eps-pseudospectral radius of A.
%   
%
%  The epsln-pseudospectral radius of A is the globally optimal value of: 
%      max |z|
%      s.t. sigma_min(A - z I) = epsln     (smallest singular value)
%
%
%  input
%     A         square matrix
%     epsln     real >= 0 (0 implies f is spectral radius)
%     prtlevel  1: chatty; 0: prints only if problems arise (default)
%     plotfig   0: no plot, otherwise figure number for plot
%     keyb      0: no keyboard mode(default), otherwise after each 
%		iteration enter keyboard mode
%              
%  output
%     f         the epsln-pseudospectral radius of A
%     z         one of the global maximizers except when
%               the matrix is real. If the input matrix is real 
%               it contains either a global optimizer on the
%               real axis or a complex conjugate pair.


if nargin <= 4
    keyb = 0;     % default: don't interact with the user
end
    
if nargin <= 3
    plotfig = 0; % default: don't draw
end

if nargin <= 2
    prtlevel = 0; % default: don't print
end


% error checks
if isnaninf(A)|isnaninf([epsln prtlevel plotfig])
   error('pspa_2way: nan or inf arguments not allowed')
end

if epsln < 0 | imag(epsln) ~= 0
   error('pspr_2way: epsln must be nonnegative real')
end

n = length(A);
if size(A) ~= [n n]
   error('A must be square')
end




if (n >= 30)
    h = waitbar(0,'Computing Pseudospectral Radius...(initializing)');
else
    h = 0;
end




% draw the eigenvalues of A
eA = eig(A);
if plotfig > 0
   figure(plotfig);
   plot(real(eA), imag(eA), 'ko')
   hold on
end


smalltol = 1e-10*max(norm(A),epsln);
purespr = max(abs(eA));     % pure spectral radius
if epsln == 0  % pseudospectrum is just the spectrum
   [sortreal, indx] = sort(-abs(eA));
   eA = eA(indx);
   f = purespr;
   
   % return all of the eigenvalues whose magnitudes are equal to spectral
   % radius
   ind = find(abs(eA) >= f - smalltol);
   z = eA(ind);
   
   if (n >= 30)
       waitbar(1,h,'Computing Pseudospectral Radius...(completed)')
   end
   
   if (n >= 30)
       close(h)
   end
else
    if (epsln < 10^-9)
        warning('epsilon is too small, the result may not be accurate enough')
    end   
    
   rold = -0.00001;
   % initially r is spectral-radius
   [r,ind] = max(abs(eA));  % initial iterate
   % theta is the angles of the eigenvalues z, s.t |z| = r
   % one such angle is sufficient, if just the pseudospectral radius
   % is needed, but to return accurate global optimizers, all
   % such angles should be computed.   
   theta = angle(eA(ind));
   thetaold = theta;
   
   thetabest = [];
   

   
   iter = 0;
   no_thetaeig = 0;
   mE = -epsln*eye(n);
   
   % realtol is used to detect zero real parts up to some tolerance.
   realtol = smalltol;
   % radtol is the tolerance determining how far the eigenvalue magnitudes
   % can be apart from unity (Used by the circular search).
   radtol = smalltol;
   

   while ~no_thetaeig & r > rold    % r is increasing in exact arithmetic

      if prtlevel > 0
        fprintf('pspr_2way: r = %22.15e  \n', r);
        fprintf('pspr_2way: theta= %22.15e  \n', theta);
      end
      
      iter = iter + 1;
      
      
      if iter > 20
          if (n >= 30)
            close(h)
          end
         error('pspr_2way: too many steps')
      end
      

      thetabestt = thetabest;
      rold = r;

      % given the resulting directions in theta(computed in the
      % previous iteration except when iter=1), look for the circle with
      % the greatest radius intersecting pseudo-spectrum boundary.
      % note: input theta is a vector, but output r is a scalar: the max
      % of the max values.  thetabest is the corresponding theta value and is
      % a scalar, even if there was a tie e.g. from a complex conjugate pair.
      [r, thetabest] = pspr_2way_rad(A, mE, theta, realtol, plotfig, rold, iter,h);
      
      ptout = sprintf('Computing Pseudospectral Radius...(iteration %d)',iter);
      
      if (n >= 30)
          waitbar((2*(iter-1)+1)/12,h,ptout)
      end

          
      if r > rold
      	% given current r, look for all relevant intersections of the circle
      	% with radius r with the pseudospectrum, process and return pair midpoints.
      	% note: input r is a scalar, but output theta is a vector.
      	% the input thetabest is a scalar.
      	% there is one difference compared to pseudo-absicca case
      	% let theta contains t1 <= t2 <= ...  <= tn
      	% the intervals are circular that is we have to check the midpoints
      	% of [t1,t2], [t2,t3], ..., [tn-1,tn],[tn,t1].
      	% In one of these directions there should be a point on the
      	% boundary with a greater radius compared to current maximum radius
        thetaold = theta;
      	theta = pspr_2way_theta(A, mE, epsln, r, thetabest, iter, radtol, ...
          	 smalltol, plotfig, prtlevel,h);
        if (n >= 30)
            waitbar((2*(iter-1)+2)/12,h)
        end

        if keyb ~= 0
            keyboard
        end
      
      	no_thetaeig = isempty(theta);
        
        if (no_thetaeig)
            rold = r;
        end
            
    else
        thetabest = thetabestt;
        r = rold;
    end % end of else
   end % end of while

   if (n >= 30)
       waitbar(1,h,'Computing Pseudospectral Radius...(completed)')
   end
   
   % print additional information
   if prtlevel > 0
      fprintf('pspr_2way: no_thetaeig = %22.15e   \n', no_thetaeig);
   end   
   if prtlevel > 0
      fprintf('pspr_2way: iter = %22.15e   ', iter);
   end
   
   
   if isempty(thetabest)
        if (n >= 30)
            close(h)
        end
       error('Failed in the first iteration (please choose a bigger epsilon)');
   end
   
   % set f to the eps-pseudospectral radius
   f = r;
   z = r*(cos(thetabest) + i*sin(thetabest));
   
   if isreal(A) & ~isreal(z)
       z = [z; r*(cos(thetabest) - i*sin(thetabest))];
   end
   
    
   
   
   
   if (n >= 30)
       close(h)
   end
end

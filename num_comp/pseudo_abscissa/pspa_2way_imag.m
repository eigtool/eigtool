function [ynew,newimagtol] = pspa_2way_imag(A, E, epsln, x, ywant, iter, imagtol, ...
     plotfig, prtlevel,h)
% James Burke, Adrian Lewis, Emre Mengi and Michael Overton (Last update on September 2 2014)
% called by pspa_2way.m
% Search for intersections between vertical line with given x component
% and the pseudospectrum.  Start by looking for imaginary eigenvalues of
% Hamiltonian matrix; if there are none, return the empty vector for ynew.
% Otherwise, remove any non-extreme imaginary eigenvalues that don't correspond 
% to the smallest singular value.  Then sort the eigenvalues into pairs.
% As do so, ensure that "ywant" (a scalar) is in the eigenvalue list, and if 
% not, add an extra pair above and below ywant (unless the pair containing 
% ywant is already a very short interval, indicating near convergence to a
% maximizer).  The omission must be caused by rounding, and if we overlook 
% this, the process could terminate to a local minimizer of the 
% pseudospectrum instead of a global maximizer (consider minus
% the 5,5 Demmel matrix with epsln = 0.01).
% Finally, return the pair midpoints; there must be at least one.

svd_check = 1;
Areal = isreal(A);
n = length(A);

B = A - x*eye(n);

% compute eigenvalues of the Hamiltonian matrix M = [-B' E;  -E  B];
%  here E = epsln*I
eM = eig([-B'  E;  -E   B]); 

minreal = min(abs(real(eM)));

if (iter == 1) & (minreal > imagtol)
    imagtol = minreal + imagtol;
end

newimagtol = imagtol;

if minreal > imagtol    % check if M has an imaginary eigenvalue
   ynew = [];
else
   indx = find(abs(real(eM)) <= imagtol);  % extract such eigenvalues
   % make sure the imaginary parts correspond to the minimum singular 
   % value, not some other singular value
   y = sort(imag(eM(indx)));  % order them by increasing imaginary part
   

   if svd_check
      indx2 = 1;       % check out the non-extreme imaginary parts
      for check = 2: length(indx)-1   % does nothing if there are only 2
         j = check;
         Ashift = A - (x + i*y(j))*eye(n);
         s = svd(Ashift);
         [minval,minind] = min(abs(s-epsln));
         
         if (minind == n)
            indx2 = [indx2; j];   % accept this eigenvalue
         end
      end
      indx2 = [indx2; length(indx)];  % last one is an extreme one
      removed = length(indx) - length(indx2);
      if removed > 0
        if (prtlevel > 0)
           fprintf('\npspa_2way_imag: singular value test removed %d eigenvalues ', removed)
        end
         y = y(indx2);
      end
   end
   
  
   npairs = length(y)/2;   
   if floor(npairs) ~= npairs
       if (n >= 40)
            close(h)
       end
       
      error('odd number of intersection points are found by the vertical search(please use the version on the web site)')
   end
   
   if (npairs == 0)
       if (n >= 40)
            close(h)
       end
       
       error('all pairs are eliminated by the singular value test(please use the version on the web site)')
   end
   
   
   
   % organize in pairs and take midpoints
   ind = 0;
   for j=1:npairs        % already checked length(y) is even
      ylow = y(2*j-1);
      yhigh = y(2*j);
      % before taking the midpoint, if this interval is not very short,
      % check and see if ywant is in this interval, well away from the
      % end points.  If so, break this pair into two pairs, one above
      % and one below ywant, and take midpoints of both.
      inttol = .01 * (yhigh - ylow);
      if ywant > ylow + inttol & ywant < yhigh - inttol
         ind = ind + 1;
         ynew(ind,1) = (ylow + ywant)/2;
         ind = ind + 1;
         ynew(ind,1) = (ywant + yhigh)/2;
      else
         ind = ind + 1;
         ynew(ind,1) = (ylow + yhigh)/2;
      end
   end
   if plotfig > 0
      figure(plotfig)
      plot([x x], [max(y) min(y)], 'r-')       % plot vertical line
      plot(x*ones(length(y)), y, 'g+')          % plot intersection points   
      plot(x*ones(length(ynew)), ynew, 'bx')   % plot midpoints
   end
   
   
   % if A is real, discard the midpoints in the lower half plane
   if Areal
      indx = find(ynew >= 0);
      ynew = ynew(indx);
   end

end

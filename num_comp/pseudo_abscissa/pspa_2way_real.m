function [xbest, ybest] = pspa_2way_real(A, E, y, imagtol, plotfig, xold,h)
% James Burke, Adrian Lewis, Emre Mengi and Michael Overton (Last update on September 2 2014) 
% called by pspa_2way.m
% For each component in y, search for rightmost intersection between
% horizontal line with given y component and the pseudospectrum.
% For each j, let us define B2 = A - y(j)*i*eye(n).
% There are 2 ways of posing this as an eigenvalue problem:
% the first: look for REAL eigenvalues of    (we DO NOT use this)
%    [ B2' -E       (this is NOT Hamiltonian)   (E = epsln*I)
%     -E   B2];
% the second: look for IMAGINARY eigenvalues of    (we DO use this)
%    [-(i*B2)'  E       =   [i*B2'   E       which IS Hamiltonian
%     -E      i*B2]           -E    i*B2]       (but complex)
% the two matrices are similar, with eigenvalues that are
% symmetric wrt the imaginary axis only.
% The difference: whether or not multiply by i before applying
% largest singular value operation.
% Return the best x value and a corresponding y value.
% Input parameter xold is used only for plotting, if plotfig > 0


n = length(A);
for j=1:length(y)
   B2 = A - y(j)*i*eye(n);

      M2 = [ i*B2' E      
            -E   i*B2];   
      eM2 = eig(M2);   

   if min(abs(real(eM2))) <= imagtol % check if M2 has a real eigenvalue
      indx = find(abs(real(eM2)) <= imagtol);  % extract such eigenvalues
      xnew(j) = max(imag(eM2(indx)));
   else
      xnew(j) = -inf;
      if (n >= 40)
        close(h)
      end
      
      error('error in horizontal search: no intersection points found for one of the midpoints(please use the version on the web site)')
   end
   if plotfig > 0
      figure(plotfig)
      plot([xold xnew(j)], [y(j) y(j)], 'm-')  % plot horizontal line
      plot(xnew(j), y(j), 'b+')       % plot right end point
      
      if isreal(A)
         plot([xold xnew(j)], -[y(j) y(j)], 'm-')  % plot horizontal line
         plot(xnew(j), -y(j), 'b+')    % plot right end point
      end
   end
end
[xbest,ind] = max(xnew);     % furthest to right, returns 1 index
ybest = y(ind);              % corresponding y value
if plotfig > 0
   plot(xbest, ybest, 'b*')
end

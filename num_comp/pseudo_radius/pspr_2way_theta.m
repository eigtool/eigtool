function thetanew = pspr_2way_theta(A, mE, epsln, r, thetawant, iter, radtol, ...
     smalltol, plotfig, prtlevel,h)
% Michael Overton and Emre Mengi (Last Update on September 2 2014)
% called by pspr_2way.m
% Given a radius r, it first computes the intersection points
% of eps-pseudospectrum boundary with the circle with radius r.
% This is achieved by finding the generalized eigenvalues of the 
% matrix pencil F - lambda*G where
%
%       F=[-eps*I A;r*I 0], G=[0 r*I; A' -eps*I]
%
% and then performing a singular value test. The singular value test
% is neccessary to eliminate the points for which eps is a singular
% value but not the smallest one. Finally the midpoints of two
% succesive intersection points on the circle with radius r is
% calculated, i.e. let re^(i*theta_i) and re^(i*theta_(i+1)) be the 
% ith and (i+1)th intersection points, then ith midpoint is 
% re^(i*(theta_i+theta_(i+1))/2). Special attention is paid to
% keep the angles in the interval [-pi,pi). Furthermore, as it
% was the case for pseudo-absicca code, we specifically considered
% the case when the angle from the previous iteration is contained
% in one of the intervals. At the exit thetanew contains the 
% angles of the midpoints.


n = length(A);

% compute the generalized eigenvalues of the matrix pencil F - lambda*G
R = r * eye(n);
O = 0 * eye(n);
F = [mE A; R O];
G = [O R; A' mE];
eM = eig(F,G);

% extract the eigenvalues with magnitude 1
% a small tolerance is used
ind = find((abs(eM) < (1 + radtol)) & (abs(eM) > (1 - radtol)));
eM = eM(ind);

       
if (isempty(eM)) % check if M has an eigenvalue with magnitude 1
   thetanew = []; 
else

   % sort eM wrt theta values
   [theta, indx] = sort(angle(eM));
   theta = angle(eM(indx));
          
         
   
  
   % perform singular value test on the points probably on
   % eps-pseudospectrum boundary.
   % the ones actually on the eps-pseudospectrum are those with smallest 
   % singular value equal to eps
   indx2 = [];
   for j = 1: length(theta)
	   if (theta(j) < 0)
			theta(j) = theta(j) + 2*pi;
	   end

       Ashift = A - (r*(cos(theta(j)) + i*sin(theta(j))))*eye(n);
       s = svd(Ashift);
       [minval,minind] = min(abs(s-epsln));
       
       if minind == n
           indx2 = [indx2; j];   % accept this eigenvalue
       end
   end
      
   removed = length(theta) - length(indx2);
   
   if removed > 0
       if prtlevel > 0
           fprintf('\npspr_2way_theta: singular value test removed %d eigenvalues ', removed)
       end
       theta = theta(indx2);
   end
   
   
   if (isempty(theta))
        if (n >= 30)
            close(h)
        end
       error('singular value test removed all of the intersection points(please try smaller epsilon)')
   end


   theta = sort(theta);
   
          
   % organize in pairs and take midpoints
   thetanew = [];
   ind = 0;

   % shift thetawant, the angle from the previous iteration, into 
   % the interval [0,2pi]
   if (thetawant < 0)
       thetawant = thetawant + 2*pi;
   end

   
   for j=1:length(theta)     
      thetalow = theta(j);


      if (j < length(theta))
          thetahigh = theta(j+1);
      else
		  % the last interval wraps around
          thetahigh = theta(1) + 2*pi;
      end

      
      
	
          
      % before taking the midpoint, if this interval is not very short,
      % check and see if thetawant is in this interval, well away from the
      % end points.  If so, break this pair into two pairs, one above
      % and one below thetawant, and take midpoints of both.
      inttol = .01 * (thetahigh - thetalow);

	  % this is needed for the last interval
	  if (thetawant+2*pi > thetalow + inttol & ...
		  thetawant+2*pi < thetahigh - inttol)
		  thetawantt = thetawant + 2*pi;
	  else
		  thetawantt = thetawant;
	  end



      if thetawantt > thetalow + inttol & ...
                thetawantt < thetahigh - inttol
         
         % lower midpoint
		 thetamid = (thetalow + thetawantt)/2;
         
         
		 % shift thetamid into the interval [-pi,pi] again
		 if (thetamid >= 2*pi)             
			thetamid = thetamid - 2*pi;
		 end         
		 if (thetamid >= pi)
			thetamid = thetamid - 2*pi;
		 end

		 % remove the midpoint if the minimum singular value is greater than
		 % epsilon, since in this case the midpoint should lie outside the
		 % epsilon-pseudospectrum.
		if (min(svd(A-r*exp(i*thetamid)*eye(n))) <= epsln)
			ind = ind + 1;
			thetanew(ind,1) = thetamid;
		end

         
         
         
         % upper midpoint
         thetamid = (thetawantt + thetahigh)/2;

         
         % shift thetanew(ind) into the interval [-pi,pi] again
		 if (thetamid >= 2*pi)
			thetamid = thetamid - 2*pi;
		 end
		 if (thetamid >= pi)
			thetamid = thetamid - 2*pi;
		 end


		 % remove the midpoint if the minimum singular value is greater than
		 % epsilon, since in this case the midpoint should lie outside the
		 % epsilon-pseudospectrum.
		 if (min(svd(A-r*exp(i*thetamid)*eye(n))) <= epsln)
			ind = ind + 1;
			thetanew(ind,1) = thetamid;
		 end

     else
         % otherwise, if thetawant is not in the interval
         % take the midpoint of thetalow and thetahigh
         thetamid = (thetalow + thetahigh)/2;    
         
		 % shift thetanew(ind) into the interval [-pi,pi] again
		 if (thetamid >= 2*pi)
			thetamid = thetamid - 2*pi;
		 end
		 if (thetamid >= pi)
			thetamid = thetamid - 2*pi;
		 end

		 % remove the midpoint if the minimum singular value is greater than
		 % epsilon, since in this case the midpoint should lie outside the
		 % epsilon-pseudospectrum.
		 if (min(svd(A-r*exp(i*thetamid)*eye(n))) <= epsln)
			ind = ind + 1;
			thetanew(ind,1) = thetamid;
		 end

                  
      end
   end
   
   
   
   
   if plotfig > 0
      % plot the circle with radius r
      plotcircle(r,plotfig);
      figure(plotfig);
      
      % plot the intersection points of the circle(with radius r) 
      % and the pseudo-spectrum
      pointsoncircle = r * (cos(theta) + i*sin(theta));
      plot(real(pointsoncircle), imag(pointsoncircle), 'g+')
      
  end
   
  % if A is real, discard the midpoints in the lower half plane
  if isreal(A)
     indx = find(thetanew >= 0 | thetanew == -pi);
     ynew = thetanew(indx);
  end

   
end

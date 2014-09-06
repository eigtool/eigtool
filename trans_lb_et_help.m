%   Selecting this option will plot a lower bound for the
%   transient growth onto the transient plot. After selecting
%   'Compute', you will be asked to click on a point in the
%   complex plane to base the bound upon; the bound is then
%   computed as follows [1], where R is the resolvent norm at the 
%   selected point z. The bound will be computed over the values
%   of k (or t) currently visable on the transient plot
%   
%   For matrix powers:
%   
%           max_{1<=k<=K}||A^k||} >= r^K/(1+(r^K-1)/((r-1)*(rR-1)))
%              (only valid for |z| = r > 1).
%   
%   For matrix exponentials:
%   
%           sup_{0<=t<=T}||exp(t*A)||} >= exp(a*T)/(1+(exp(a*T)-1)/(aR))
%              (only valid for Re(z) = a > 0).
%   
%   The bound appears as a green curve on the transient plot
%   (with the selected point highlighted on the pseudospectra
%   plot). For any particular point on this curve at step K (or
%   time T), the bound says that the transient growth must have 
%   been at least this large for some point k < K (or t < T).
%   
%   The 'Best estimate lower bound' is computed by taking
%   the best bound over all of the points used in the 
%   pseudospectra computation. In other words, using a 
%   finer grid and/or zooming in should give a better 
%   'best estimate' lower bound.
%
%   [1]: L. N. Trefethen, 2002, unpublished note

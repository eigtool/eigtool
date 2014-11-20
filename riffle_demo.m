function [A,P] = riffle_demo(n)

%   [A,P] = RIFFLE_DEMO(N) returns matrices A and P of dimension N.
%
%   The matrix P describes the Markov chain involved in riffle shuffling
%   of a deck of cards according to a model proposed by Gilbert, Shannon
%   and Reeds, and made famous by Diaconis and coauthors [1].  For a deck of
%   n cards, the state space is the set of all permutations, of dimension
%   factorial(n).  Fortunately, as shown by Bayer and Diaconis, an
%   equivalent chain can be constructed on a state space of dimension just
%   n, the number of "rising sequences" in the deck.  Formulas for
%   the entries of this n x n matrix P are essentially contained in [1]
%   and have been worked out explicitly by Gessel and Jonsson and Trefethen
%   [2]. 
%
%   Riffle shuffle is a famous example of a linear process with a strong
%   transient effect.  Powers of P govern the approach to randomness, but
%   there is virtually no randomization at first followed by sudden
%   randomization later (asymptotically at the shuffle 1.5 log_2(n)).  Following
%   standard conventions in Markov chains, this code produces a matrix P
%   designed to act on row vectors on the left.  To see the transient effect
%   with the limiting case P^inf subtracted off, look at the matrix A = P-Pinf
%   and its powers.  The probabilistically correct norm in which to analyze
%   powers and pseudospectra is the 1-norm for the matrices as operating on
%   rows, which is the inf-norm according to standard Matlab conventions.
%   Thus pseudospectra, in particular, should in principle be examined in
%   the Matlab inf-norm, not the 2-norm utilized by EIGTOOL.  Jonsson and
%   Trefethen found that these norms make little difference to the pseudospectra
%   (though the difference would be huge if one were working with the
%   underlying matrices of dimension n! rather than n).
%   
%   [1]: D. Bayer and P. Diaconis, "Trailing the dovetail shuffle to its lair",  
%        Annals Appl. Probab. 2, 1992, 294-313.
%   
%   [2]: G. F. Jonsson and L. N. Trefethen, "A numerical analysis looks at the
%        `cut-off phenomenon' in card shuffling and other Markov chains", in 
%        "Numerical Analysis 1997" (Dundee 1997), Addison Wesley Longman, 
%         Harlow, 1998, 150-178.

% Version 2.4.1 (Wed Nov 19 21:54:20 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

% Logarithms of Eulerian numbers:
  a = zeros(1,n); anew = zeros(1,n);
  for j = 2:n
    anew(2:j-1) = log((2:j-1).*exp(a(2:j-1)-a(1:j-2))+(j-1:-1:2))+a(1:j-2);
    a = anew;
  end

% Logarithms of binomial coefficients:
  b = zeros(1,n+2); bnew = zeros(1,n+2);
  for j = 2:n+2
    bnew(2:j-1) = log(exp(b(2:j-1)-b(1:j-2))+1)+b(1:j-2);
    b = bnew;
  end

% Transition matrix P:
  b = b-n*log(2);
  r = [b(1) -Inf*ones(1,n-1)];
  c = [b -Inf*ones(1,n-2)]';
  T = toeplitz(c,r);
  P = T(2:2:2*n,:);
  P = exp(P-a'*ones(1,n)+ones(n,1)*a);

% Stationary distribution and decay matrix A:
  v = eye(1,n); vnew = eye(1,n);
  for j = 2:n
    vnew(1) = v(1);
    vnew(2:j) = (2:j).*v(2:j)+(j-1:-1:1).*v(1:j-1);
    v = vnew/j;
  end
  Pinf = ones(n,1)*v;
  A = P - Pinf;

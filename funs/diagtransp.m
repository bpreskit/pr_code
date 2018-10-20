function B = diagtransp(A)

  assert(issquare(A), 'A is not square');
  N = size(A, 1);
  B = zeros(size(A));
  for i = 1 : N
    B(:, i) = circdiag(A, i-1);
  end    

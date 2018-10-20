function P = interleave(d, N)
  % function P = interleave(d, N)
  % Gives a (dN x dN) permutation matrix that transforms N blocks of size d
  % into d blocks of size N.
  
  P = sparse(d*N, d*N);

  i = (1 : (d * N))';
  j = mod(i - 1, N) * d + floor((i - 1) / N) + 1;
  inds = sub2ind([d*N, d*N], i, j);
  P(inds) = 1;  

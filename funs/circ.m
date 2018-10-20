function C = circ(x, N, k)
  %% function C = circ(x, N, k)
  %% Returns [x, S^N x, ... , S^(N(k - 1)) x],
  %% otherwise known as circ_k^N(x)
  
  [n, m] = size(x);
  
  if ~exist('N')
    N = 1;
  end
  if mod(n / N, 1) ~= 0
    warning('circ: n / N not an integer');
  end
  if ~exist('k')
    k = floor(n / N);
  end

  C = zeros(n, k * m);
  for i = 1 : k
    C(:, (i - 1) * m + 1 : i * m) = circshift(x, N * (i - 1));
  end

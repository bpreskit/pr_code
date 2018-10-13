function tau = taug(d, delta, s)
  % tau = taug(d, delta, s)
  %
  % Calculates the spectral gap of the graph associated with
  % T_{\delta, s}(\Cdxd).

  % Enforce defaults, get parameters
  if ~exist('s')
    s = 1;
  end
  dbar = d / s;
  assert(dbar == floor(dbar), 's must divide d!');

  % Form the 
  T = zeros(d);
  for l = 1 : dbar
    inds = mod((1 : delta) + (l-1) * s - 1, d) + 1;
    T(inds, inds) = 1;
  end
  T = T - diag(diag(T));

  % Form an operator that goes onto orthogonal complement
  % of null space (i.e. \one^\perp)
  if mod(d, 2)
    inds = 2:(1 + (d-1)/2);
    P = sqrt(2/d) * real(dftmtx(d)')(:, inds);
    P = [P, sqrt(2/d) * imag(dftmtx(d)')(:, inds)];
  else
    inds = 2 : (d / 2);
    P = sqrt(2/d) * real(dftmtx(d)')(:, inds);
    P = [P, sqrt(2/d) * imag(dftmtx(d)')(:, inds)];
    P = [P, dftmtx(d)'(:, inds(end)+1) / sqrt(d)];
  end

  % make the laplacian and mind the gap!
  L = diag(T * ones(d, 1)) - T;
  L = P' * L * P;
  tau = abs(eigs(L, 1, 'sm'));

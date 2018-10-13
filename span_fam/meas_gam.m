function y = meas_gam(meas_sys, X)
  % y = meas_gam(gam, X, d, delta)
  %
  % meas_sys is a struct containing:
  % d     : Ambient dimension
  % delta : support size
  % gam   : mask
  % K     : modulation index (defaults to 2 * delta - 1)
  % 
  % Applies the local Fourier measurement system to the matrix X
  % Returns a d x D matrix of measurements y

  % Unpack meas_sys
  d = meas_sys.d;
  delta = meas_sys.delta;
  D = 2 * delta - 1;
  gam = meas_sys.gam(1 : delta)(:);
  if ~isfield(meas_sys, 'K')
    K = D;
  end

  FK = conj(dftmtx(K)(1 : delta, 1 : D));
  gg = gam * gam';
  XX = repmat(X, [2, 2]);

  for j = 1 : D
    mat = FK(:, j)' .* gg .* FK(:, j);
    for l = 0 : d - 1
      y(l + 1, j) = sum((mat .* XX((1 : delta) + l, (1 : delta) + l))(:));
    end
  end

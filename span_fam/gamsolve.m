function X = gamsolve(meas_sys, y, fft_mode)
  % X = gamsolve(meas_sys, y, fft_mode)
  %
  % meas_sys is a struct with the following fields
  %
  % d    : ambient dimension
  % delta: support size
  % gam  : mask
  % K    : modulation index (defaults to 2 delta - 1)
  % 
  % Returns an estimate of A \ y, where A is the measurement matrix for
  % T_\delta(C^{d \times d}), and the local Fourier measurement system
  % with mask gam.  y \in \R^{d \times D} or \R^{dD}
  %
  % fft_mode says if you solve diagonal by diagonal or by doing the
  % fft's.

  % Unpack the meas_sys
  d = meas_sys.d;
  delta = meas_sys.delta;
  D = 2 * delta - 1;
  gam = meas_sys.gam(1 : delta)(:);
  if ~isfield(meas_sys, 'K')
    meas_sys.K = D;
  end
  assert(meas_sys.K >= D, "K < D@!!");
  K = meas_sys.K;
  if ~exist('fft_mode')
    fft_mode = 1;
  end

  % Make the interleave operator.
  P = interleave(D, d);
  
  % Initialize some things, and get cracking!
  chi = zeros(d, D);
  Fd = dftmtx(d)' / sqrt(d);
  FK = dftmtx(K)(1 : D, 1 : D)' / sqrt(K);
  FKd1 = FK(:, delta + 1) * sqrt(K);
  FKt = FKd1 .* FK;
  m1 = 1 - delta;
  m2 = delta - 1;

  % Build the matrices at the center of A's circulant structure.
  gg = sparse(d, d);
  gg(1 : delta, 1 : delta) = gam * gam';
  g = tdelt2diag(gg, delta);
  Z = sqrt(d * D) * g' * Fd;

  % If we're doing the non-fft mode...
  if ~fft_mode
    % Solve diagonal by diagonal
    y = reshape(y, d, D);
    for m = m1 : m2
      mm = m - m1 + 1;
      chi(:, mm) = Fd ./ Z(mm, :) * Fd' * y * FK(:, 1 + mod(-m, D));
    end

    X = chi;
  end

  if fft_mode
    % Solve diagonal by diagonal
    y = reshape(y, d, D);
    for m = m1 : m2
      mm = m - m1 + 1;
      chi(:, mm) = ifft(fft(y * FK(:, 1 + mod(-m, D))) ./ (Z(mm, :).'));
    end

    X = chi;
  end

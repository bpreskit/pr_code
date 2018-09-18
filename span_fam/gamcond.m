function kappa = gamcond(gam, d, delta)
  % kappa = gamcond(gam, d, delta)
  % This calculates the actual condition number of the local Fourier
  % measurement system in \C^d with mask \gamma and support delta.

  % gam = [gam(1 : delta); zeros(d - delta, 1)];
  % Fd = dftmtx(d);
  % modmat = Fd(:, 2).^(0 : delta - 1);
  % H = circ(fft(gam)) * (fft(gam) .* modmat) / d;
  % kappa = max(abs(H(:))) / min(abs(H(:)));

  gam = gam(1 : delta)';
  F = dftmtx(d)(1 : ceil(d / 2) + 1, 1 : delta);
  nGam = norm(gam)^2;

  for m = 0 : delta - 1
    g = gam(1 : (delta - m)) .* gam(m + 1 : delta);
    g = [g(:); zeros(m, 1)];
    fg(:, m + 1) = abs(F * g);
  end

  kappa = nGam / min(abs(fg(:)));
end


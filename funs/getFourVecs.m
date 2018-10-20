function [vecs, base_vecs, base_kron_vecs] = getFourVecs(n, delta, four_len, gam)
  %% function [vecs, base_vecs, base_kron_vecs] = getFourVecs(n, delta, four_len, gam)

  if ~exist('delta')
    delta = n;
  end

  if ~exist('four_len')
    four_len = 2 * delta - 1;
  end

  if ~exist('gam')
    a = 4;
    c1 = 1 / nthroot(four_len, 4);
    gam = c1 * exp(-(1 : delta)' / a);
  end

  vecs = zeros(n);
  fourier = dftmtx(four_len) / sqrt(four_len);
  if four_len < n
    fourier = [fourier; zeros(n - four_len, four_len)];
  elseif four_len > n
    fourier = fourier(1 : n, :);
  end

  if length(gam) < n
    gam(n) = 0;
  elseif length(gam) > n
    gam = gam(1 : n);
  end

  assert(all(gam(delta + 1 : end) == 0), 'gamma is not delta supported');

  base_vecs = gam .* fourier;
  base_kron_vecs = zeros(n^2, four_len);

  for i = 1 : four_len
    base_kron_vecs(:, i) = kron(conj(base_vecs(:, i)), base_vecs(:, i));
  end

  kron_shift = kron(circshift(speye(n), 1), circshift(speye(n), 1));
  kron_vecs = base_kron_vecs;
  vecs = zeros(n^2, four_len * n);

  for i = 1 : n
    vecs(:, (1 + four_len * (i - 1)) : (four_len * i)) = kron_vecs;
    if i < n
      kron_vecs = kron_shift * kron_vecs;
    end
  end

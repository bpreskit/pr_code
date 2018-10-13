function kappa = arbcond(masks, d, delta)
  % kappa = arbcond(masks, d)
  % Calculates the actual condition number of the local
  % measurement system in \C^d with support delta with
  % m_j = masks(:, j), where size(masks) = (delta, D) (D = # of masks).

  % Extract some info, initialize some stuff
  D = size(masks, 2);
  % d2 = ceil(d / 2) + 1;
  assert(D == min(2 * delta - 1, d));
  Fd = dftmtx(d)' /  sqrt(d);
  gg = zeros(delta, D, D);

  % Set the diagonals you're going to use
  if D == 2 * delta - 1
    ms = 1 - delta : delta - 1;
  else
    ms = 0 : d;
  end

  % Size things properly
  masks = [masks; zeros(d - size(masks, 1), D)];
  cmasks = conj(masks);
  gg = zeros(d, d, D);
  g = zeros(d, D, D);
  M = zeros(D, D, d);
  H = zeros(d * D, D);

  % Set up the block-diagonal things...
  for m = 1 - delta : delta - 1
    g(:, m + delta, :) = masks .* (conj(circshift(masks, -m)));
  end
  %% for l = 1 : D
  %%   gg(:, :, l) = masks(:, l) * masks(:, l)';
  %%   g(:, :, l) = tdelt2diag(gg(:, :, l), delta);
  %% end
  for i = 1 : D
    H((i-1)*d + 1 : i*d, :) = g(:, :, i);
  end
  for j = 1 : d
    M(:, :, j) = kron(eye(D), Fd(:, j))' * H * sqrt(d);
  end
  M = conj(M);
  % ...calculate the pertinent singular values...
  for j = 1 : d
    smx(j) = abs(sqrt(eigs(M(:, :, j) * M(:, :, j)', 1, 'lm')));
    smn(j) = abs(sqrt(eigs(M(:, :, j) * M(:, :, j)', 1, 'sm')));
  end
  % ...Done!
  kappa = max(smx) / min(smn);

function kappa = arbcond(masks, d)
  % kappa = arbcond(masks, d)
  % Calculates the actual condition number of the local
  % measurement system in \C^d with support delta with
  % m_j = masks(:, j), where size(masks) = (delta, D) (D = # of masks).

  delta = size(masks, 1);
  D = size(masks, 2);
  d2 = ceil(d / 2) + 1;
  assert(D == min(2 * delta - 1, d));
  F = dftmtx(d)(:, 1 : delta);
  gg = zeros(delta, D, D);

  if D == 2 * delta - 1
    ms = 1 - delta : delta - 1;
  else
    ms = 0 : d;
  end

  masks = [masks; zeros(d - delta, D)];
  cmasks = conj(masks);

  for l = 1 : D
    m = ms(l);
    g = masks .* circshift(cmasks, m);
    g = g(1 : delta, :);

    for i = 1 : D
      gg(:, m, i) = g(:, i);
    end
  end

  Fg = reshape(F * gg, d2, delta, D);
  
  
  

function masks = gammasks(gam, delta, K)
  % masks = gammasks(gam, delta)
  % Makes 'masks' by taking \gam \circ f_j^K for j \in [2 \delta - 1].
  % Then size(masks) = (delta, D)

  % Enforce defaults.
  if ~exist('delta')
    delta = numel(gam);
  end
  assert(numel(gam) >= delta);
  gam = gam(1 : delta)(:);
  D = 2 * delta - 1;
  if ~exist('K')
    K = D;
  end

  % Dew it
  FK = (dftmtx(K) / sqrt(K))(1 : delta, 1 : D);
  masks = gam .* FK;

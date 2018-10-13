function masks = sparsemasks(d, delta)
  % masks = sparsemasks(d, delta)
  %
  % Eh.  Just comes up with the sparse construction
  % for d and delta.

  masks = zeros(delta, 2 * delta - 1);
  masks(1, 1) = 1;
  for i = 1 : delta - 1
    masks(1, 2 * i) = 1;
    masks(i + 1, 2 * i) = 1;
    masks(1, 2 * i + 1) = 1;
    masks(i + 1, 2 * i + 1) = sqrt(-1);
  end

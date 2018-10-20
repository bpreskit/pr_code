function Rv = reverse(v)
  %% function Rv = reverse(v)
  %% 
  %% (Rv)_i = v_{2 - i}, with indices mod d for v \in \C^d

  d = size(v, 1);
  if d > 1
    inds = [1, d : -1 : 2];
    Rv = v(inds, :);
  else
    Rv = reverse(speye(v));
  end

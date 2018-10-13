function X = tdelt2diag(Tdx, delta, s)
  % X = tdelt2diag(Tdx, delta, s)
  %
  % Tdx \in \C^(d \times d).  This pulls out the diagonals
  % 1 - delta, ..., delta - 1 and makes them the columns of X
  % (so X \in \C^(d x 2 delta - 1)

  if ~exist('s')
    s = 1;
  end

  % Get size, check squareness
  d = size(Tdx, 1);
  assert(size(Tdx, 2) == d, 'Tdx must be square');

  % Set up some indices...
  m1 = 1 - delta;
  m2 = delta - 1;
  X = zeros(d, 2 * delta - 1);

  % Pull the diagonals!
  for m = m1 : m2
    X(:, m - m1 + 1) = circdiag(Tdx, m);
  end

  if s == 1
    return
  else
    dbar = d / s;
    assert(dbar == floor(dbar), 's should divide d!');
    inds = 0;
    for m = 1-delta : delta - 1
      width = min(delta - abs(m), s);
      inds = inds(end) + 1 : inds(end) + width * dbar;
      if width == s
	Y(inds) = X(:, m+delta);
      elseif m < 0
	ninds = (mod((abs(m) + 1 : delta) - 1, s) + 1)';
	Y(inds) = kron(speye(dbar), speye(s)(:, ninds))' * X(:, m+delta);
      else
	ninds = (mod((1 : delta - m) - 1, s) + 1)';
	Y(inds) = kron(speye(dbar), speye(s)(:, ninds))' * X(:, m+delta);
      end
    end
    X = Y;
    return
  end

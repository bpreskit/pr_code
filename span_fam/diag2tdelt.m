function Tdx = diag2tdelt(X, d, delta, s)
  % Tdx = diag2tdelt(X, d, delta, s)
  %
  % Build T_delta from the diags, which are columns (or segments)
  % of X.  d, delta are optional; preferable to hand over
  % X \in \C^(d \times D)

  if exist('s')
    if s > 1
      dbar = d / s;
      assert(dbar == floor(dbar), 's should divide d!');
      alpha = s * (2 * delta - s);
      assert(numel(X) == dbar * alpha);
      X = X(:);
      Y = zeros(d, 2 * delta - 1);
      inds = 0;
      for m = 1-delta : delta - 1
	width = min(delta - abs(m), s);
	inds = inds(end) + 1 : inds(end) + width * dbar;
	if width == s
	  Y(:, m+delta) = X(inds);
	elseif m < 0
	  ninds = (mod((abs(m) + 1 : delta) - 1, s) + 1)';
	  Y(:, m+delta) = kron(speye(dbar), speye(s)(:, ninds)) * X(inds);
	else
	  ninds = (mod((1 : delta - m) - 1, s) + 1)';
	  Y(:, m+delta) = kron(speye(dbar), speye(s)(:, ninds)) * X(inds);
	end
      end
      X = Y;
    else
      X = reshape(X, [d, 2 * delta - 1]);
    end
  end

  if or(~exist('d'), ~exist('delta'))
    d = size(X, 1);
    D = size(X, 2);
  else
    D = 2 * delta - 1;
  end

  if not(all(size(X) == [d, D]))
    X = reshape(X, d, D);
  end

  m1 = 1 - delta;
  m2 = delta - 1;
  i = 1 : d;
  Tdx = sparse(d, d);

  for m = m1 : m2
    j = mod((1 : d) + m - 1, d) + 1;
    inds = sub2ind([d, d], i, j);
    Tdx(inds) = X(:, m - m1 + 1);
  end   

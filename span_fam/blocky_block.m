function [x, vecs, mu] = blocky_block(X, Ji, G)
  % [x, vecs, mu] = blocky_block(X, Ji, G)
  %
  % Returns an estimate of x, or the magnitudes of x, according to the
  % blockwise magnitude/vector estimation algorithm described in Sec 6.3
  % of my dissertation.
  %
  % X is an approximation of T_delta(x x^*), from which the estimate is to be
  %   drawn.
  % Ji is the (T_delta, d)-covering, specified either as an integer or a cell
  %   of matrices with indices.  If omitted, Ji = 1, and we read mag's off the
  %   diagonal.
  % G is the graph for a connected (T_delta, d)-covering in the case of
  %   vector synchronization, which is performed only when G is included.
  %   If G = [], we take E = {(i, Ji) : intersect(J_i, J_j) not empty}

  % Sort through some defaults
  if ~exist('Ji')
    x = sqrt(abs(diag(X)));
    vecs = diag(x);
    return;
  end
  if ~exist('G')
    G = -1;
  end
  if (length(G) == 1) && (G == -1)
    X = abs(X);
  end

  % Get size of X and assert squareness
  d = size(X, 1);
  assert(size(X, 2) == d, 'X must be square');

  % If you are specifying consistently-sized blocks...
  if ~iscell(Ji)
    % Either do BlockMag(X, m) on T_m
    if numel(Ji) == 1
      assert((Ji == floor(Ji)) && (0 < Ji) && (Ji <= d));
      m = Ji;
      vecs = zeros(d);
      mu = ones(d, 1) * m;
      for l = 0 : d-1
	curJi = mod(((1 : m) + l - 1), d) + 1;
	X_Ji = X(curJi, curJi);
	[x_Ji, lam] = eigs(X_Ji, 1);
	x_Ji = x_Ji / norm(x_Ji) * sqrt(lam);
	x_Ji = x_Ji * sign(x_Ji(1));
	vecs(curJi, l+1) = x_Ji;
      end
    % Or BlockMag(X, m) on T_{m, s} for ptychography with shift s
    else
      assert(numel(Ji) == 2, 'invalid Ji');
      m = Ji(1);
      s = Ji(2);
      mu = zeros(d, 1);
      dbar = d / s;
      assert(dbar == floor(dbar), 'in ptych, s should divide d!');
      vecs = zeros(d, dbar);
      for l = 0 : dbar-1
	curJi = mod(((1 : m) + s * l - 1), d) + 1;
	mu(curJi) += 1;
	X_Ji = X(curJi, curJi);
	[x_Ji, lam] = eigs(X_Ji, 1);
	x_Ji = x_Ji / norm(x_Ji) * sqrt(lam);
	x_Ji = x_Ji * sign(x_Ji(1));
	vecs(curJi, l+1) = x_Ji;
      end      
    end
  else
    N = numel(Ji);
    vecs = zeros(d, N);
    mu = zeros(d, 1);
    for i = 1 : N
      curJi = mod(Ji{i} - 1, d) + 1;
      mu(curJi) += 1;
      X_Ji = X(curJi, curJi);
      [x_Ji, lam] = eigs(X_Ji, 1);
      x_Ji = x_Ji / norm(x_Ji) * sqrt(lam);
      x_Ji = x_Ji * sign(x_Ji(1));
      vecs(curJi, i) = x_Ji;
    end
  end

  if (length(G) == 1) && (G == -1)
    x = sum(vecs, 2) ./ mu;
    return;
  else
    V = vecs' * vecs;
    if ~isempty(G)
      G = double(logical(G));
      G = G - diag(diag(G));
      V = V .* G;
    end
    data.X = V;
    data.method = 'eig';
    omega = angsync(data);
    x = vecs * omega ./ mu;
    return;
  end

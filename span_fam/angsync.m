function [tx, hz] = angsync(data)
  % function hz = angsync(data)
  %
  % 'data' should be a struct containing the fields:
  %     X -- X in \Cdxd is a matrix of relative phases along the
  %       edges of a graph.
  %     W (optional) -- W is a weighted adjacency matrix for a graph to be
  %       used for the angular synchronization
  %     method (optional) -- string, either 'eig' or 'sdp', specifying
  %     whether to use the SDP or the leading eigenvector method.
  %     
  % This function formulates and performs the angular synchronization problem
  % for the given data.  If W is not given, we assume it is built into the
  % magnitudes of the entries of X.  'method' defaults to 'eig'.

  % Set default
  if ~isfield(data, 'method')
    method = 'eig';
  else
    method = data.method;
  end

  if isfield(data, 'W')
    X = data.X;
    W = data.W;

    % Hermitify X and W, just to be safe.  Make sure W is an adjacency matrix.
    X = sign((X + X') / 2);
    W = (W + W') / 2;
    if !all(diag(W) == zeros(d, 1))
      W = W - diag(diag(W));
    end

    % Set up the Laplacian
    d = size(W, 1);
    assert(all(size(X) == d), 'X and W should be square, same shape.');
    assert(all(W(:) >= 0) & all(isreal(W(:))), 'W should be nonneg real.');
    D = diag(W * ones(d, 1));
    L = D - X .* W;
  else
    assert(isfield(data, 'X'), 'data doesnt even have X!');
    X = data.X;
    d = size(X, 1);
    assert(all(size(X) == d), 'X should be square.');
    X = (X + X') / 2;
    if !all(diag(X) == zeros(d, 1))
      X = X - diag(diag(X));
    end

    D = diag(abs(X) * ones(d, 1));
    L = D - X;
  end

  if strcmp(method, 'sdp')
    c = vec(realify(L, 0));
    b = [ones(2 * d, 1); zeros(d, 1)];
    A = sparse([1:2*d]', [(1 : 2*d) * (2*d + 1) - 2*d]', ones(2*d, 1));
    A = [A; sparse((1:d)', ...
		   [(1:2:2*d-1) * (2*d + 1) - 2*d + 1]', ones(d, 1), ...
		   d, 4*d^2)];
    K = struct();
    K.s = [2*d];
    pars = struct();
    pars.fid = 0;

    [hz, y, info] = sedumi(A, b, c, K, pars);
    [tx, ~] = eigs(complexify(reshape(hz, [2*d, 2*d])), 1);
    tx = sign(tx);
  elseif strcmp(method, 'sdpcpx')
    b = ones(d, 1);
    c = vec(L);
    At = sparse([(1 : d) * (d + 1) - d]', [1:d]', ones(d, 1));
    K = struct();
    K.s = [d];
    K.scomplex = 1;
    K.xcomplex = 1 : d^2;

    [hz, y, info] = sedumi(At, b, c, K);
    [tx, ~] = eigs(reshape(hz, [d, d]), 1);
    tx = sign(tx);
  elseif strcmp(method, 'tree')
    X = sign(X);

    adj = cell();
    verts = (1 : d)';
    deg = zeros(d, 1);
    for i = 1 : d
      adj{i} = verts(logical(X(:, i)));
      deg(i) = numel(adj{i});
    end
    
    tx = zeros(d, 1);
    if !isfield(data, 'root')
      r = randi(d);
    else
      r = data.root;
    end
    tx(r) = 1;
    q = javaObject('java.util.LinkedList');
    q.add(r);
    while q.peek()
      u = q.remove();
      for i = 1 : deg(u)
	v = adj{u}(i);
	if !tx(v)
	  tx(v) = tx(u) * X(v, u);
	  q.add(v);
	end
      end
    end
    hz = tx;
  elseif strcmp(method, 'randtree')
    [~,~,tx] = randtree(X, 1);
    hz = tx;
  else
    [hz, ~] = eigs(L, 1, 'sm');
    tx = sign(hz);
    return
  end

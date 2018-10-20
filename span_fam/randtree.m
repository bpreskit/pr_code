function [T, Tp, tx] = randtree(A, phs)
  % T = randtree(A)
  %
  % The sparsity structure of A should be the adjacency matrix for a
  % connected graph.  Returns T = A o T', where T' is a random spanning
  % tree, sampled uniformly from the set of spanning trees, of this graph.
  %
  % If 'phs', also return 'tx', the vector of phases gotten by propagating
  % edge phases along the tree.
  %
  % Algorithm from:
  % Wilson, David B.  "Generating Random Spanning Trees More Quickly than
  %   the Cover Time."  1996.  Proc. 28th Annual ACM Symposium on Theory of
  %   Computing.  Philadelphia, PA.  pp. 296-303.

  if !exist('phs')
    phs = 0;
  end
    
  B = A;
  A = logical(A);
  assert(issymmetric(A), 'A must be symmetric!');
  A = A - diag(diag(A));
  A = logical(A);
  n = size(A, 1);

  adj = cell();
  deg = zeros(n, 1);
  verts = (1 : n)';
  for i = 1 : n
    adj{i} = verts(A(:, i));
    deg(i) = numel(adj{i});
  end

  r = randi(n);
  intree = logical(zeros(n, 1));
  tx = zeros(n, 1);
  br = zeros(n, 1);
  intree(r) = 1;
  tx(r) = 1;
  next = zeros(n, 1);
  next(r) = -1;
  T = sparse(n, n);

  for i = 1 : n
    u = i;
    while ~intree(u)
      next(u) = adj{u}(randi(deg(u)));
      u = next(u);
    end
    u = i;
    if !phs
      while ~intree(u)
	intree(u) = 1;
	T(u, next(u)) = 1;
	T(next(u), u) = 1;
	u = next(u);
      end
    else
      bl = 0;
      while ~intree(u)
	intree(u) = 1;
	T(u, next(u)) = 1;
	T(next(u), u) = 1;		
	bl++;
	br(bl) = u;
	u = next(u);
      end
      br(bl+1) = u;
      for j = bl + 1 : -1 : 2
	tx(br(j-1)) = tx(br(j)) * sign(B(br(j-1), br(j)));
      end
    end
  end

  if !phs
    tx = intree;
  end

  Tp = T;
  T = Tp .* B;

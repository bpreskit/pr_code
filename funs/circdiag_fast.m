function d = circdiag_fast(A, m, vis)
  % d = circdiag(A, m, vis)
  % Retrieves the mth circulantly-determined diagonal from A
  % If vis is True, begin this diagonal at 1st column for negative m.
  % Otherwise, always start at first row.

  % Default vis to 0
  if ~exist('vis')
    vis = 0;
  end

  % Pull size
  N = size(A, 1);

  % If getting main diagonal, coincide with default behavior.
  if m == 0
    d = diag(A, m);
    return
  end

  % Do the things
  if ~vis
    % Calculate the indices of the entries you are populating or extracting
    i = 1 : N;
    j = mod((1 : N) + m - 1, N) + 1;
    inds = sub2ind([N, N], i, j)(:);
    % Extract them if necessary...
    if size(A, 2) ~= 1
      assert(size(A, 2) == N, 'A not square');
      d = A(inds);
    else
      % Populate them ow
      d = sparse(N, N);
      d(inds) = A;
    end
  else
    if size(A, 2) ~= 1
      assert(size(A, 2) == N, 'A not square');

      inds = mod((1 + m) + (1:N)*(N+1) - 1, N) + 1;
      d = A(inds);
    else
      top = A(1 : (N - m));
      btm = A(N - m + 1 : N);
      d = diag(top, m) + diag(btm, m - N);
    endif
  end
    

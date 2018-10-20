function TdA = tdelta(A, delta, s)
  % TdA = tdelta(A, delta, s)
  %
  % Performs the T_delta projection (or T_{\delta, s}) on A.

  if ~exist('s')
    s = 1;
  end
  if numel(A) == 1
    A = ones(A);    
  end

  d = size(A, 1);
  assert(all(size(A) == d), 'A should be square');
  dbar = d / s;
  assert(dbar == floor(dbar), 's should divide d');

  if s == 1
    TdA = diag2tdelt(tdelt2diag(A, delta), d, delta);
    return
  else
    TdA = sparse(d, d);
    for l = 0 : dbar - 1
      inds = mod((l * s) + (1 : delta) - 1, d) + 1;
      TdA(inds, inds) = A(inds, inds);
    end
    return
  end
    

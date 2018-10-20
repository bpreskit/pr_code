function S = shiftmat(d, k)

  if ~exist('k')
    k = 1;
  end

  S = circshift(speye(d), k);

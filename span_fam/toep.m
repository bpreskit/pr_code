function [At, b, c, K] = toep(P)

  m = size(P, 1);
  b = [sparse(m, 1); 1];
  e = ones(m, 1);
  K.q = [1 + m*(m + 1)/2];
  K.xcomplex = 2 : K.q(1);
  At = sparse([], [], [], K.q(1) + m^2, m + 1, 1 + 2 * m^2);
  At(:, 1) = [sparse(2:(m + 1), 1, 1, K.q(1), 1); - vec(speye(m))];
  c = [0; diag(P)];
  firstk = m + 2;
  for k = 1 : (m - 1)
    lastk = firstk + m - k - 1;
    Ti = spdiags(e, k, m, m);
    At(:, k + 1) = [sqrt(2) * sparse(firstk:lastk, 1, 1, K.q(1), 1); -2 * vec(Ti)];
    c = [c; sqrt(2) * diag(P, k)];
    firstk = lastk + 1;
  end
  At(:, m + 1) = [1; sparse(K.q(1) + m^2 - 1, 1)];
  c = [c; zeros(m^2, 1)];
  K.s = [m];
  K.scomplex = 1;
  K.ycomplex = 2 : m;
  

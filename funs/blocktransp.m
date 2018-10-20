function VT = blocktransp(V, N)
  %% function VT = blocktransp(V, N)

  [kN, m] = size(V);
  k = kN / N;

  msg = sprintf("V's size %d does not cooperate with N %d", size(V, 1), N);
  assert(mod(k, 1) == 0, msg);

  VT = zeros(k * m, N);

  for i = 1 : k
    VT((i - 1) * m + 1 : i * m, :) = V((i-1) * N + 1 : i * N, :)';
  end

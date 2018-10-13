D = 2 * delta - 1;

Fd = dftmtx(d)' / sqrt(d);
FD = dftmtx(D)' / sqrt(D);
FDt = FD(:, delta + 1) .* FD * sqrt(D);
K = D;

m1 = 1 - delta;
m2 = delta - 1;
gg = zeros(d);
gg(1 : delta, 1 : delta) = gam * gam';
g = zeros(d, D);
for m = m1 : m2
  g(:, m - m1 + 1) = circdiag(gg, m);
end

dM = sparse(d * D, d * D);

for l = 1 : d
  M(:, :, l) = sqrt(D) * FDt .* (sqrt(d) * Fd(l, :) * g);
  dM((l - 1) * D + 1 : l * D, (l - 1) * D + 1 : l * D) = M(:, :, l);
end

P = interleave(D, d);
A = P * kron(Fd, eye(D)) * dM * kron(Fd, eye(D))' * P';

## Z = sqrt(d * D) * g' * Fd;
## chi = zeros(d, D);

## for m = m1 : m2
##   mm = m - m1 + 1;
##   chi(:, m) = Fd ./ Z(m, :) * Fd' * 

tic;
for l = 1 : D
  for m = 1 - delta : delta - 1
    g2(1:delta, m + delta, l) = masks(:, l) .* ...
		 (conj(circshift([masks(:, l); zeros(33, 1)], -m))(1 : delta));
  end
end 
toc;

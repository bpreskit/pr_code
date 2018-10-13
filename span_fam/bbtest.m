d = 64;
i = sqrt(-1);
x = randn(d, 1) + i * randn(d, 1);
X = x * x';
delta = 4;
snr = 1e5;
N = randn(d);
N = N / (frob(N) * snr) * frob(X);

norm(blocky_block(X+N) - abs(x)) / norm(x)

ax = blocky_block(X+N, delta);
norm(ax - abs(x)) / norm(abs(x))

J_i = cell();
for i = 1 : d
  J_i(i) = [1 2 4] + i;
end

[axj, vecsj, muj] = blocky_block(X+N, J_i);
norm(axj - abs(x)) / norm(abs(x))

[axs, vecss, mus] = blocky_block(X+N, [4, 2]);
norm(axs - abs(x)) / norm(abs(x))

[axf, vecsf, muf] = blocky_block(X+N, delta, []);
thetadist(axf, x) / norm(x)

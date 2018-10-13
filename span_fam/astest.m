d = 64;
delta = 3;
x0 = randn(d, 1) + i * randn(d, 1);
X = x0 * x0';
data.X = diag2tdelt(tdelt2diag(X, delta), d, delta);
data.method = 'eig';

[tx, hz] = angsync(data);
thetadist(tx, sign(x0))

d = 4096;
delta = 17;
s = 16;
x = sign(complex(randn(d, 1), randn(d, 1)));
X = tdelta(x * x', delta, s);
root = randi(d);

tic;
tx = bfs(X, root);
thetadist(tx, x)
toc;

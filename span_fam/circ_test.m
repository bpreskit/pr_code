ns = [32, 64, 128, 256, 512, 1024]';
x = randn(ns(end), 1);
Nn = numel(ns);
Nt = 64;

fft_times = zeros(Nt, Nn);
fast_times = zeros(Nt, Nn);

for in = 1:Nn
  n = ns(in)
  for t = 1 : Nt
    tic;
    circ_fft(x(1:n), n);
    fft_times(t, in) = toc;
    tic;
    circ_fast(x(1:n), n);
    fast_times(t, in) = toc;
  end
end

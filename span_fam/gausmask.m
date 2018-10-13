function gam = gausmask(a, delta)
  % gam = gausmask(a, delta)
  % Returns a unit-norm vector gam in \R^\delta whose entries describe
  % a discretized Gaussian bell curve, in the sense that
  % 
  % gam_i = C exp( C' (x - (delta + 1) / 2)^2),
  %
  % where C' is chosen so that a is the number of standard deviations on
  % either side of the center (sigma = (delta - 1) / 2 a) and C is chosen
  % so that ||gam|| = 1.

  sigma = (delta - 1) / (2 * a);
  gam = zeros(delta, 1);
  mu = (delta + 1) / 2;

  gam = vec(exp(-(((1 : delta) - mu).^2 / (2 * sigma^2))));
  gam = gam / norm(gam);

d = 60;
delta = 13;
s = 1;
C = 0.2172336 * 2;
D = 2 * delta - 1;

flatpty = zeros(delta, d*D);

gam = ones(delta, 1);
gam(1) = C * delta;

for l = 1 : d
  inds = (1:D) + (l - 1) * D;
  flatpty(:, inds) = gammasks(circshift(gam, l-1), delta, D);
end

alpha = s * (2 * delta - s);
masks = flatpty(:, randperm(d*D, alpha));
ptycond(masks, d, delta, s)

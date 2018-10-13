function kappa = flatcond(a, d, delta)
  % kappa = flatcond(a, d, delta)
  % Computes the condition number for the local Fourier measurement system
  % with gam = a e_1 + \one, where a \in \R.

  % Prelim calculations
  nGam = (a + 1)^2 + (delta - 1);
  i = sqrt(-1);
  omega = exp(2 * pi * i / d);

  % Range of j and m to use in the Fourier thing
  jv = (2 : (ceil(d / 2) + 1));
  mv = 0 : delta - 1;
  h = zeros(ceil(d / 2), delta);

  % Do the calculations...
  % for j = jv
  %   ij = j - jv(1) + 1;
  %   for m = mv
  %     im = m - mv(1) + 1;
  %     % If m == 0, the first entry is different.
  %     if m == 0
  % 	h(ij, im) = (a + 1)^2 - 1 + omgsum(delta - m, j, omega);
  %     else
  % 	h(ij, im) = a + omgsum(delta - m, j, omega);
  %     end
  %   end
  % end
  h = (1 - omega.^(-(jv - 1)' * (delta - mv))) ./ (1 - omega.^(-(jv - 1)'));
  h = h + [(a + 1)^2 - 1, a * ones(1, delta - 1)];

  kappa = nGam / min(abs(h(:)));

  % function s = omgsum(k, j, omega)
  %   omega = omega^(j - 1);
  %   s = (1 - omega.^k) / (1 - omega);
  % end
end

function [kappa, kapbnd] = expcond(a, d, delta)
  % kappa = expcond(a, d, delta)
  % This calculates the actual condition number of the local Fourier
  % measurement system in \C^d with mask \gamma_i = a^{i-1} and support delta.

  % gam = [a.^(0 : delta - 1)'; zeros(d - delta, 1)];
  % kappa = gamcond(gam, d, delta);

  % nGam = (a^(2 * delta) - 1) / (a^2 - 1);
  % kapbnd = nGam * (a^2 + 1) / (a^(delta - 1) * (a^2 - 1));  

  omega = exp(2 * pi * i / d);
  nGam = (a^(2 * delta) - 1) / (a^2 - 1);

  jv = (1 : (ceil(d / 2) + 1))';
  mv = 0 : (delta - 1);
  hv = nGam ./ h(jv, mv, a, delta, omega);
  kappa = max(abs(hv(:)));
  kapbnd = nGam * (a^2 + 1) / (a^(delta - 1) * (a^2 - 1));
   
  function h = h(j, m, a, delta, omega)
    h = a.^m - a.^(2 * delta - m) .* omega.^(-(j - 1) * (delta - m));
    h = h ./ (1 - a^2 * omega.^(- (j - 1)));
  endfunction
endfunction

function gam = gam2(m, d, a=4)

  gam = exp(-((1 : d)' + circshift((1 : d)', -m)) / a);

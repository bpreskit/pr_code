function G = Gm(m, d, a=4)

  G = diag(exp(-1 / a * [m * ones(d - m, 1); (d - m) * ones(m, 1)]));
	   
  

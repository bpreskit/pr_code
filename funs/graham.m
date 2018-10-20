function AA = graham(A, in, cpx)
  if ~exist('in')
    in = 1;
  end
  if ~exist('cpx')
    cpx = 1;
  end

  if in
    if not(logical(cpx))
      AA = A.' * A;
    else
      AA = A' * A;
    end
  else
    if not(logical(cpx))
      AA = A * A.';
    else
      AA = A * A';
    end
  end 

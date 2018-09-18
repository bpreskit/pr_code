function a = a_delta(delta)
  % a = a_delta(delta)
  % Returns recommended exponential constant for the exponential masks 

  if numel(delta) ~= 1
    a = zeros(numel(delta), 1);
    for i = 1 : numel(delta)
      a(i) = a_delta(delta(i));
    end

    return
  end
  
  assert(delta >= 2);
  assert(mod(delta, 1) == 0);
  if delta <= 5
    a = (1 + sqrt(5)) / 2;
  else
    a = sqrt(1 + 4 / (delta - 2));
  end

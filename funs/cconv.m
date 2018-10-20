function v = cconv(a, b)

  a = a(:);
  b = b(:);
  N = max(length(a), length(b));
  if length(a) < N
    a = [a; zeros(N - length(a), 1)];
  elseif length(b) < N
    b = [b; zeros(N - length(b), 1)];
  end

  v = zeros(N, 1);
  b = circshift(b(end : -1 : 1), 1);
  for i = 1 : N
    v(i) = a.' * b;
    b = circshift(b, 1);
  end
    

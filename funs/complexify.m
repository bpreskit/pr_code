function z = complexify(x, vecs)

  if ~exist('vecs')
    vecs = 0;
  end

  msg = 'x is not proper size';
  assert(~mod(size(x, 1), 2), msg);

  if mod(size(x, 2), 2)
    vecs = 1;
  end

  if ~vecs
    z = zeros(size(x) / 2);
    z = x(1:2:end, 1:2:end) + i * x(2:2:end, 1:2:end);
    return;
  else
    z = zeros(size(x, 1) / 2, size(x, 2));
    z = x(1:2:end, :) + i * x(2:2:end, :);
    return;
  end

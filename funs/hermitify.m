function h = hermitify(x)

  msg = 'x does not have square no. of entries!';
  assert(~mod(sqrt(size(x, 1)), 1), msg);

  n = sqrt(size(x, 1));
  h = zeros(n * (n + 1) / 2, size(x, 2));

  ind = 1;
  for i = 1 : n
    x_ind = n * (i - 1);

    for j = 1 : (i - 1)
      h(ind++, :) = real(x(x_ind + j, :));
      h(ind++, :) = imag(x(x_ind + j, :));
    end

    msg = 'Why you got imaginaries on the diagonal?';
    assert(all(isreal(x(x_ind + i, :))), msg);
    h(ind++, :) = x(x_ind + i, :);
  end

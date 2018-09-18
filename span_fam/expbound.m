function [kapreal, kaprnd] = expbound(delta)

  if numel(delta) > 1
    kapreal = zeros(size(delta));
    kaprnd = zeros(size(delta));

    for i = 1 : numel(delta)
      [kapreal(i), kaprnd(i)] = expbound(delta(i));
    end

    return;
  end
  if delta >= 5
    a = sqrt(1 + 4 / (delta - 2));
  else
    a = (1 + sqrt(5)) / 2;
  end

  nGam = (a.^(2 * delta) - 1) / (a^2 - 1);
  kapreal = (a.^(2 * delta) - 1) ./ (a.^(delta - 2) * (a^2 - 1)^2);
  kaprnd = (e * (delta + 2) / 4).^2;
  

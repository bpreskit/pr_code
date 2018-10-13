function dist = thetadist(x1, x2)
  % dist = thetadist(x1, x2)
  %
  % Calculates \min_{\theta \in [0, 2 \pi)} || x1 - e^(i \theta) x2 ||_2

  dist = sqrt(norm(x1)^2 + norm(x2)^2 - 2 * abs(x1' * x2));

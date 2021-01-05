function kappa = ptycond_tall(masks, d, delta, s)
  % kappa = ptycond_tall(masks, d, delta, s)
  %
  % Calculates the condition number of the ptychographic measurement
  % system with the given data:
  %
  % A(X)_(l, j) = <S^((l - 1) s) m_j m_j^* S^(-(l - 1) s), X>

  if ~exist('s')
    s = 1;
  end

  warning('error', 'Octave:nearly-singular-matrix', 'local');
  warning('error', 'Octave:singular-matrix', 'local');

  if s == 1
    kappa = arbcond(masks, d, delta);
    return
  end

  D = size(masks, 2);
  alpha = s * (2 * delta - s);
  assert(D >= alpha, 'Wrong no. of masks!');
  dbar = d / s;
  assert(dbar == floor(dbar), 's should divide d');

  Fdel = dftmtx(delta);
  Fs = cell(D, 2 * delta - 1);

  gg = zeros(d);
  for j = 1 : D
    curcirc = masks(:, j) .* conj(circ_fft(masks(:, j), delta));
    for m = 1 - delta : delta - 1
      curd = zeros(d, 1);
      dinds = max(1, 1 - m) : min(delta, delta - m);
      curd(dinds) = curcirc(dinds, mod(-m, delta)+1);
      fTsg = fft(reshape(curd, [s, dbar])');
      if delta - abs(m) < s
	if m < 0
    inds = mod((abs(m) + 1 : delta) - 1, s) + 1;
	else
    inds = mod((1 : delta - m) - 1, s) + 1;
	end
	fTsg = fTsg(:, inds);
      end
      Fs{j, m+delta} = fTsg;
      errmsg = sprintf('failure, Will Robinson!, (j, m) = (%d, %d)', j, m);
      assert(all(sum(abs(fTsg), 1) > 0), errmsg);
    end
  end

  smax = zeros(dbar, 1);
  smin = zeros(dbar, 1);

  for k = 1 : dbar
    Mk = zeros(D, alpha);
    inds = 0;
    for m = 1 - delta : delta - 1
      width = min(delta - abs(m), s);
      inds = inds(end) + 1 : inds(end) + width;
      for j = 1 : D
        Mk(j, inds) = Fs{j, m+delta}(k, :);
      end
    end
    r = rank(Mk);
    errmsg = sprintf('Singular Mk! (k, r) = (%d, %d)', k, r);
    assert(r == alpha, errmsg);
    smax(k) = sqrt(eigs(Mk' * Mk, 1));
    smin(k) = sqrt(eigs(Mk' * Mk, 1, 'sm'));
  end

  kappa = abs(max(smax) / min(smin));

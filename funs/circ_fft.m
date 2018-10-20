function C = circ_fft(x, n)
  %% function C = circ_fft(x, n)
  %% Returns circ(x)

  % y = [x; x];
  % C = zeros(n);
  % for i = 1 : n
  %   C(:, i) = y(i : i + n - 1);
  % end
  C = ifft(diag(fft(x)))*dftmtx(n);

% bb_chart
% Author: Brian Preskitt (2018)
%
% This file produces figure xxxx in my dissertation.

% General housekeepings
close all

% Set some constants
d = 60;
delta = 6;
snrs = 10.^[-1:1:5];
ss = [1; 3; 5];
%ss = [1];
Nt = 128;
D = 2 * delta - 1;
C = 0.2172336 * 2;
my_font = '/usr/share/fonts/truetype/dejavu/DejaVuSerifCondensed.ttf';
figdir = '~/ucsd/dissertation/dissertation/sections/ptychography/figs/';
%figdir = strcat(pwd, '/');
figfil = strcat(figdir, 'bb_chart%d.pdf');

bm1 = zeros(numel(snrs), numel(ss));
bmd = zeros(numel(snrs), numel(ss));
bmp = zeros(numel(snrs), numel(ss));

% Calculate them...
for i = 1 : numel(snrs)
  snr = snrs(i);
  for j = 1 : numel(ss)
    s = ss(j);
    jlen = floor((delta-1) / s) * s;
    dbar = d / s;
    J_i = cell();
    am1 = zeros(Nt, 1);
    amd = zeros(Nt, 1);
    amp = zeros(Nt, 1);
    for l = 0 : dbar-1
      J_i{l+1} = [l*s + (1:jlen)];
    end
    for t = 1 : Nt
      x = complex(randn(d, 1), randn(d, 1));
      N = randn(d);
      N = (N + N') / 2;      
      X = tdelta(x * x', delta, s);
      N = tdelta(N, delta, s);
      N = N / frob(N) * frob(X) / snr;

      x1 = blocky_block(X+N);
      xd = blocky_block(X+N, [delta, s]);
      xp = blocky_block(X+N, J_i);

      am1(t) = norm(x1 - abs(x)) / norm(x);
      amd(t) = norm(xd - abs(x)) / norm(x);
      amp(t) = norm(xp - abs(x)) / norm(x);
    end
    bm1(i, j) = mean(am1);
    bmd(i, j) = mean(amd);
    bmp(i, j) = mean(amp);
  end
end    
    
% plotit
% Set things up
lw = 12;
ms = 12;
close all;
h = zeros(numel(ss), 1);
hax = zeros(numel(ss), 1);
hleg = zeros(numel(ss), 1);
handels = zeros(numel(ss), 3);
strindels = {'Diags', 'J_i = [\delta]_i', "Part'n"};
color1 = [255 171 36] / 255;
color2 = [170 37 230] / 255;
color3 = [0 189 253] / 255;

for i = 1 : numel(ss)
  h(i) = figure(i);
  hax(i) = axes();
  hold on
  grid on

  % Do the plots
  handels(i, 1) = plot(log10(snrs), log10(bm1(:, 1)), 'x', ...
		       'linewidth', lw, 'color', color1, 'markersize', ms);
  handels(i, 2) = plot(log10(snrs), log10(bmd(:, 1)), 'x', ...
		       'linewidth', lw, 'color', color2, 'markersize', ms);
  handels(i, 3) = plot(log10(snrs), log10(bmp(:, 1)), 'x', ...
		       'linewidth', lw, 'color', color3, 'markersize', ms);
  % Reset the tick marks logarithmically
  xtm = get(hax(i), 'xtick');
  xtstr = cell();
  for k = 1 : numel(xtm)
    xtstr{k} = sprintf('10^{%d}', xtm(k));
  end
  set(hax(i), 'xtick', xtm);
  set(hax(i), 'xticklabel', xtstr);
  xlabel(hax(i), 'SNR (log scale)');

  ytm = get(hax(i)).ytick;
  ytstr = cell();
  for k = 1 : numel(ytm)
    ytstr{k} = sprintf('10^{%d}', ytm(k));
  end
  set(hax(i), 'yticklabel', ytstr);
  ylabel(hax(i), 'Relative Error in Mag. Estimation (log scale)');
  
  % Do the legend
  misc = struct();
  misc.position = 'northeast';
  %misc.columns = 2;
  hleg = my_leg2(handels(i, :), strindels, misc);

  % Font stuff
  FN = findall(h(i), '-property', 'FontName');
  set(FN, 'FontName', my_font);
  FS = findall(h(i), '-property', 'FontSize');
  set(FS, 'FontSize', 14);

  % Make a pdf!
  print(h(i), '-color', sprintf(figfil, i));
end

% tau_ptych_delta
% Author: Brian Preskitt (2018)
%
% This file produces figure xxxx in my dissertation.

% General housekeepings
close all

% Set some constants
d = 240;
deltas = [5 9 17 21 41 81];
ol_ratios = [0.5, 0.25];
styl = {'k', 'b-', 'r-', 'b--', 'r--', 'b:'};
clr = {[29 194 88]/255, [239 135 6]/255, [115 24 156]/255, ...
       [53 154 188]/255, [233 203 0]/255};
D = 2 * delta - 1;
C = 0.2172336 * 2;
my_font = '/usr/share/fonts/truetype/dejavu/DejaVuSerifCondensed.ttf';
figdir = '~/ucsd/dissertation/dissertation/sections/ptychography/figs/';
%figdir = strcat(pwd, '/');
figfil = strcat(figdir, 'tau_ptych_delta.pdf');

% To store the calculated taus and d's (different for each shift size)
tdat = zeros(numel(deltas), numel(ol_ratios)+2);

% Calculate them...
for i = 1 : numel(deltas)
  delta = deltas(i);
  ss = [1, ol_ratios * (delta - 1), delta - 1];
  % For each d, construct graph and take spectral gap
  for j = 1 : numel(ss)
    s = ss(j);
    dbar = d / s;
    assert(dbar == floor(dbar), 's must divide d!');
    T = zeros(d);
    for l = 1 : dbar
      inds = mod((1 : delta) + (l-1) * s - 1, d) + 1;
      T(inds, inds) = 1;
    end
    % Form an operator that goes onto orthogonal complement
    % of null space
    if mod(d, 2)
      inds = 2:(1 + (d-1)/2);
      P = sqrt(2/d) * real(dftmtx(d)')(:, inds);
      P = [P, sqrt(2/d) * imag(dftmtx(d)')(:, inds)];
    else
      inds = 2 : (d / 2);
      P = sqrt(2/d) * real(dftmtx(d)')(:, inds);
      P = [P, sqrt(2/d) * imag(dftmtx(d)')(:, inds)];
      P = [P, dftmtx(d)'(:, inds(end)+1) / sqrt(d)];
    end
    % calc and store
    T = T - diag(diag(T));
    L = diag(T * ones(d, 1)) - T;
    L = P' * L * P;
    tdat(i, j) = abs(eigs(L, 1, 'sm'));
  end
end
    
% plotit
% Set things up
close all;
h = figure(1);
hax = axes();
hold on
grid on
lw = 14;
ms = 16;

% Do the plots
handels = zeros(numel(ss), 1);
strindels = {'s = 1', 's = (\delta - 1)/2', 's = (\delta - 1)/4', 's = \delta - 1'};

for i = 1 : numel(ss)
  handels(i) = plot(log2(deltas), log2(tdat(:, i)), 'x', ...
		    'markersize', ms, 'linewidth', lw, 'color', clr{i});
end
% for i = 1 : numel(ss)
%   handels(i) = plot(log2(ddat{i}), log2(tdat{i}), styl{i}, 'linewidth', lw);
%   strindels{i} = sprintf('OL = %.1f%%', 100*(delta - ss(i))/delta);
% end

% Plot \delta^3 for reference
mxs = deltas(2);
mxe = deltas(end-1);
mx = mxs : mxe;
ysh = 2^(-1);
my = mx.^3 / (mxs^3) * ysh;
plot(log2(mx), log2(my), 'k:', 'linewidth', lw);

% Plot \delta^2 for reference
mxs = deltas(4);
mxe = deltas(end);
mx = mxs : mxe;
ysh = 2^(-4.5);
my = mx.^2 / (mxs^2) * ysh;
plot(log2(mx), log2(my), 'k:', 'linewidth', lw);

% Reset the tick marks logarithmically
xtm = get(hax).xtick;
xtstr = cell();
for i = 1 : numel(xtm)
  xtstr{i} = sprintf('2^{%d}', xtm(i));
end
set(hax, 'xtick', xtm);
set(hax, 'xticklabel', xtstr);
xlabel(hax, 'Support size, \delta');

ytm = get(hax).ytick;
ytstr = cell();
for i = 1 : numel(ytm)
  ytstr{i} = sprintf('2^{%d}', ytm(i));
end
set(hax, 'yticklabel', ytstr);
ylabel(hax, 'Spectral gap, \tau_G (log scale)');
 
% Do the legend
misc = struct();
misc.position = 'northwest';
misc.columns = 2;
hleg = my_leg2(handels, strindels, misc);

% Font stuff
FN = findall(h, '-property', 'FontName');
set(FN, 'FontName', my_font);
FS = findall(h, '-property', 'FontSize');
set(FS, 'FontSize', 14);

% Make a png!
print(h, '-color', figfil);

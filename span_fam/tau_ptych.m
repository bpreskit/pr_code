% tau_ptych
% Author: Brian Preskitt (2018)
%
% This file produces figure xxxx in my dissertation.

% General housekeepings
close all

% Set some constants
dstart = 32;
dend = 256;
delta = 16;
ss = [1 4 8 12 14 15];
styl = {'k', 'b-', 'r-', 'b--', 'r--', 'b:'};
clr = {'k', [239 135 6]/255, [115 24 156]/255, ...
       [53 154 188]/255, [233 203 0]/255, [29 194 88]/255};
D = 2 * delta - 1;
C = 0.2172336 * 2;
my_font = '/usr/share/fonts/truetype/dejavu/DejaVuSerifCondensed.ttf';
figdir = '~/ucsd/dissertation/dissertation/sections/ptychography/figs/';
%figdir = strcat(pwd, '/');
figfil = strcat(figdir, 'tau_ptych_unmarked.svg');

% To store the calculated taus and d's (different for each shift size)
ddat = cell();
tdat = cell();

% Calculate them...
for i = 1 : numel(ss)
  s = ss(i);
  d1 = ceil(dstart / s) * s;
  curds = d1 : s : dend;	% Decide which d's are div'ble by s
  ddat{i} = curds;
  tdat{i} = zeros(numel(curds), 1);
  % For each d, construct graph and take spectral gap
  for j = 1 : numel(curds)
    d = curds(j);
    dbar = d / s;
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
    tdat{i}(j) = eigs(L, 1, 'sm');
  end
end
    
% plotit
% Set things up
close all;
h = figure(1);
hax = axes();
hold on
grid on
lw = 8;

% Do the plots
handels = zeros(numel(ss), 1);
for i = 1 : numel(ss)
  handels(i) = plot(log2(ddat{i}), log2(tdat{i}), ...
		    'linewidth', lw, 'color', clr{i});
  strindels{i} = sprintf('OL = %.1f%%', 100*(delta - ss(i))/delta);
end
% for i = 1 : numel(ss)
%   handels(i) = plot(log2(ddat{i}), log2(tdat{i}), styl{i}, 'linewidth', lw);
%   strindels{i} = sprintf('OL = %.1f%%', 100*(delta - ss(i))/delta);
% end

% Plot 1/d^2 for reference
mxs = 2^7;
mxe = 2^8;
mx = mxs : mxe;
ysh = 2^3;
my = (mxs^2)*(ysh) ./ mx.^2;
plot(log2(mx), log2(my), 'k:', 'linewidth', lw);

% Reset the tick marks logarithmically
xtm = ceil(log2(dstart)):floor(log2(dend));
xtstr = cell();
for i = 1 : numel(xtm)
  xtstr{i} = sprintf('2^{%d}', xtm(i));
end
set(hax, 'xtick', xtm);
set(hax, 'xticklabel', xtstr);
xlabel(hax, 'Ambient dimension, d (log scale)');

ytm = get(hax).ytick;
ytstr = cell();
for i = 1 : numel(ytm)
  ytstr{i} = sprintf('2^{%d}', ytm(i));
end
set(hax, 'yticklabel', ytstr);
ylabel(hax, 'Spectral gap, \tau_G (log scale)');
 
% Do the legend
misc = struct();
misc.position = 'northeast';
misc.columns = 2;
hleg = my_leg2(handels, strindels, misc);

% Font stuff
FN = findall(h, '-property', 'FontName');
set(FN, 'FontName', my_font);
FS = findall(h, '-property', 'FontSize');
set(FS, 'FontSize', 14);

% Make a png!
print(h, '-color', figfil);

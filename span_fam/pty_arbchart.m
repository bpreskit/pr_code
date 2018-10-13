% pty_arbchart
% Author: Brian Preskitt (2018)
%
% This file produces the figure displayed in xxxx of my dissertation.

% General housekeepings
close all

% Set some constants
d = 60;
delta = 13;
ss = [1 2 6 12];
Ns = numel(ss);
D = 2 * delta - 1;
Nt = 1024;
colors = {[239 135 6]/255, [115 24 156]/255, ...
       [53 154 188]/255, [233 203 0]/255, [29 194 88]/255};
my_font = '/usr/share/fonts/truetype/dejavu/DejaVuSerifCondensed.ttf';
figdir = '~/ucsd/dissertation/dissertation/sections/ptychography/figs/';
%figdir = strcat(pwd, '/');
figfil = strcat(figdir, 'pty_arbchart.pdf');

% dew it
kappa = zeros(Nt, Ns);
for si = 1 : Ns
  s = ss(si);
  dbar = d / s;
  assert(dbar == floor(dbar), 's should divide d!');
  alpha = s * (2 * delta - s);
  tic;
  for i = 1 : Nt
    masks = (randn(delta, alpha) + randn(delta, alpha) * sqrt(-1)) / 2;
    kappa(i, si) = ptycond(masks, d, delta, s);
  end
  toc;
end

kappa_pty_arbchart = kappa;
save kappa_pty_arbchart

% plotit
close all;
h = figure(1);
hax = axes();
hold on;
grid on
nbins = 30;
histbeg = 2;
histend = 7;
bins = ((1:nbins) - 1) / nbins * (histend - histbeg) + ...
       histbeg + 0.5 * (histend-histbeg)/nbins;
lw = 10;

for i = 1 : Ns
  [dist, ~] = hist(log10(kappa(:, i)), bins, 1);
  handels(i) = plot(bins, dist, 'linewidth', lw, 'color', colors{i});
  strindels{i} = sprintf('s = %d', ss(i));
end
xlabel(hax, '\kappa (log scale)');
ylabel(hax, 'Fraction of results in bin');

% Relabel logarithmic axis
xtm = get(hax).xtick;
xtstr = cell();
for i = 1 : numel(xtm)
  xtstr{i} = sprintf('10^{%d}', xtm(i));
end
set(hax, 'xticklabel', xtstr);

% Do the legend
hleg = my_legend(handels, strindels, 'northeast');

% Font stuff
FN = findall(h, '-property', 'FontName');
set(FN, 'FontName', my_font);
FS = findall(h, '-property', 'FontSize');
set(FS, 'FontSize', 14);

% Fix legend a little
set(hleg, 'position', get(hleg).position + [0 0 .05 0])

% % make the histo's transparent
% ohoolihan = findobj(hax, 'type', 'patch');
% set(ohoolihan, 'facealpha', .4);

% Make a png!
print(h, '-color', figfil);

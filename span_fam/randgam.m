% randgam.m
% Author: Brian Preskitt (2018)
%
% This file produces the figure displayed in xxxx of my dissertation.

% General housekeepings
close all
graphics_toolkit('gnuplot');

% Set some constants
d = 256;
delta = 100;
D = 2 * delta - 1;
C = 0.2172336 * 2;
Nt = 2048;
my_font = '/usr/share/fonts/truetype/dejavu/DejaVuSerifCondensed.ttf';
figdir = '~/ucsd/dissertation/dissertation/sections/meas/figs/';
%figdir = strcat(pwd, '/');
figfil = strcat(figdir, sprintf('randgam%d_%d.pdf', d, delta));

% dew it
kappa = zeros(Nt, 1);
tic;
for i = 1 : Nt
  gam = abs(randn(delta, 1));
  kappa(i) = gamcond(gam, d, delta);
end
toc;

% plotit
close all;
h = figure(1);
hax = axes();
hist(hax, log10(kappa), 20, 1);
hold on;
xlabel(hax, '\kappa (log scale)');
ylabel(hax, 'Fraction of results in bin');

% Add flat and exponential for reference
kexp = expcond(sqrt(1 + 4 / (delta - 2)), d, delta);
kflt = flatcond(C * delta, d, delta);
yref = min(get(hax).ytick) + ...
       (2 / 3) * (max(get(hax).ytick) - min(get(hax).ytick));
lwref = 12;
msref = 12;
hexp = plot(log10(kexp), yref, 'rx', 'linewidth', lwref, 'markersize', msref);
hflt = plot(log10(kflt), yref, 'ro', 'linewidth', lwref, 'markersize', msref);

xmin = floor(log10(kflt) * 2) / 2;
xmin = min(xmin, get(hax).xlim(1));
xmax = get(hax).xlim(2)
axis(hax, [xmin, xmax]);

xtm = get(hax).xtick;
xtstr = cell();
for i = 1 : numel(xtm)
  xtstr{i} = sprintf('10^{%d}', xtm(i));
end
set(hax, 'xticklabel', xtstr);
set(hax, 'ylim', [0 0.25]);

% Do the legend
handels = [hexp, hflt];
strindels = {'Exp. mask', 'Near-flat mask'};
hleg = my_legend(handels, strindels, 'northeast');

% Font stuff
FN = findall(h, '-property', 'FontName');
set(FN, 'FontName', my_font);
FS = findall(h, '-property', 'FontSize');
set(FS, 'FontSize', 16);

% Fix legend a little
set(hleg, 'position', get(hleg).position + [0 0 .05 0])

% Make a png!
print(h, '-color', figfil);

% arbchart
% Author: Brian Preskitt (2018)
%
% This file produces the figure displayed in xxxx of my dissertation.

% General housekeepings
close all

% Set some constants
d = 64;
delta = 16;
D = 2 * delta - 1;
C = 0.2172336 * 2;
Nt = 4;
my_font = '/usr/share/fonts/truetype/dejavu/DejaVuSerifCondensed.ttf';
figdir = '~/ucsd/dissertation/dissertation/sections/meas/figs/';
figdir = strcat(pwd, '/');
figfil = strcat(figdir, 'arbchart.svg');

% dew it
kappa = zeros(Nt, 1);
tic;
for i = 1 : Nt
  masks = (randn(delta, D) + randn(delta, D) * sqrt(-1)) / 2;
  kappa(i) = arbcond(masks, d, delta);
end
toc;

% dew it
kappagam = zeros(Nt, 1);
for i = 1 : Nt
  gam = abs(randn(delta, 1));
  kappagam(i) = gamcond(gam, d, delta);
end


% plotit
close all;
h = figure(1);
hax = axes();
bins = (1 : 20) / 3 + 1 + 1 / 6;
gencolor = [.6 .4 .6];
gamcolor = [.4 .8 .5];
hist(hax, log10(kappa), bins, 1, 'facecolor', gencolor);
hold on;
hist(hax, log10(kappagam), bins, 1, 'facecolor', gamcolor);
xlabel(hax, '\kappa (log scale)');
ylabel(hax, 'Fraction of results in bin');
sqx = [mean(get(hax).xlim), mean(get(hax).ylim)];
hgenleg = plot(sqx(1), sqx(2), 's', 'markerfacecolor', gencolor, ...
         'markeredgecolor', gencolor);
hgamleg = plot(sqx(1), sqx(2), 's', 'markerfacecolor', gamcolor, ...
         'markeredgecolor', gamcolor);

% Add flat and exponential for reference
kexp = expcond(sqrt(1 + 4 / (delta - 2)), d, delta);
kflt = flatcond(C * delta, d, delta);
yref = min(get(hax).ytick) + ...
       (2 / 3) * (max(get(hax).ytick) - min(get(hax).ytick));
lwref = 24;
msref = 6;
hexp = plot(log10(kexp), yref, 'kx', 'linewidth', lwref, 'markersize', msref);
hflt = plot(log10(kflt), yref, 'ko', 'linewidth', lwref, 'markersize', msref);
hspr = plot(log10(arbcond(sparsemasks(d, delta), d, delta)), ...
      yref, 'ks', 'linewidth', lwref, 'markersize', msref);

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
%set(hax, 'ylim', [0 10]);

% Do the legend
handels = [hexp, hflt, hspr, hgenleg, hgamleg];
strindels = {'Expon.', 'Near-flat', 'Sparse', 'General', 'Fourier'};
hleg = my_legend(handels, strindels, 'northeast');
set([hgenleg, hgamleg], "visible", "off");

% Font stuff
FN = findall(h, '-property', 'FontName');
set(FN, 'FontName', my_font);
FS = findall(h, '-property', 'FontSize');
set(FS, 'FontSize', 14);

% Fix legend a little
set(hleg, 'position', get(hleg).position + [0 0 .05 0])

% make the histo's transparent
ohoolihan = findobj(hax, 'type', 'patch');
set(ohoolihan, 'facealpha', .4);

% Make a png!
print(h, '-color', figfil);

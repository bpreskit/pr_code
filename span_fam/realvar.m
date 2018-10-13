% realvar.m
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
Fd = dftmtx(d)' / sqrt(d);
my_font = '/usr/share/fonts/truetype/dejavu/DejaVuSerifCondensed.ttf';
figdir = '~/ucsd/dissertation/dissertation/sections/meas/figs/';
figdir = strcat(pwd, '/');
figfil = strcat(figdir, 'realvar.pdf');

% Set up the measurement systems and evaluate expected variance
% Exponential masks
expa = (1 + 4 / (delta - 2))^(1 / 2);
expgam = vec(expa.^(0 : delta - 1));
expG = zeros(d);
expG(1 : delta, 1 : delta) = expgam * expgam';
expgg = tdelt2diag(expG, delta)(:, delta : end);
expS = abs((1 / (d^(3 / 2) * D) * Fd' * abs(Fd' * expgg).^(-2))(1, :));

% Flat masks
flata = C * delta;
flatgam = ones(delta, 1);
flatgam(1) = 1 + flata;
flatG = zeros(d);
flatG(1 : delta, 1 : delta) = flatgam * flatgam';
flatgg = tdelt2diag(flatG, delta)(:, delta : end);
flatS = abs((1 / (d^(3 / 2) * D) * Fd' * abs(Fd' * flatgg).^(-2))(1, :));

% Gaussian masks
dg = d-1;
Fg = dftmtx(dg)' / sqrt(dg);
gausa = 2;
gausgam = gausmask(gausa, delta);
gausG = zeros(dg);
gausG(1 : delta, 1 : delta) = gausgam * gausgam';
gausgg = tdelt2diag(gausG, delta)(:, delta : end);
gausS = abs((1 / (dg^(3 / 2) * D) * Fg' * abs(Fg' * gausgg).^(-2))(1, :));

% Plot it
graphics_toolkit('qt')
close all;
xs = (0 : delta-1)';
lw = 4;
h = figure(1);
[hax, hexp, hgau] = plotyy(xs, expS, xs, gausS, @plot, @semilogy);
hold on;
hflat = plot(hax(1), xs, flatS);
set(hflat, 'linestyle', '--');
xlabel('Diagonal, |i - j| mod d');
% ylabel(hax(1), 'Exponential and flat mask variance');
% ylabel(hax(2), 'Gaussian mask variance');

lyt = get(hax(1), 'ytick');
lytstr = cell();
for i = 1 : numel(lyt)
  %lytstr{i} = strcat(sprintf('%.1f', lyt(i) * 1e3), 'x10^{-3}');
  lytstr{i} = sprintf('%.1e', lyt(i));
end
set(hax(1), 'yticklabel', lytstr);

set([hexp, hgau, hflat], 'linewidth', lw);
handels = [hexp, hflat, hgau];
strindels = {'Exponential', 'Flat', 'Gaussian'};
hleg = my_legend(handels, strindels, 'north');
set(hleg, 'position', get(hleg, 'position')+[0 0 0.05 0])

% Font stuff
FN = findall(h, '-property', 'FontName');
set(FN, 'FontName', my_font);
FS = findall(h, '-property', 'FontSize');
set(FS, 'FontSize', 16);

% Make a png!
print(h, '-color', figfil);

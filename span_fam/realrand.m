% realrand.m
% Author: Brian Preskitt (2018)
%
% This file produces the figure displayed in xxxx of my dissertation.

% General housekeepings
close all
graphics_toolkit('gnuplot');

% Set some constants
d = 64;
delta = 16;
D = 2 * delta - 1;
C = 0.2172336 * 2;
Nt = 1024;
my_font = '/usr/share/fonts/truetype/dejavu/DejaVuSerifCondensed.ttf';
figdir = '~/ucsd/dissertation/dissertation/sections/meas/figs/';
%figdir = strcat(pwd, '/');
figfil = strcat(figdir, sprintf('realrand.pdf', d, delta));

% Set up the measurement systems and evaluate expected variance
% Exponential masks
expa = (1 + 4 / (delta - 2))^(1 / 2);
expgam = vec(expa.^(0 : delta - 1));
expG = zeros(d);
expG(1 : delta, 1 : delta) = expgam * expgam';
expgg = tdelt2diag(expG, delta)(:, delta : end);
expS = abs((1 / (d^(3 / 2) * D) * Fd' * abs(Fd' * expgg).^(-2))(1, :));
expS = expS / norm(expgam)^2;

% Flat masks
flata = C * delta;
flatgam = ones(delta, 1);
flatgam(1) = 1 + flata;
flatG = zeros(d);
flatG(1 : delta, 1 : delta) = flatgam * flatgam';
flatgg = tdelt2diag(flatG, delta)(:, delta : end);
flatS = abs((1 / (d^(3 / 2) * D) * Fd' * abs(Fd' * flatgg).^(-2))(1, :));
flatS = flatS / norm(flatgam)^2;

% Random masks
randS = zeros(delta, Nt);
for i = 1 : Nt
  gam = abs(randn(delta, 1));
  randG = zeros(d);
  randG(1 : delta, 1 : delta) = gam * gam';
  randgg = tdelt2diag(randG, delta)(:, delta : end);
  randS(:, i) = abs((1 / (d^(3 / 2) * D) * Fd' * ...
		     abs(Fd' * randgg).^(-2))(1, :));
  randS(:, i) = randS(:, i) / norm(gam)^2;
end

randSsort = sort(randS, 2);
q1  = randSsort(:, ceil(Nt / 4));
med = randSsort(:, ceil(Nt / 2));
q3  = randSsort(:, ceil(3 * Nt / 4));

% plot
old_lw = 10;
lw = 10;
close all;
h = figure(1);
hold(gca, 'on');
hax = gca;
xs = 0:delta-1;
hexp = plot(xs, expS, 'k', 'linewidth', old_lw);
hflat = plot(xs, flatS, 'k--', 'linewidth', old_lw);
hq1 = plot(xs, q1, 'b--', 'linewidth', lw);
hq3 = plot(xs, q3, 'b', 'linewidth', lw);
hmed = semilogy(xs, med, 'r-', 'linewidth', lw);
set(hax, 'xlim', [0 delta-1]);
xlabel('Diagonal, |i - j|');
ylabel('Variance of X_{ij}, log scale')

% Legend
handels = [hq1, hmed, hq3, hexp, hflat];
strindels = {'Q1', 'Median', 'Q3', 'Exp.', 'Flat'};
misc = struct();
misc.position = 'northwest';
misc.columns = 2;
hleg = my_leg2(handels, strindels, misc);

% Font stuff
FN = findall(h, '-property', 'FontName');
set(FN, 'FontName', my_font);
FS = findall(h, '-property', 'FontSize');
set(FS, 'FontSize', 16);

% Fix legend a little
%set(hleg, 'position', get(hleg).position + [0 0 .05 0])

% Make a png!
print(h, '-color', figfil);

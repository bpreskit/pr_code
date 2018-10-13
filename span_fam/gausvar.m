% gausvar.m
% Author: Brian Preskitt (2018)
%
% This file produces the figure displayed in xxxx of my dissertation.

% General housekeepings
close all
graphics_toolkit('gnuplot');

% Set some constants
d = 63;
delta = 16;
D = 2 * delta - 1;
a = 2;
Nt = 512;
my_font = '/usr/share/fonts/truetype/dejavu/DejaVuSerifCondensed.ttf';
figdir = '~/ucsd/dissertation/dissertation/sections/meas/figs/';
%figdir = strcat(pwd, '/');
figfil = strcat(figdir, sprintf('gausvar%d.pdf', Nt));
X = zeros(d, d, Nt);

% Set up the measurement system
meas_sys.d = d;
meas_sys.delta = delta;
gam = gausmask(a, delta);
meas_sys.gam = gam;

% Run a bunch of simulations
tic;
for i = 1 : Nt
  y = randn(d, D);
  X(:, :, i) = diag2tdelt(gamsolve(meas_sys, y), d, delta);
end
toc;

% Calculate the statistics
X_av = sum(X, 3) / Nt;
X_var = sum(abs(X - X_av).^2, 3) / Nt;

% ...plot them?
hfig = figure(1);
himage = imagesc(log10(X_var));
hgraph = get(himage).parent;
hcol = colorbar;
yticks = 2:.5:6;
ytickstr = cell();
for i = 1 : numel(yticks)
  ytickstr{i} = sprintf('10^{%.1f}', yticks(i));
end
set(hcol, "ytick", yticks);
set(hcol, "yticklabel", ytickstr);
%% set(hcol, "ytick", [0 5 10 15 20] * 1e-4);
%% set(hcol, "yticklabel", {'0.0x10^{-3}', '0.5x10^{-3}', '1.0x10^{-3}', '1.5x10^{-3}', '2.0x10^{-3}'});

% Font stuff
FN = findall(h, '-property', 'FontName');
set(FN, 'FontName', my_font);
FS = findall(h, '-property', 'FontSize');
set(FS, 'FontSize', 16);

% Make a png!
print(h, '-color', figfil);

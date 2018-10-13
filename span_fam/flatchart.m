% flatchart.m
% Author: Brian Preskitt (2018)
%
% This file produces the figure displayed in xxxx of my dissertation.

% General housekeepings
close all
graphics_toolkit('gnuplot');

% Set some constants
Na = 128;
del0 = 4;
Ndel = 64;
deltas = del0 : del0 + Ndel - 1;
amin = 0.1;
amax = 0.8;
% d = 32;
C = 0.2172336 * 2;
results = zeros(Na, Ndel);
my_font = '/usr/share/fonts/truetype/dejavu/DejaVuSerifCondensed.ttf';
figdir = '~/ucsd/dissertation/dissertation/sections/meas/figs/';
%figdir = strcat(pwd, '/');
%figfil = strcat(figdir, sprintf('flatchart%d.pdf', d));
figfil = strcat(figdir, 'flatchart.pdf');

% Indices used for for loop
ii = 0;
jj = 0;
% For each a under test and delta, record conditioning.
for aodel = linspace(amin, amax, Na)
  ii++;
  jj = 0;
  for delta = deltas
    jj++;
    results(ii, jj) = flatcond(aodel * delta, 6 * delta - 1, delta);
  end
end

kapopt = min(results, [], 1);

% Calculate the "recommended a" for our conditioning bound.
kapthm = zeros(Ndel, 1);
kapimp = zeros(Ndel, 1);
for delta = deltas
  i = delta - del0 + 1;
  kapthm(i) = flatcond(2 * delta - 1, 6 * delta - 1, delta);
  kapimp(i) = flatcond(C * delta, 6 * delta - 1, delta);
end

% The rest of this is just setting up the image.
% Produce fundamental image
h = figure(1);
lw = 8;
hopt = plot(deltas, kapopt, 'k', 'linewidth', lw);
hgraph = get(hopt).parent;
hold on;
hthm = plot(deltas, kapthm, 'r', 'linewidth', lw);
himp = plot(deltas, kapimp, 'b', 'linewidth', lw);
xlabel('Support size, \delta');
ylabel('Condition number, \kappa');
%title('log \kappa over a and \delta');

% Funny resize operation that helps position the legend correctly
wpos = get(hgraph).position;
set(hgraph, "position", [0 0 1 1]);
set(hgraph, "position", wpos);

% Set the size of the figure, for printing.
% scale = 1.2;
% W = 4 * scale;
% H = 3 * scale;
% W = 8.5;
% H = 11;
% set(h, 'PaperUnits', 'inches');
% set(h, 'PaperOrientation', 'landscape');
% set(h, 'PaperSize', [H, W])
% set(h, 'PaperPosition', [0,0,W,H]);
% set (gcf, "paperorientation", "landscape") 
% papersize = [30, 21]/5; 
% set (gcf, "papersize", papersize) 
% set (gcf, "paperposition", [0.25 0.25, papersize-0.5]) 
set(hgraph, "ydir", "normal");

% Plot the "optimal a"
% hathm = plot(deltas, aodel_thm, 'x',
% 	     'markersize', 7, 'color', 'k', 'linewidth', 8);
% haimp = plot(deltas, aodel_imp, 'o',
% 	     'markersize', 7, 'color', 'k', 'linewidth', 8);
% hathm = plot(deltas, aodel_thm, 'k--', 'linewidth', 8);
% haimp = plot(deltas, aodel_imp, 'k-.', 'linewidth', 8);

% Make the legend and colorbar!
handels = [hopt, hthm, himp];
strindels = {'Optimal \kappa', 'a = 2 \delta - 1', 'a = 2 C \delta'};
[hleg, htext, hline] = my_legend(handels, strindels, 'northwest');
% hcol = colorbar(hgraph);
% set(hcol, "ytick", [0 1 2 3 4]);
% set(hcol, "yticklabel", {'10^0', '10^1', '10^2', '10^3', '10^4'});

% Font stuff
FN = findall(h, '-property', 'FontName');
set(FN, 'FontName', my_font);
FS = findall(h, '-property', 'FontSize');
set(FS, 'FontSize', 16);

% Make a png!
print(h, '-color', figfil);

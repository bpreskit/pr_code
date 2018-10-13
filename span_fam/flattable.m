% flattable.m
% Author: Brian Preskitt (2018)
%
% This file produces the figure displayed in xxxx of my dissertation.

% General housekeepings
close all
graphics_toolkit('gnuplot');

% Set some constants
Na = 64;
del0 = 2;
Ndel = 64;
deltas = del0 : del0 + Ndel - 1;
amin = 0.1;
amax = 4;
% d = 32;
C = 0.2172336 * 2;
results = zeros(Na, Ndel);
my_font = '/usr/share/fonts/truetype/dejavu/DejaVuSerifCondensed.ttf';
figdir = '~/ucsd/dissertation/dissertation/sections/meas/figs/';
%figdir = strcat(pwd, '/');
%figfil = strcat(figdir, sprintf('flatable%d.pdf', d));
figfil = strcat(figdir, 'flattable.pdf');

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

% Find best choice of a
Naopt = 64;
aomin = 0.1; aomax = 0.8;
ii = 0;
ores = zeros(Naopt, Ndel);
for aodel = linspace(aomin, aomax, Naopt)
  ii++;
  jj = 0;
  for delta = deltas
    jj++;
    ores(ii, jj) = flatcond(aodel * delta, 6 * delta - 1, delta);
  end
end

aopt = linspace(aomin, aomax, Naopt)(argmin(ores, 1));

% Calculate the "recommended a" for our conditioning bound.
aodel_thm = (2 * deltas - 1) ./ deltas;
aodel_imp = C * ones(1, Ndel);

% The rest of this is just setting up the image.
% Produce fundamental image
h = figure(1);
himage = imagesc(deltas, linspace(amin, amax, Na), log10(results));
hgraph = get(himage).parent;
hold on;
axis([del0-0.5  (Ndel + del0 - 0.5) amin amax]);
xlabel('Support size, \delta');
ylabel('Ratio a / \delta');
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
hathm = plot(deltas, aodel_thm, 'k--', 'linewidth', 8);
haimp = plot(deltas, aodel_imp, 'k-.', 'linewidth', 8);
haopt = plot(deltas(4 : 5 : end), aopt(4 : 5 : end), 'kx', 'linewidth', 8);

% Make the legend and colorbar!
handels = [hathm, haimp, haopt];
strindels = {'a = 2 \delta - 1', 'a = 2 C \delta', 'Optimal a'};
[hleg, htext, hline] = my_legend(handels, strindels, 'northwest',
				 'colorbar');
hcol = colorbar(hgraph);
set(hcol, "ytick", [0 1 2 3 4]);
set(hcol, "yticklabel", {'10^0', '10^1', '10^2', '10^3', '10^4'});

% Font stuff
FN = findall(h, '-property', 'FontName');
set(FN, 'FontName', my_font);
FS = findall(h, '-property', 'FontSize');
set(FS, 'FontSize', 16);

% Make a png!
print(h, '-color', figfil);

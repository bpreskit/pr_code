% exptable.m
% Author: Brian Preskitt (2018)
%
% This file produces the figure displayed in xxxx of my dissertation.

% General housekeepings
close all
graphics_toolkit('gnuplot');

% Set some constants
Na = 50;
del0 = 2;
Ndel = 15;
d = 51;
results = zeros(Na, Ndel);
my_font = '/usr/share/fonts/truetype/dejavu/DejaVuSerifCondensed.ttf';
figdir = '~/ucsd/dissertation/dissertation/sections/meas/figs/';
%figdir = strcat(pwd, '/');
figfil = strcat(figdir, sprintf('exptable%d.pdf', d));

% Indices used for for loop
ii = 0;
jj = 0;
% For each a under test and delta, record conditioning.
for a = linspace(1.001, 2, 128)
  ii++;
  jj = 0;
  for delta = del0 : del0 + Ndel - 1
    jj++;
    results(ii, jj) = expcond(a, d, delta);
    bnd_results(ii, jj) = expbound(delta);
  end
end

% Calculate the "recommended a" for our conditioning bound.
aopt = [(1 + sqrt(5)) / 2 * ones(4, 1); sqrt(1 + 4 ./ ((6 : Ndel + 1) - 2))'];
deltas = del0 : del0 + Ndel - 1;

% The rest of this is just setting up the image.
% Produce fundamental image
h = figure(1);
himage = imagesc(deltas, linspace(1.001, 2, 128), log(results));
%colorbar;
hgraph = get(himage).parent;
hold on;
axis([1.5  (Ndel + 1.5) 1 2]);
xlabel('Support size, \delta');
ylabel('Exponential constant, a');
%title('log \kappa over a and \delta');

% Funny resize operation that helps position the legend correctly
wpos = get(hgraph).position;
set(hgraph, "position", [0 0 1 1]);
set(hgraph, "position", wpos);

% Set the size of the figure, for printing.
scale = 1.2;
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
haopt = plot(deltas, aopt, 'x',
	     'markersize', 7, 'color', 'k', 'linewidth', 8);

% Make the legend!
[hleg, htext, hline] = my_legend(haopt, 'a_{\delta}', 'northeast', wpos);

% Font stuff
FN = findall(h, '-property', 'FontName');
set(FN, 'FontName', my_font);
FS = findall(h, '-property', 'FontSize');
set(FS, 'FontSize', 16);

% Make a png!
print(h, '-color', figfil);

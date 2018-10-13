% expchart.m
% Author: Brian Preskitt (2018)
%
% This file produces the figure displayed in xxxx of my dissertation.

% General housekeepings
close all
graphics_toolkit('gnuplot');

% Set some constants
Na = 256;
del0 = 2;
Ndel = 31;
amin = 1.001;
amax = 2;
d = 80;
fixa = [1.1; 1.4];
Nfa = numel(fixa);
curkap = zeros(Na, 1);
my_font = '/usr/share/fonts/truetype/dejavu/DejaVuSerifCondensed.ttf';
figdir = '~/ucsd/dissertation/dissertation/sections/meas/figs/';
%figdir = strcat(pwd, '/');
figfil = strcat(figdir, sprintf('expchart%d.pdf', d));

% Indices used for for loop
ii = 0;
jj = 0;
deltas = del0 : del0 + Ndel - 1;
avec = linspace(amin, amax, Na);
minkaps = zeros(Ndel, 1);
% For each a under test and delta, record conditioning.
for i = 1 : Ndel
  delta = deltas(i);
  kaps = zeros(Na, 1);
  for j = 1 : Na    
    a = avec(j);
    kaps(j) = expcond(a, d, delta);
  end
  minkaps(i) = min(kaps);
end

% Calculate the "recommended a" for our conditioning bound, and kappa
a = a_delta(deltas);
adelkaps = zeros(Ndel, 1);
for i = 1 : Ndel
  adelkaps(i) = expcond(a(i), d, deltas(i));
  for j = 1 : Nfa
    fixkaps(i, j) = expcond(fixa(j), d, deltas(i));
  end
end

% The rest of this is just setting up the image.
% Some plot constants
lw = 12;
% Produce fundamental image, plot the plots
h = figure(1);
hmink = semilogy(deltas, minkaps, 'k', 'linewidth', lw);
hold on;
hadel = semilogy(deltas, adelkaps, 'kx', 'linewidth', lw);
hfk = zeros(Nfa, 1);
hfk(1) = semilogy(deltas, fixkaps(:, 1), 'b', 'linewidth', lw);
hfk(2) = semilogy(deltas, fixkaps(:, 2), 'r', 'linewidth', lw);
hgraph = get(hmink).parent;
grid(hgraph, "on");
grid(hgraph, "minor", "off");
xlabel('Support size, \delta');
ylabel('Condition number, \kappa(a), log scale');

% Funny resize operation that helps position the legend correctly
wpos = get(hgraph).position;
set(hgraph, "position", [0 0 1 1]);
set(hgraph, "position", wpos);

% Make the legend!
handels   = [hmink, hadel, hfk(1), hfk(2)];
strindels = {'Optimal \kappa', '\kappa(a_\delta)', ...
	     sprintf('a = %1.1f', fixa(1)), sprintf('a = %1.1f', fixa(2))};
[hleg, htext, hline] = my_legend(handels, strindels, 'northwest');

% Font stuff
FN = findall(h, '-property', 'FontName');
set(FN, 'FontName', my_font);
FS = findall(h, '-property', 'FontSize');
set(FS, 'FontSize', 16);

% Make a png!
print(h, '-color', figfil);

% gaustable.m
% Author: Brian Preskitt (2018)
%
% This file produces the figure displayed in xxxx of my dissertation.

% General housekeepings
close all
graphics_toolkit('gnuplot');

% Set some constants
Na = 32;
del0 = 5;
Ndel = 32;
deltas = del0 : del0 + Ndel - 1;
amin = 0.5;
amax = 2;
% d = 32;
results = zeros(Na, Ndel);
my_font = '/usr/share/fonts/truetype/dejavu/DejaVuSerifCondensed.ttf';
figdir = '~/ucsd/dissertation/dissertation/sections/meas/figs/';
%figdir = strcat(pwd, '/');
%figfil = strcat(figdir, sprintf('gausable%d.pdf', d));
figfil = strcat(figdir, 'gaustable.pdf');

% Indices used for for loop
ii = 0;
jj = 0;
% For each a under test and delta, record conditioning.
for a = linspace(amin, amax, Na)
  ii++;
  jj = 0;
  for delta = deltas
    jj++;
    gam = gausmask(a, delta);
    results(ii, jj) = gamcond(gam, 6 * delta - 1, delta);
  end
end

% The rest of this is just setting up the image.
% Produce fundamental image
h = figure(1);
himage = imagesc(deltas, linspace(amin, amax, Na), log10(results));
hgraph = get(himage).parent;
set(hgraph, "ydir", "normal");
hold on;
axis([del0-0.5  (Ndel + del0 - 0.5) amin amax]);
xlabel('Support size, \delta');
ylabel('Spreading parameter, k = (\delta - 1) / 2 \sigma');
%title('log \kappa over a and \delta');

% Funny resize operation that helps position the legend correctly
wpos = get(hgraph).position;
set(hgraph, "position", [0 0 1 1]);
set(hgraph, "position", wpos);

% Plot the "optimal a"
% hathm = plot(deltas, aodel_thm, 'k--', 'linewidth', 8);
% haimp = plot(deltas, aodel_imp, 'k-.', 'linewidth', 8);
% haopt = plot(deltas(4 : 5 : end), aopt(4 : 5 : end), 'kx', 'linewidth', 8);

% Make the legend and colorbar!
% handels = [hathm, haimp, haopt];
% strindels = {'a = 2 \delta - 1', 'a = 2 C \delta', 'Optimal a'};
% [hleg, htext, hline] = my_legend(handels, strindels, 'northwest',
% 				 'colorbar');
hcol = colorbar(hgraph);
tm1 = 1;
tmf = 8;
tmstep = 1;
tms = tm1 : tmstep : tmf;
set(hcol, "ytick", tms);
clear ytl;
for i = 1 : numel(tms)
  ytl{i} = sprintf("10^{%d}", tms(i));
end
set(hcol, "yticklabel", ytl);

% Font stuff
FN = findall(h, '-property', 'FontName');
set(FN, 'FontName', my_font);
FS = findall(h, '-property', 'FontSize');
set(FS, 'FontSize', 16);

% Make a png!
print(h, '-color', figfil);

% gaustable.m
% Author: Brian Preskitt (2018)
%
% This file produces the figure displayed in xxxx of my dissertation.

% Housekeeping for the graph.
close all;
my_font = '/usr/share/fonts/truetype/dejavu/DejaVuSerifCondensed.ttf';
figdir = '~/ucsd/dissertation/dissertation/sections/meas/figs/';
%figdir = strcat(pwd, '/');
figfil = strcat(figdir, 'gauschart.pdf');

% Set up some constants
delta = 25;			% Support size
k = [0.5 1 1.5 2.0];		% Spreading parameters to be displayed
h = figure(1);			% make the figure (so we can plot)
hold on;
handels = zeros(numel(k), 1);	% Handles of line objects
strindels = cell(4, 1);		% Strings for legend
lw = 8;				% Linewidth for plots
colors = {'k', 'r', 'b', 'r--'};% Linestyles to be used.

for i = 1 : numel(k)
  gam = gausmask(k(i), delta);	% Calculate the mask...
  handels(i) = plot(gam, colors{i}, 'linewidth', lw); % ...Display it...
  strindels{i} = sprintf("k = %d", k(i));	      % ...Label it.
end

% Set up some graph stuff and go!
hgraph = get(handels(1)).parent;
grid on;
axis([1 delta]);
xlabel('Index within \gamma, i (\delta = 25)');
ylabel('\gamma_i');
% Funny resize operation that helps position the legend correctly
wpos = get(hgraph).position;
set(hgraph, "position", [0 0 1 1]);
set(hgraph, "position", wpos);
[hleg, htext, hline] = my_legend(handels, strindels, 'northeast');

% Font stuff
FN = findall(h, '-property', 'FontName');
set(FN, 'FontName', my_font);
FS = findall(h, '-property', 'FontSize');
set(FS, 'FontSize', 16);

% Make a png!
print(h, '-color', figfil);

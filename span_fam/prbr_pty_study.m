% prbr_pty_study.m
% Author: Brian Preskitt (2020)
% Adapted from pty_arbchart.m

% General housekeepings
close all
pkg load communications
addpath('../funs', 0);

% Set some constants
d = 60;
delta = 13;
ss = [1 2 6 12];
Ns = numel(ss);
D = 2 * delta - 1;
Nt = 1;
colors = {[239 135 6]/255, [115 24 156]/255, ...
       [53 154 188]/255, [233 203 0]/255, [29 194 88]/255};
my_font = '/usr/share/fonts/truetype/dejavu/DejaVuSerifCondensed.ttf';
figdir = '/tmp/figs/';
mkdir(figdir);
figfil = strcat(figdir, 'pty_arbchart.pdf');

% Some constants
opt_decay = 1 + 4 / (delta - 2);
%% opt_decay = 1.6;

% dew it
kappa = zeros(Nt, Ns);
for si = 1 : Ns
  s = ss(si);
  dbar = d / s;
  assert(dbar == floor(dbar), 's should divide d!');
  alpha = s * (2 * delta - s);
  tic;
  for i = 1 : Nt
    num_blocks = ceil(alpha / (2 * delta - 1));
    num_blocks = num_blocks + 2 * s;
    masks = zeros(delta, 0);

    % Construction #1: the basic exponential mask
    %
    % decay_factors = linspace(1.05, opt_decay, num_blocks + 1);
    % for decay = decay_factors(2:end)
    %   masks = [masks, gammasks(decay.^(0:delta-1)', delta)];
    % end

    % Construction #2: exponential masks with random "peak" locations
    %
    decay_factors = linspace(1, opt_decay, num_blocks + 1);
    for decay = decay_factors(2:end)
      decay = 1 / decay;
      if size(masks, 2) != 0
        peak = randi(delta);
      else
        peak = 1;
      end
      display(peak)
      gam = decay.^abs((1:delta)' - peak);
      masks = [masks, gammasks(gam, delta)];
    end

    % Construction #3: masks with real, Gaussian entries
    %
    % for k = 1 : num_blocks
    %   K = (2 * delta - 1) + 3 * (k - 1);
    %   masks = [masks, gammasks(randn(delta, 1), delta, K)];
    % end
    % for k = 1 : num_blocks
    %   masks = [masks, gammasks(ones(delta, 1), delta)];
    % end
    % masks = masks .* randn(size(masks));

    % masks = masks(:, 1:alpha);
    kappa(i, si) = ptycond_tall(masks, d, delta, s);
  end
  printf('The operator for s = %d was non-singular\n', s);
  toc;
end

kappa_pty_arbchart = kappa;
save kappa_pty_arbchart

% plotit
close all;
h = figure(1);
hax = axes();
hold on;
grid on
nbins = 30;
histbeg = 2;
histend = 7;
bins = ((1:nbins) - 1) / nbins * (histend - histbeg) + ...
       histbeg + 0.5 * (histend-histbeg)/nbins;
lw = 10;

for i = 1 : Ns
  [dist, ~] = hist(log10(kappa(:, i)), bins, 1);
  handels(i) = plot(bins, dist, 'linewidth', lw, 'color', colors{i});
  strindels{i} = sprintf('s = %d', ss(i));
end
xlabel(hax, '\kappa (log scale)');
ylabel(hax, 'Fraction of results in bin');

% Relabel logarithmic axis
xtm = get(hax).xtick;
xtstr = cell();
for i = 1 : numel(xtm)
  xtstr{i} = sprintf('10^{%d}', xtm(i));
end
set(hax, 'xticklabel', xtstr);

% Do the legend
hleg = my_legend(handels, strindels, 'northeast');

% Font stuff
FN = findall(h, '-property', 'FontName');
set(FN, 'FontName', my_font);
FS = findall(h, '-property', 'FontSize');
set(FS, 'FontSize', 14);

% Fix legend a little
set(hleg, 'position', get(hleg).position + [0 0 .05 0])

% % make the histo's transparent
% ohoolihan = findobj(hax, 'type', 'patch');
% set(ohoolihan, 'facealpha', .4);

% Make a png!
print(h, '-color', figfil);

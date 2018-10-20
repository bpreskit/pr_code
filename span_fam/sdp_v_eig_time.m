% sdp_v_eig_time
% Author: Brian Preskitt (2018)
%
% This file produces figure xxxx in my dissertation.

% General housekeepings
close all

% Set some constants
ds = ceil(2.^[4:8]);
Nd = numel(ds);
deltas = floor(min(ds / 4, 4));
clr = {[29 194 88]/255, [239 135 6]/255, [53 154 188]/255, ...
       [233 203 0]/255, [115 24 156]/255};
sty = {'-x', '-x', '-x', '-+'};
snrs = 10.^[-1:1:6]';
Nsnr = numel(snrs);
snr = 10^2;
Nt = 8;
my_font = '/usr/share/fonts/truetype/dejavu/DejaVuSerifCondensed.ttf';
figdir = '~/ucsd/dissertation/dissertation/sections/ang_sync/figs/';
%figdir = strcat(pwd, '/');
figfil = strcat(figdir, 'sdp_vs_eig_time.pdf');

% To store the calculated taus and d's (different for each shift size)
edat = zeros(Nd, 2);
tdat = zeros(Nt, 2);

% Data parameters for the angular synchronization
ws_dat = struct('method', 'sdp');
we_dat = struct('method', 'eig');

% Calculate them...
for i = 1 : Nd
  d = ds(i);
  delta = deltas(i);
  A = tdelta(d, delta);
  for t = 1 : Nt
    x = complex(randn(d, 1), randn(d, 1));
    ux = sign(x);
    X = A .* (x * x');
    N = A .* complex(randn(d), randn(d));
    N = (N + N' - diag(diag(real(N)))) / 2;
    N = N * frob(X) / (frob(N) * snr);
    ws_dat.X = X+N;
    we_dat.X = X+N;
    tic;
    we_x = angsync(we_dat);
    tdat(t, 2) = toc;
    tic;
    ws_x = angsync(ws_dat);
    tdat(t, 1) = toc;
  end
  i
  edat(i, :) = mean(tdat, 1);
end
    
% plotit
% Set things up
close all;
h = figure(1);
hax = axes();
hold on
grid on
lw = 8;
ms = 12

% Do the plots
Nm = size(edat, 2);
handels = zeros(Nm, 1);
for i = 1 : Nm
  handels(i) = plot(log2(ds), log2(edat(:, i)), sty{i}, ...
		    'color', clr{i}, 'linewidth', lw, 'markersize', ms);
end

% Reset the tick marks logarithmically
xtm = get(hax).xtick;
xtstr = cell();
for i = 1 : numel(xtm)
  xtstr{i} = sprintf('2^{%d}', xtm(i));
end
set(hax, 'xtick', xtm);
set(hax, 'xticklabel', xtstr);
xlabel(hax, 'Ambient dimension d, (log scale)');

ytm = get(hax).ytick;
ytstr = cell();
for i = 1 : numel(ytm)
  ytstr{i} = sprintf('2^{%d}', ytm(i));
end
set(hax, 'yticklabel', ytstr);
ylabel(hax, 'Average execution time, (sec, log scale)');
 
% Do the legend
misc = struct();
misc.position = 'northeast';
misc.columns = 2;
strindels = {'Wt. SDP'; 'Wt. Eig'};
strindels = strindels(1:Nm);
hleg = my_leg2(handels, strindels, misc);

% Font stuff
FN = findall(h, '-property', 'FontName');
set(FN, 'FontName', my_font);
FS = findall(h, '-property', 'FontSize');
set(FS, 'FontSize', 14);

% Make a png!
print(h, '-color', figfil);

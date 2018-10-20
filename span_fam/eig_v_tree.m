% eig_v_tree
% Author: Brian Preskitt (2018)
%
% This file produces figure xxxx in my dissertation.

% General housekeepings
close all

% Set some constants
d = 32;
delta = 5;
s = 1;
clr = {[239 135 6]/255, [115 24 156]/255, ...
       [53 154 188]/255, [233 203 0]/255, [29 194 88]/255};
sty = {'-x', '-+', '-x', '-+'};
D = 2 * delta - 1;
snrs = 10.^[-1:1:6]';
Nsnr = numel(snrs);
Nt = 32;
my_font = '/usr/share/fonts/truetype/dejavu/DejaVuSerifCondensed.ttf';
figdir = '~/ucsd/dissertation/dissertation/sections/ang_sync/figs/';
figdir = strcat(pwd, '/');
figfil = strcat(figdir, 'eig_v_tree_%d_%d_%d.pdf');
figfil=  sprintf(figfil, d, delta, s);

% To store the calculated taus and d's (different for each shift size)
edat = zeros(Nsnr, 4);
tdat = zeros(Nt, 4);

% Data parameters for the angular synchronization
us_dat = struct('method', 'sdp');
ws_dat = struct('method', 'sdp');
ue_dat = struct('method', 'eig');
we_dat = struct('method', 'eig');

A = tdelta(d, delta, s);

% Calculate them...
for i = 1 : Nsnr
  snr = snrs(i);
  tic;
  for t = 1 : Nt
    x = complex(randn(d, 1), randn(d, 1));
    ux = sign(x);
    X = A .* (x * x');
    N = A .* complex(randn(d), randn(d));
    N = (N + N' - diag(diag(real(N)))) / 2;
    N = N * frob(X) / (frob(N) * snr);
    ws_dat.X = (X+N);
    we_dat.X = (X+N);
    us_dat.X = sign(X+N);
    ue_dat.X = sign(X+N);
    us_x = angsync(us_dat);
    ws_x = angsync(ws_dat);
    ue_x = angsync(ue_dat);
    we_x = angsync(we_dat);
    i, t

    tdat(t, 1) = thetadist(ux, us_x) / norm(ux);
    tdat(t, 2) = thetadist(ux, ue_x) / norm(ux);
    tdat(t, 3) = thetadist(ux, ws_x) / norm(ux);
    tdat(t, 4) = thetadist(ux, we_x) / norm(ux);
  end
  edat(i, :) = mean(tdat, 1);
  toc;
end
    
% plotit
% Set things up
close all;
h = figure(1);
hax = axes();
hold on
grid on
lw = 8;

% Do the plots
Nm = size(edat, 2);
handels = zeros(Nm, 1);
for i = 1 : Nm
  handels(i) = plot(log10(snrs), log10(edat(:, i)), sty{i}, ...
		    'color', clr{i}, 'linewidth', lw);
end

% Reset the tick marks logarithmically
xtm = get(hax).xtick;
xtstr = cell();
for i = 1 : numel(xtm)
  xtstr{i} = sprintf('10^{%d}', xtm(i));
end
set(hax, 'xtick', xtm);
set(hax, 'xticklabel', xtstr);
xlabel(hax, 'SNR, (log scale)');

ytm = get(hax).ytick;
ytstr = cell();
for i = 1 : numel(ytm)
  ytstr{i} = sprintf('10^{%d}', ytm(i));
end
set(hax, 'yticklabel', ytstr);
ylabel(hax, 'Relative error in phase estimation');

% Plot the theoretical bound, JFF
bound = (frob(A) ./ snrs) / taug(d, delta, s);
handels(end+1) = plot(log10(snrs(4:end)), log10(bound(4:end)), ...
		      'k--', 'linewidth', lw);
 
% Do the legend
misc = struct();
misc.position = 'southwest';
misc.columns = 2;
strindels = {'Unw. SDP'; 'Unw. Eig'; 'Wt. SDP'; 'Wt. Eig'; 'Theo. Bnd'};
hleg = my_leg2(handels, strindels, misc);

% Font stuff
FN = findall(h, '-property', 'FontName');
set(FN, 'FontName', my_font);
FS = findall(h, '-property', 'FontSize');
set(FS, 'FontSize', 14);

% Make a png!
print(h, '-color', figfil);

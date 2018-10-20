function [hleg, htext, hline] = my_leg2(elems, strings, misc)
  % hleg = my_leg2(elems, strings, position, wpos)
  % == INPUTS ==
  % 'elems' should be a vector of handles to line objects for which you want
  % to make legend entries.
  % 'strings' is a cell object whose entries are the strings you want to
  % be the legend labels.
  % 'misc' is a struct containing among the following:
  % * 'position' is a string containing a compass direction
  %   ("northeast", "west", etc) or a vector with coordinates for bottom-left
  %   corner of the legend.  In... normalized?  Defaults to NE.
  % * 'wpos' should represent the normalized size of the window into which
  %   you want this puppy to go.  Defaults to default plot axis size.
  % * 'columns' is the number of columns you want.
  % == OUTPUTS ==
  % Returns a handle for the legend object, the text objects inside, and
  % the line objects inside.

  % Make sure there are no more strings than objects
  if ischar(strings)
    strings = {strings};
  end
  assert(numel(elems) >= numel(strings));
  n = numel(elems);

  % Enforce defaults
  if ~exist('misc')
    misc = struct();
  end
  if ~isstruct(misc)
    misc = struct();
  end
  if ~isfield(misc, 'position')
    position = 'northeast';
  else
    position = misc.position;
  end
  if ~isfield(misc, 'columns')
    columns = 1;
  else
    columns = misc.columns;
  end
  if ~isfield(misc, 'wpos')
    % If you just do a straight up plot, these demark the axes object.
    wpos = [0.13 0.11 0.775 0.815];
    %wpos = [0 0 1 1];
  else
    wpos = misc.wpos;
  end
  if ischar(wpos)
    if strcmp(wpos, 'colorbar')
      wpos = [0.13, 0.11, 0.62, 0.815];
    else
      wpos = [0.13 0.11 0.775 0.815];
    end
  end

  % If there are more elements, make filler strings
  if numel(strings) <= n
    temp = strings;
    strings = cell(n, 1);
    for i = 1 : numel(temp)
      strings{i} = temp{i};
    end
    for i = numel(temp) + 1 : n
      strings{i} = sprintf("Data %d", i);
    end
  end

  % Zero out some necessary data elements...
  htext = zeros(n, 1);		% Packs text obj handles
  hline = zeros(n, 1);		% "     line  "  "
  xext = zeros(n, 1);		% Size of text obj's in x direction
  yext = zeros(n, 1);		% " " " " " y "
  % Make the axis object which is the legend.  Deactivate tickmarks.
  hleg = axes("position", [0 0 .2 .2], "units", "inches");
  set(hleg, "xtick", [], "ytick", []);
  set(hleg, "xlim", [0 1], "ylim", [0 1]);

  % Make the text and line objects.
  for i = 1 : n
    htext(i) = text(0.1, 0.1, strings{i});
    set(htext(i), "units", "inches");
    xext(i) = get(htext(i)).extent(3);    % Record the "extent" entries to 
    yext(i) = get(htext(i)).extent(4);    % calculate size of legend later

    % Build the line objects
    ldat = get(elems(i));
    % ndat = [];
    assert(strcmp(ldat.type, "line")) % strcmp(a, b) is true if a == b
    if strcmp(ldat.linestyle, "none")
      % ndat.xdata = .25;	      % single point for marker only
      % ndat.ydata = 1;	      % ydata is constant, will multiply later
      xdata = .25;
      ydata = 1;
    else
      % ndat.xdata = [.1 .4];   % Two points for line
      % ndat.ydata = [1 1];     % ydata is constant, will multiply later
      xdata = [.1 .4];   % Two points for line
      ydata = [1 1];     % ydata is constant, will multiply later
    end
    % Read out some other necessary data
    % ndat.linestyle = ldat.linestyle;
    % ndat.marker = ldat.marker;
    % ndat.linewidth = ldat.linewidth;
    % ndat.markersize = ldat.markersize;
    % ndat.color = ldat.color;
    hline(i) = line(hleg,
		    "linestyle", ldat.linestyle,
		    "marker", ldat.marker,
		    "linewidth", ldat.linewidth,
		    "markersize", ldat.markersize,
		    "color", ldat.color);
  end

  % Constants used for size determination
  ypad = 0.1;
  xpad = 0.2;
  mintextwidth = 0.5;
  linespace = 0.5;
  lpos_ratio = [0.2 0.5 0.8];
  mpos_ratio = 0.5;
  colpad = xpad;
  % Allocation for the text
  ny = ceil(n / columns);
  yext = [yext; zeros(ny * columns - n, 1)];
  yext = reshape(yext, ny, columns);
  twidth = max(max(xext), mintextwidth) + xpad * 2;
  ywidth = max(sum(yext, 1)) + ypad * (ny + 1);
  % Position of line elements within legend
  lpos = linespace * lpos_ratio;
  mpos = linespace * mpos_ratio;
  % Set size of the legend object
  set(hleg, "units", "inches");
  set(hleg, "position", [0, 0, (twidth + linespace)*columns, ywidth]);
  % Position the text and line elements within the legend
  for i = 1 : n
    col = floor((i - 1) / ny) + 1;
    row = mod(i - 1, ny) + 1;
    colspace = (twidth + linespace) * (col - 1);
    ypos = ywidth - ypad * row - (sum(yext(1:row-1, col)) + yext(i) / 2);
    set(htext(i), "position", [colspace+linespace+xpad, ypos]);
    set(htext(i), "units", "normalized");
    ldat = get(hline(i));
    if strcmp(get(hline(i), "linestyle"), "none")
      set(hline(i), "ydata", ypos / ywidth);
      set(hline(i), "xdata", ((col-1)+mpos) / columns);
    else
      set(hline(i), "ydata", [1, 1, 1] * ypos / ywidth);
      set(hline(i), "xdata", ((col-1)+lpos) / columns);
    end
  end

  % Normalize the axes and get the dimensions.
  set(hleg, "units", "normalized");
  xlen = get(hleg).position(3);
  ylen = get(hleg).position(4);
  xlpos = wpos(1) + wpos(3) / 2 - xlen / 2;
  ylpos = wpos(2) + wpos(4) / 2 - ylen / 2;
  % Constants describing margins for compass stuff
  ns_margin = 0.02;
  ew_margin = 0.02;

  if ischar(position)
    position = lower(position);
    if strfind(position, "north")
      ylpos = wpos(2) + wpos(4) - ylen - ns_margin;
    elseif strfind(position, "south")
      ylpos = wpos(2) + ns_margin;
    end
    if strfind(position, "west")
      xlpos = wpos(1) + ew_margin;
    elseif strfind(position, "east")
      xlpos = wpos(1) + wpos(3) - ew_margin - xlen;
    end
  else
    xlpos = position(1);
    ylpos = position(2);
  end

  set(hleg, "position", [xlpos, ylpos, xlen, ylen]);

function k = argmin(a, dim)
  % k = argmin(a, dim)
  % Returns position of minimum element of 'a'.  If 'dim' is omitted,
  % minimizes over the entire array.  Otherwise, dim should specify
  % the dimension over which you want to minimize.
  
  if ~exist('dim')
    [~, k] = min(a(:));
    if or(ndims(a) > 2, min(size(a)) ~= 1)
      [aa, bb] = ind2sub(size(a), k);
      k = [aa, bb];
    end
  else
    [~, k] = min(a, [], dim);
  end
end

function r = realify(x, vecs)
 
  if ~exist('vecs')
    vecs = 1;
  end

  if ~vecs
    r = zeros(size(x) * 2);
    r(1:2:end, 1:2:end) = real(x);
    r(2:2:end, 2:2:end) = real(x);
    r(1:2:end, 2:2:end) = -imag(x);
    r(2:2:end, 1:2:end) = imag(x);
  else
    r = zeros(2 * size(x, 1), size(x, 2));
    r(1:2:end, :) = real(x);
    r(2:2:end, :) = imag(x);
  end

  
    
    

    
    

  

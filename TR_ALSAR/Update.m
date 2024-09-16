function U = Update(Z, r, k)
if k == d
U = randn(r(k), I(k), r(1));
U(1:r(k), 1:I(k),1:r(1)) = Z{k};
else 
U = randn(r(k), I(k), r(k+1));
U(1:r(k), 1:I(k), 1:r(k+1)) = Z{k};
end

% Goal: Update nhung tensor da khoi tao duoc 

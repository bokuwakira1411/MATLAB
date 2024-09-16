function LU = left_unfolding(U)
[l,c,r] = size(U);
LU = reshape(U,[l*c,r]);
end


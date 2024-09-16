function RU = right_unfolding(U)
[l,c,r] = size(U);
RU = reshape(U,[l,r*c]);
end

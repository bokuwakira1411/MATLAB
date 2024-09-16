function T = modek_unfolding(U,k)
I = size(U);
d = length(I);
set = [k k+1:d 1:k-1];
T = permute(U,set);
T = reshape(T,[I(k), prod(I)/I(k)]);
end

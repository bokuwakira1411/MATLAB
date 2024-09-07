function U = main(T, e)
I = size(T);
d = length(I);
ep = [];
E = {};
r = [];
U = {};
ep(1) = sqrt(2)*e*norm(T)/sqrt(d);
for i = 2 to d:
    ep(i) = e*norm(T)/sqrt(d);
end

T_1 = unfolding_1(T);
[u,s,v] = svd(T_1);
E(1) = T_1 - u*s*v';
T_1_truncated = max(T_1, ep(1));

r(1) = rkrk_1(T_1_truncated);
r(2) = rank(T_1_truncated)/r(1);

U(1) = permute(reshape(u,[I(1),r(1), r(2)]), [2,1,3]);
M = permute(reshape(s*v', [r(1),r(2),prod(I(2:d))]), [2,3,1]);

for k = 2 to d-1:
    M = reshape(M,[r(k)*I(k), prod(I(k:d))*r(1)]);
    [u,s,v] = svd(M);
    E(k) = M - u*s*v';
    M = max(M,ep(k));
    r(k+1) = rank(M)/r(k);
    U(k) = reshape(u,[r(k),I(k),r(k+1)]);
    M =  reshape(s*v', [r(k+1), prod(I(k+1:d)),r(1)]);
end
end




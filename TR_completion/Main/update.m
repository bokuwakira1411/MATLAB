function U = update(T,R,r)
I = size(T);
U = {};
d = length(I);
%% canonical_matricization X1
A = [];
for i = 1:1:I(1)
    A = [A tens2vec(T(i,:,:,:))];
end
A = A';

%% SVD _ truncated by R 
% U1
[u,s,v] = svd(A);
u = u(:, 1:R(1));
s = s(1:R(1), 1:R(1));
v = v(:, 1:R(1));
m = s*v';
U{1} = reshape(u, [1, size(u)]);
%% repeat for i = 2 to n-1
for i = 2:1:d-1
    A = reshape(m,R(i-1) * I(i), prod(I(i+1: d))); 
    [u,s,v] = svd(A);
    u = u(:, 1:R(i));
    s = s(1:R(i), 1:R(i));
    v = v(:, 1:R(i));
    m = s*v';
    U{i} = reshape(u, [R(i-1), I(i), R(i)]);
end
U{d} = m;
%Update U1
Ut = randn(r(d), I(1), r(1));
Ut(1:size(U{1},1), 1:size(U{1},2), 1:size(U{1},3)) = U{1};
U{1} = Ut;

%Update U2 to Ud-1
for i=2:d-1
    Ut = randn(r(i-1), I(i), r(i));
    Ut(1:R(i-1), 1:I(i), 1:R(i)) = U{i};
    U{i} = Ut;
end
%update Ud
Ut = randn(r(d-1), I(d), r(d));
Ut(1:size(U{d},1), 1:size(U{d},2), 1:size(U{d},3)) = U{d};
U{d} = Ut;
end


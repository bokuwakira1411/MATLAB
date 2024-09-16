function Z = Initialize(T,r)
I = size(T);
d = length(I);
Z = {};
r(d+1) = r(1);
for i=1:1:d
    Z{i} = randn(r(i),I(i),r(i+1));
end
end

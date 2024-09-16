function n = norm_F(T)
v = tens2vec(T);
s = 0;
d = size(v);
for i = 1:1: d(1)
    s = s + v(i)^2;
end
n = sqrt(s);
end

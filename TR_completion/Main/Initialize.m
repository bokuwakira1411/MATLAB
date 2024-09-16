function Z = Initialize(T,r)
Z = {};
R = [];
I = size(T);
temp = 1;
d = length(I);
%Update R
%R(i) = min(r(i),I(i)*R(i-1), I(i+1) *....* I(n) 
for i = 1:1:d-2
    t = 1;
    for j = i+1:1:d-1
        t = t*I(j);
    end
    R(i) = min(r(i), min(I(i) * temp, t));
    temp = R(i);
end
R(d-1)= min(min(temp*I(d-1), r(d-1)),I(d));
Z = update(T,R,r);
end


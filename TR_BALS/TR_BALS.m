function Z = TR_BALS(T,ep)
I = size(T);
d = length(I);
r = [];
sigma = 0.1;
for i = 1:1:d
    r(i) = 1;
end
Z = Initialize(T,r);
e = 1000;
k = 1;
while e > ep
    if k > d
        k = 1;
    end
    
        A{k} = subchain_diff_k_k1(Z,k);
        temp = modek_unfolding(A{k},2);
        dummy = modek_unfolding(T,k) / temp';
        if k ~= d
           dummy = dummy ./ sum(dummy, 1);
        end
        if k+1 > d 
            r(k+2) = r(2);
            r(k+1) = r(1);
            I(k+1) = I(1);
        end
        Z_dummy = permute(reshape(dummy,[I(k)*I(k+1),r(k),r(k+2)]),[2,1,3]); 
        Z_dummy = reshape(Z_dummy,[r(k)*I(k), I(k+1)*r(k+2)]);
        Z_dummy(Z_dummy < sigma) = 0; 
        [u,s,v] = svd(Z_dummy);
        
        Z{k} = reshape(u,[r(k), I(k), r(k+1)]);
        Z{k+1} = reshape(s*v', [r(k+1), I(k+1), r(k+2)]);
        r(k+1) = rank(Z_dummy)/r(k);
        k = k+1;
end
disp(e);
end

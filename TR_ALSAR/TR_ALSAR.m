function Z = TR_ALSAR(T,ep)
I = size(T);
d = length(I);
r = [];
for i = 1:1:d
    r(i) = 1;
end
Z = Initialize(T,r);
e = 10;
dummy_2 = [];
while e >= ep
    for k=1:1:d
        e_old = 1;
        e_new = 2;
        while e_old >= e_new
        A{k} = subchain_diff_k(Z,k);
        temp = modek_unfolding(A{k},2);
        dummy_1 = modek_unfolding(T,k) / temp';
        e_old = norm(modek_unfolding(T,k)- dummy_1*temp');
        r(k+1) = r(k+1)+1;
        Z{k+1} = Update(Z,r,k+1);
        A{k} = subchain_diff_k(Z,k);
        temp = modek_unfolding(A{k},2);
        dummy_2 = modek_unfolding(T,k) / temp';
        e_new = norm(modek_unfolding(T,k)- dummy_2*temp');
        end
        disp(e_new);
        if k ~= d
                dummy_2 = dummy_2 ./ sum(dummy_2, 1);
        end
        if k == d 
            Z{k} = permute(reshape(dummy_2,[I(k),r(k),r(1)]),[2,1,3]);
        else
            Z{k} = permute(reshape(dummy_2,[I(k),r(k),r(k+1)]),[2,1,3]);
        end
        
    end
    dummy = mat2tens(Z,1,I);
    e = norm(T(:) - dummy(:))/norm(T(:));
end
end

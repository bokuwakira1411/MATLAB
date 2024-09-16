function Z = TR_ALS_basic(T,r, threshold)
Z = Initialize(T,r);
A = {}; % subchain Z i!= k
e = 1000;
d = size(r,2);
I = size(T);
while e >= threshold
    for k=1:1:d
        A{k} = subchain_diff_k(Z,k);
        temp = modek_unfolding(A{k},2);
        dummy = modek_unfolding(T,k) / temp';
            if k ~= d
                dummy = dummy ./ sum(dummy, 1);
            end
            if k == d 
                Z{k} = permute(reshape(dummy,[I(k),r(k),r(1)]),[2,1,3]);
            else
                Z{k} = permute(reshape(dummy,[I(k),r(k),r(k+1)]),[2,1,3]);
            end
            dummy = mat2tens(Z,1,I);
            e = norm(T(:) - dummy(:))/norm(T(:));
    end
end
disp(e)
end

             
        
        
        
        
        
        
            
        


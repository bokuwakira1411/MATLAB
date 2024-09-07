function min_r = rkrk_1(T)
min_r = 1;
min_val = 100;
for i=1:1:rank(T)
    if abs(i- rank(T)/i) < min_val && isinteger(abs(i- rank(T)/i))
        min_val = abs(i - rank(T)/i);
        min_r = i;
    end
end

     
    
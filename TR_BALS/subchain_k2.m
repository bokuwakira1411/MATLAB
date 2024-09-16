function T = subchain_k2(Z,k)
t = k:size(Z,2);
T = 1;
for i = 1:1:length(t)
    if i ==1
        T = left_unfolding(Z{t(i)}) * right_unfolding(Z{t(i+1)});
        [R1,I1,~] = size(Z{t(i)});
        [~,I2,R4] = size(Z{t(i+1)});
        T = reshape(T, [R1,I1*I2,R4]);
     elseif length(t) >2 && i < length(t)
        temp = T;
        T = left_unfolding(T) * right_unfolding(Z{t(i+1)});
        [R1,I1,~] = size(temp);
        [~,I2,R4] = size(Z{t(i+1)});
        T = reshape(T, [R1,I1*I2,R4]);
    end
end
end

    
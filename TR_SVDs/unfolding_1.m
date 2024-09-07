function T_1 = unfolding_1(T)
n = size(T,1);
T_1 = [];
for i = 1:n
    T_1 = [T_1 tens2vec(T(i,:,:))];
end
end

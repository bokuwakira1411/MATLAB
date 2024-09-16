function T = tensor_connect_product(U)
    T = U{1};
    for i =2:1:length(U)
        [lT, cT, ~] = size(T);
        [~, cU, rU] = size(U{i});
        T = reshape(left_unfold(T) * right_unfold(U{i}), [lT, cT*cU, rU]);
    end
end
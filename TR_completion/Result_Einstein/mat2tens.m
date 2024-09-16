function tensor = mat2tens(mat, sizes, mode_order, remain_order)
tensor = reshape(mat, sizes);

    % S?p x?p l?i c�c chi?u c?a tensor theo th? t? mong mu?n
    % K?t h?p mode_order v� remain_order �? t?o th? t? m?i
    new_order = [mode_order, remain_order];
    tensor = permute(tensor, new_order);
end

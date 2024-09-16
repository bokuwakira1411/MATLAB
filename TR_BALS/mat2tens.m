function T = mat2tens(Z,k,I)
A = classical_modek_unfolding(subchain_k1(Z,k),2);
B = modek_unfolding(subchain_k2(Z,k+1),2);
T = reshape(A*B',I);
end


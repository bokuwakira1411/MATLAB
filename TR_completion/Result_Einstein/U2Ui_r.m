%TT decomposition
function Ui = U2Ui_r(U,r)
%Input:
% U: I1 * I2 *....*In (tensor ban ð?u)
% r: r1, r2,... , rn-1 (tensor train rank)
%Output:
%Ui: {U1,..., Un} m?i Uj là m?t tensor 3-mode
n = size(U);
dim = size(n,2);
Ui = cell(dim, 1); % t?o thành các cell array kích thý?c dim*1 có th? lýu b?t k? ki?u d? li?u g? vào 1 cell array
% Khoi tao B, luu tru tat ca cac gia tri tensor U chieu dau tien
B = [];
for i = 1:1:n(1)               % L?p t? 1 ð?n n(1): kích thý?c chi?u th? nh?t c?a tensor U
    B = [B T2V(U(i,:,:,:))];   % U(i,:,:,:): L?y lát(slice)c?a tensor U t?i ch? s? i ? chi?u ð?u tiên. Sau ðó k?t qu? B n?i vào T2V(hàm chuy?n tensor thành vector))
end
B = B';

[u, s, v] = svd(B,'econ');
%Muc tieu truncated SVD
u = u(:, 1:r(1));       % lay r(1) cot dau tien cua matrix u
s = s(1: r(1), 1:r(1)); % Lay diagonal matrix size r(1) * r(1)
v = v(:, 1:r(1));       % Lay r(1) cot dau tien cua matrix u
v = s*v';               % don het tat ca vao v

%  Chuyen tu u SVD -> Ui{i}
Ui{1} = reshape(u, [1, size(u)]);

%main loop
for i = 2 : 1 : dim - 1
    B = reshape(v, [r(i - 1) *n(i), prod(n(i + 1: end))]);
    [u,s,v] = svd(B, 'econ');
    u = u(:,1:r(i));
    Ui{i} = reshape(u, [r(i-1), n(i), r(i)]);
    s = s(1:r(i), 1:r(i));
    v = v(:, 1:r(i));
    v = s*v';
end
Ui{i+1} = v;
end

% Khoi tao xong U2Ui theo r yeu cau



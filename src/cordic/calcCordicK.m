%{
calculate cordic K
@W: the bit width
%}
function K = calcCordicK(W)
    G = 1;
    for i = 0:W-1
        G = G*sqrt(1+2^(-2*i));
    end 
    K = 1/G;
end
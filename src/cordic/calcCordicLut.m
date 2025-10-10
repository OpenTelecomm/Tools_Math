%{
generate the LUT for cordic
@W: the bit width
%}
function LUT_CORDIC = calcCordicLut(W)
    P = W;                                                  % precision, i.e., the number of bits for the fractional
    bfxp0 = quantizer('fixed', 'round', 'saturate', [P, 0]);

    ANG_FULL = bitshift(1, P);

    LUT_CORDIC = zeros(P, 1);
    for i = 0:P-1
        tmp = atan(2^-i);
        tmp = tmp / (2*pi) * ANG_FULL;
        LUT_CORDIC(i+1) = quantize(bfxp0, tmp);
    end
end
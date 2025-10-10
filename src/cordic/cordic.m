%{
cordic
@ang:       sQ(P+1, P), the angle without 2pi, i.e., 2*pi*ang is the true radian angle
@P:         precision, i.e., the number of bits on the fractional
%}
function [ang_cos, ang_sin] = cordic(ang, P)
    W = P + 1;                                  % width, i.e., the total number of bits (W = P+1)
    bfxp0 = quantizer('fixed', 'round', 'saturate', [W, P]);

    % constants
    K = 0.6072529350088814;                     % the reverse of the gain
    ANG_FULL = bitshift(1, P);
    ANG_HALF = bitshift(ANG_FULL, -1);
    ANG_QUART = bitshift(ANG_FULL, -2);
    LUT_ATAN = calcCordicLut(P);                % the atan table for cordic

    ang = floor(ang * 2^P);                     % integerize the angle
    if ang < ANG_QUART
        % quadrant 1
        sign_cos = 1;
        sign_sin = 1;
        ang_prime = ang;
    elseif ang < ANG_HALF
        % quadrant 2
        sign_cos = -1;
        sign_sin = 1;
        ang_prime = ANG_HALF - ang;
    elseif ang < ANG_HALF + ANG_QUART
        % quadrant 3
        sign_cos = -1;
        sign_sin = -1;
        ang_prime = ang - ANG_HALF;
    else
        % quadrant 4
        sign_cos = 1;
        sign_sin = -1;
        ang_prime = ANG_FULL - ang;
    end

    % rotate
    x = K;
    y = 0.0;
    z = ang_prime;
    for i = 0:P-1
        if z >= 0
            x_new = x - y * 2^(-i);
            y_new = y + x * 2^(-i);
            z = z - LUT_ATAN(i+1);
        else
            x_new = x + y * 2^(-i);
            y_new = y - x * 2^(-i);
            z = z + LUT_ATAN(i+1);
        end
        x = x_new;
        y = y_new;
    end

    % move the correct quadrant
    ang_cos = sign_cos * x;
    ang_sin = sign_sin * y;
end
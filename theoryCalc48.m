% Calculates the theoretical voltage values at each electrode given
% the positive stim electrode number, negative stim electrode number,
% current in amps, and a given resistivity value
function A = theoryCalc48(plusStim , negStim, I, rho) 

% convert positive stim electrode number to x, y
sx1 = rem(plusStim , 8);
if (sx1 == 0)
    sx1 = 8;
    sy1 = fix(plusStim ./ 8);
else
    sy1 = fix(plusStim ./8 ) + 1;
end

% convert negative stim electrode number to x, y
sx2 = rem(negStim , 8);
if (sx2 == 0)
    sx2 = 8;
    sy2 = fix(negStim ./ 8);
else
    sy2 = fix(negStim ./ 8) + 1;
end

% V(r) = A(1/r1 - 1/r2)
% interates over all electrodes calculating theoretical voltages for each
A = zeros(48 , 1);
for i = 1:48
    
    % translate electrode number to x, y
    x = rem(i , 8);
    if (x == 0)
        x = 8;
        y = fix(i ./ 8);
    else
        y = fix(i ./ 8) + 1;
    end

    % x,y differences from positive and negative electrodes
    rx1 = sx1 - x;
    ry1 = sy1 - y;
    rx2 = sx2 - x;
    ry2 = sy2 - y;
    
    % distance to positive electrode
    r1 = sqrt(rx1^2 + ry1^2);
    
    % distance to negative electrode
    r2 = sqrt(rx2^2 + ry2^2);
    
    % final voltage based on a given resistivity and current
    A(i, 1) = ( (1.75e-3 * rho) / (2*pi) ) * ( (100/r1) - (100/r2) );
end
end
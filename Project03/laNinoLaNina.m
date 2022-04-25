function dTdt = laNinoLaNina(coeffs,t,y,Z)
    alpha = coeffs(1);
    beta  = coeffs(2);
    gamma = coeffs(3);
    kappa = coeffs(4);
    dTdt = lNLN(t,y,Z);
    function dTdt = lNLN(t,y,Z)
        %dTdt = -alpha*tanh(kappa*Z(1,1)) + beta*tanh(kappa*Z(1,2)) + gamma*cos(2*pi*t);
        dTdt = -alpha*Z(1) + y - y^3;
        %dTdt = -alpha*Z(1) + y;
    end
end

% function dTdt = laNinoLaNina(t,y,Z)
%     alpha = 1;
%     beta = 0;
%     gamma = 1;
%     kappa = 10;
%     dTdt = -alpha*tanh(kappa*Z(1,1)) + beta*tanh(kappa*Z(1,2)) + gamma*cos(2*pi*t);
%     %dTdt = -alpha*Z(1) + y - y^3;
%     %dTdt = -alpha*Z(1) + y;
% end
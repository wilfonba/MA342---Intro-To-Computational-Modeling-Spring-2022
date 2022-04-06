function [dTdt] = laNinoLaNina(t,y,Z)
    alpha = 1.2;
    beta  = 1;
    gamma = 1;
    kappa = 10;
    
    %dTdt = -alpha*tanh(kappa*Z(1,1)) + beta*tanh(kappa*Z(1,2)) + gamma*cos(2*pi*t);
    dTdt = -alpha*Z(1) + y - y^3;
    %dTdt = -alpha*Z(1) + y;
end
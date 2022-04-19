
% Constant parameters from 382 in book
tau = 10;
alpha = 0.3095;
beta = 0.2;
rho = 1174.17;
epsilon = 0.0063;
d =3.9139e-5;

sol = ddesd(@ddex1de,[tau],[30e6;30;28;0],[0, 150]);
sol2 = dde23(@ddex1de,[tau],[30e6;30;28;0],[0, 150]);
sol1 = dde23(@calcDP,[tau],[30e6;30;28],[0, 200]);
figure;
plot(sol.x,sol.y)
title('H1N1 testing');
xlabel('time t');
ylabel('solution y');
legend('Susceptible','Infected','Recovered','Infection Rate')
axis
figure;
plot(sol2.x,sol2.y)

function s = ddex1hist(t)
% Constant history function for DDEX1.
s = [30e6;30;28];
end

function dydtOrig = ddex1de1(t,y,Z)
    alpha = 0.3095;
beta = 0.2;
rho = 1174.17;
epsilon = 0.0063;
d =3.9139e-5;
yLag1 = Z(1,1);
u=0.02;
N=y(1)+y(2)+y(3);
dydtOrig = [
        rho-alpha*y(1)*y(2)/N+d*y(1)-u*yLag1;
        alpha*y(1)*y(2)/N-(beta+d+epsilon)*y(2);
        beta*y(2)-d*y(3)+u*yLag1;
        ];
end
function dydt = ddex1de(t,y,Z)
alpha = 0.3095;
beta = 0.2;
rho = 1174.17;
epsilon = 0.0063;
d =3.9139e-5;
yLag1 = Z(1,1);
yLag2 = Z(4,1);
u=0.02;
N=y(1)+y(2)+y(3);
dydt = [
        rho-alpha*y(1)*y(2)/N+d*y(1)-u*yLag1;
        y(4)-yLag2;
        beta*y(2)-d*y(3)+u*yLag1;
        alpha*y(1)*y(2)/N-(beta+d+epsilon)*y(2);
        ];
end

function [dP] = calcDP(t, P, Pdel)
u = 0.01;
Gamma = 1174.17;
beta = 0.3095;
d = 3.9139*10^(-5);
eps = 0.0063;
gamma = 0.2;
dP = zeros(3,1);
N = P(1)+P(2)+P(3);
dP(1) = Gamma - beta*P(1)*P(2)/N - u*Pdel(1,1);
dP(2) = beta*P(1)*P(2)/N - (gamma+d+eps)*P(2);
dP(3) = gamma*P(2) - d*P(3) + u*Pdel(1,1);
end
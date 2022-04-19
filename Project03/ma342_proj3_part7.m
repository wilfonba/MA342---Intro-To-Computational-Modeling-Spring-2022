% MA342 
% Project 3

clc; close all; clear variables;

lag = 1;
tspan = [0,5];
history = [50; 20; 10; 0];

sol = ddesd(@dNdp_func,lag,history,tspan);

figure(1)
plot(sol.x,sol.y(1,:),'r-',sol.x,sol.y(2,:),'b-',sol.x,sol.y(3,:),'k-')
legend('Node 1','Node 2','Node 3')



function [dNdt] = dNdp_func(t,N,Ndel)
PE = 1;         %Process efficiency
dNdt = zeros(4,1);
N_share = zeros(4,1);

% Packets Shared by the Nodes
for index = 1:length(N)-1
    if N(index) > 30
        if index == 1
            N_share(index) = Ndel(index+1) - Ndel(index) + Ndel(length(N)-1)-N(index);
        elseif index == length(N)-1
            N_share(index) = Ndel(index-1) - Ndel(index) + Ndel(1) - Ndel(index);
        else
            N_share(index) = Ndel(index-1) + Ndel(index) + Ndel(index+1) - Ndel(index);
        end
    else
        N_share(index) = 0;
    end
end


% Packets Processed by the Nodes
Total_P = N(1)+N(2)+N(3)+N(4);      %Total number of packets
dNdt(1) = PE*(N(4)/Total_P-N(1)) + N_share(1) - N_share(2) - N_share(3);
dNdt(2) = PE*(N(4)/Total_P-N(2)) + N_share(2) - N_share(1) - N_share(3);
dNdt(3) = PE*(N(4)/Total_P-N(3)) + N_share(3) - N_share(1) - N_share(2);
dNdt(4) = -1*dNdt(1)-1*dNdt(2)-1*dNdt(3);
end
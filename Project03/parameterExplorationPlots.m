clc;clear;close all;

clc;
T = load("laNinoLaNinaData.csv");
% remove years from T
years = T(:,1);
T(:,1) = [];

% reshape for cubic splines
years = years - years(end,1);
tHist = (years(1):(1/12):years(end)+11/12)-1;  
tHist = tHist';
Ts = zeros(length(tHist),1);
for i = 1:length(years)
    Ts((i-1)*12+1:i*12,1) = T(i,:)';
end
TsZero = interp1(tHist,Ts,0,'pchip','extrap');
tHist = [tHist; 0];
Ts = [Ts;TsZero];

figure('position',[50 50 1400 700]);
tspan = [0 10];

cSol =[1 0 1 100 0.01 0;
        1 0 1 100 0.15 0;
        1 0 1 100 0.995 0;
        1 1 1 10 0.9 0.1;
        1.2 0.8 1 10 0.6 0.6];

tHist(end-25:end) = [];
Ts(end-25:end) = [];
tHist = tHist+2;
poly = spline(tHist,Ts);
subplot(2,2,1);hold on;
for i = 1:5
    tau1  = cSol(i,5);
    tau2  = cSol(i,6);
    coeffs = cSol(i,1:4);  %alpha,beta,gamma,kappa

    lags = [tau1,tau2];
    

    sol = ddesd(@(t,y,z) laNinoLaNina(coeffs,t,y,z),lags,@(t) ppval(poly,t),tspan);

    plot(sol.x + max(abs(tHist))+1871,sol.y,'linewidth',1);hold on;
    xlim([sol.x(1)+1871+max(abs(tHist)), sol.x(1)+1871+max(abs(tHist))+10]);
end
xlabel("Year");
ylabel("T(t)");
title("2020")
%legend({'1','2','3','4','5'},'location','southoutside','orientation','horizontal','fontsize',16);

subplot(2,2,2);hold on;
tHist(end-12*45+1:end) = [];
Ts(end-12*45+1:end) = [];
tHist = tHist+45;
poly = spline(tHist,Ts);
for i = 1:5
    tau1  = cSol(i,5);
    tau2  = cSol(i,6);
    coeffs = cSol(i,1:4);  %alpha,beta,gamma,kappa

    lags = [tau1,tau2];
    

    sol = ddesd(@(t,y,z) laNinoLaNina(coeffs,t,y,z),lags,@(t) ppval(poly,t),tspan);

    plot(sol.x + max(abs(tHist))+1871,sol.y,'linewidth',1);hold on;
    xlim([sol.x(1)+1871+max(abs(tHist)), sol.x(1)+1871+max(abs(tHist))+10]);
end
xlabel("Year");
ylabel("T(t)");
title("1975")
%legend({'1','2','3','4','5'},'location','southoutside','orientation','horizontal','fontsize',16);

subplot(2,2,3);hold on;
tHist(end-12*50+1:end) = [];
Ts(end-12*50+1:end) = [];
tHist = tHist+50;
poly = spline(tHist,Ts);
for i = 1:5
    tau1  = cSol(i,5);
    tau2  = cSol(i,6);
    coeffs = cSol(i,1:4);  %alpha,beta,gamma,kappa

    lags = [tau1,tau2];
    

    sol = ddesd(@(t,y,z) laNinoLaNina(coeffs,t,y,z),lags,@(t) ppval(poly,t),tspan);

    plot(sol.x + max(abs(tHist))+1871,sol.y,'linewidth',1);hold on;
    xlim([sol.x(1)+1871+max(abs(tHist)), sol.x(1)+1871+max(abs(tHist))+10]);
end
xlabel("Year");
ylabel("T(t)");
title("1925")
%legend({'1','2','3','4','5'},'location','southoutside','orientation','horizontal','fontsize',16);

subplot(2,2,4);hold on;
tHist(end-12*50+1:end) = [];
Ts(end-12*50+1:end) = [];
tHist = tHist+50;
poly = spline(tHist,Ts);
for i = 1:5
    tau1  = cSol(i,5);
    tau2  = cSol(i,6);
    coeffs = cSol(i,1:4);  %alpha,beta,gamma,kappa

    lags = [tau1,tau2];
    

    sol = ddesd(@(t,y,z) laNinoLaNina(coeffs,t,y,z),lags,@(t) ppval(poly,t),tspan);

    plot(sol.x + max(abs(tHist))+1871,sol.y,'linewidth',1);hold on;
    xlim([sol.x(1)+1871+max(abs(tHist)), sol.x(1)+1871+max(abs(tHist))+10]);
end
xlabel("Year");
ylabel("T(t)");
title("1875")
legend({'1','2','3','4','5'},'location','southoutside','orientation','horizontal','fontsize',16);
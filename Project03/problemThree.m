clc;clear;close all;
predictTime = 2;
%% Read and organize data files
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

%% Optimize With Constrained Optimization
x0 = [1 15 0.5 2.5 2.5 2.5];
lb = [0;1;0;0;0;0];
up = [20,20,15,5,5,50];
options = optimoptions(@fmincon,'TolX',1e-8,'display','iter','UseParallel',false);
[cSol,fVal] = fmincon(@(V) elNinoLaNinaOpt(V,Ts,tHist,predictTime),x0',[],[],[],[],lb,up,[],options);
%options = optimoptions(@simulannealbnd,'display','iter');
%[cSol,fVal] = simulannealbnd(@(V) elNinoLaNinaOpt(V,Ts,tHist,predictTime),x0',lb,up,options);
% for i = 1:10
%    options = optimoptions(@surrogateopt,'maxfunctionevaluations',300+50*i);
%    if i > 1
%        options.InitialPoints = trials;
%    end
%    [cSol,fVal,~,~,trials] = surrogateopt(@(V) elNinoLaNinaOpt(V,Ts,tHist,predictTime),lb,up,options);
% end
%% Define Constants
%cSol = load('cSol2.mat');
%cSol = cSol.cSol;
tau1  = cSol(1);
tau2  = cSol(2);
tspan = [0 predictTime];

coeffs = cSol(3:end);  %alpha,beta,gamma,kappa

lags = [tau1,tau2];
%% Solve and Plot
figure("position",[50 50 700 250]);
%tReal = tHist(end-120:end);
%Treal = Ts(end-120:end);
tReal = tHist;
Treal = Ts;
%tHist(end-119:end) = [];
%Ts(end-119:end) = [];

poly = spline(tHist+abs(tHist(end)),Ts);
sol = ddesd(@(t,y,z) laNinoLaNina(coeffs,t,y,z),lags,@(t) ppval(poly,t),tspan);

cla;    
ts = linspace(-tau1,0,1000);
plot(sol.x+2021+tHist(end),sol.y,'r-','linewidth',1);hold on;
plot(tHist+tHist(end)+2021+abs(tReal(1))-(2022-1871),Ts,'b-','linewidth',1);
%plot(tReal+abs(tReal(1))+tHist(end)+2021,Treal,'g-','linewidth',1);
a = tReal+abs(tReal(1))+tHist(end)+2021;
xlim([a(1)-max(lags) a(1)+predictTime])
ylim([-3.5 3.5]);
ylabel("T(t)");
xlabel("t (year)");
%xline(0,'k-','linewidth',2);
clc;clear;close all;
%% Read Data
[sigma,r,C,stonks,prices] = readStonksHistory(12,[],'1d','Mean',"stonks.csv");

%% Optimize
alpha = [0:0.001:1].^2;
N = size(sigma,1);
for i = 1:length(alpha)
    [w,optVal] = quadprog((1-alpha(i))*2*C, -alpha(i)*r,[],[],ones(1,N),[1],0.01.*ones(N,1),0.2*ones(N,1));
    risk(i,1) = w'*C*w;
    ret(i,1) = r'*w;
end

for i = 1:length(alpha)
    [w,optVal] = quadprog((1-alpha(i))*2*C, -alpha(i)*r,[],[],ones(1,N),[1],0.*ones(N,1),0.2*ones(N,1));
    risk(i,2) = w'*C*w;
    ret(i,2) = r'*w;
end

for i = 1:length(alpha)
    [w,optVal] = quadprog((1-alpha(i))*2*C, -alpha(i)*r,[],[],ones(1,N),[1],0*ones(N,1),ones(N,1));
    risk(i,3) = w'*C*w;
    ret(i,3) = r'*w;
end

dRetdRik = diff(ret)./diff(risk);
idx(1) = find(abs(dRetdRik(:,1) - 1) < 1e-2,1);
idx(2) = find(abs(dRetdRik(:,2) - 1) < 1e-2,1);
idx(3) = find(abs(dRetdRik(:,3) - 1) < 1e-2,1);

%%
plot(risk(:,3),ret(:,3),'g-','linewidth',2);hold on;
plot(risk(:,2),ret(:,2),'b-','linewidth',2);
plot(risk(:,1),ret(:,1),'r-','linewidth',2);hold on;


plot(risk(idx(1),1),ret(idx(1),1),'k.','markersize',25)
plot(risk(idx(2),2),ret(idx(2),2),'k.','markersize',25)
plot(risk(idx(3),3),ret(idx(3),3),'k.','markersize',25)
%axis equal
axis([0 2e-3 0 5e-3])
legend("Case 1","Case 2","Case 3",'location','southoutside','orientation','horizontal');
xlabel("Risk");
ylabel("Expected Return");
%Kepeng Qiu (2022). ZoomPlot (https://github.com/iqiukp/ZoomPlot-MATLAB/...
%releases/tag/v1.3.1), GitHub. Retrieved May 9, 2022.
zp = BaseZoom();
zp.plot();
zp.plot();
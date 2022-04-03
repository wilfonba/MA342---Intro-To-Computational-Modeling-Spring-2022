% Heat Equation Plots

Data = [220.0 2.707e3 896.0 0.0174;
        386.0 8.954e3 380.0 0.0197;
        318.0 18.9e3 130.0 0.0213;
        35.0 11.373e3 130.0 8.39e-3;
        54.0 8.073e3 435.0 6.74e-3;
        0.06 1.19e3 1.5e3 3.93e-3;
        2.0e3 3.5e3 2.0e3 0.0343;
        0.242 1.1e3 1.7e3 6.77e-4;
        0.35 920.0 2.3e3 7.52e-4;
        0.5 950.0 2.3e3 8.66e-4;
        0.182 0.08185 14.31e3 0.0238;
        0.02676 1.3007 920.3 8.15e-3;
        0.0262 1.1421 1.0408e3 8.09e-3;
        0.016572 1.7973 871.0 5.60e-3;
        0.0637 0.2579 2.186e3 0.0197;
        0.0246 0.5863 2.06e3 7.77e-3];
    
%% range(T) vs. k
clc;close all;
figure('position',[50 50 800 600]);
[~,idxs] = sort(Data(:,1));
semilogx(Data(idxs,1),Data(idxs,4),'b-','linewidth',1.5);grid;
xlabel("Conductivity (W/m\cdot K)")
ylabel("Range(T) (^oC)")
xlim([0.015 2000])

%% range(T) vs. rho
clc;close all;
figure('position',[50 50 800 600]);
[~,idxs] = sort(Data(:,2));
semilogx(Data(idxs,2),Data(idxs,4),'b-','linewidth',1.5);grid;
xlabel("Density (kg/m^3)")
ylabel("Range(T) (^oC)")
xlim([0.08185 18900])

%% range(T) vs. c
clc;close all;
figure('position',[50 50 800 600]);
[~,idxs] = sort(Data(:,3));
semilogx(Data(idxs,3),Data(idxs,4),'b-','linewidth',1.5);grid;
xlabel("Specific Heat (J/kg\cdot ^oC)")
ylabel("Range(T) (^oC)")
xlim([130 14310])

%% range(T) vs. const
clc;close all;
figure('position',[50 50 800 600]);
alpha = Data(:,1)./(Data(:,1).*Data(:,2));
[~,idxs] = sort(alpha);
semilogx(alpha(idxs),Data(idxs,4),'b-','linewidth',1.5);grid;
xlabel("\alpha")
ylabel("Range(T) (^oC)")
xlim([5.291e-5 12.2175])
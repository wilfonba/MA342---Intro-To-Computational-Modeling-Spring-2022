function R = elNinoLaNinaOpt(V,Ts,tHist,tMax) 
    R = fminconFunc(V);
    function R = fminconFunc(V)
        % extract parameters
        tau1  = V(1);
        tau2  = V(2);
        alpha = V(3);
        beta  = V(4);
        gamma = V(5);
        kappa = V(6);
        R = 0;
        %cla;

        maxTau = 25;
        
        shifts = ceil(tMax)+2:10:abs(tHist(1))-floor(maxTau)-1;
        %shifts = 10;
        for i = 1:1:length(shifts)
            tShift = abs(tHist(1)) - shifts(i);
            tHistN = tHist + tShift;

            % create history and future arrays
            [shiftIdx,~] = find(abs(tHistN) < 1e-8,1);
            tHistN(shiftIdx) = 0;
            [cutIdx,~] = find(tHistN > tMax,1);
            futureT = tHistN(shiftIdx:cutIdx);
            tHistN(shiftIdx+1:end) = [];
            futureTs = Ts(shiftIdx:cutIdx);
            TsN = Ts;
            TsN(shiftIdx+1:end) = [];

%             plot(tHistN,TsN,'g--');
%             hold on
%             plot(futureT,futureTs,'k--');
            
            % solve
            coeffs = [alpha,beta,gamma,kappa];
            lags = [tau1 tau2];
            tspan = [0 tMax];
            poly = spline(tHistN,TsN);
            sol = dde23(@(t,y,z) laNinoLaNina(coeffs,t,y,z),lags,@(t) ppval(poly,t),tspan);

            ts = linspace(0,tMax,250);
            solInterp = interp1(sol.x,sol.y,ts);
            futureInterp = interp1(futureT,futureTs,ts);
            error = sum(abs(solInterp-futureInterp));
            %xline(ts(idx),'k--');
            R = R + error;
            
%             plot(ts,solInterp,'b-');hold on;
%             plot(ts,futureInterp,'r-');
%             pause;
%             cla;
        end
        drawnow;
        %close(f);
    end
end
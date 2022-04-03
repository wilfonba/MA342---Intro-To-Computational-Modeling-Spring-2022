function [xs,ys,NTA] = heatEquationMesh(Ny,doPlot)
    %% Initialize Things
    d = 0.10;
    Nx = 2*Ny-1;

    h = (d/2)/(Ny-1);

    theta = linspace(0,pi/2,1000);

    %% Generate and Plot Mesh

    xs = 0:h:d;
    ys = 0:h:d/2;

    if doPlot
        figure("position",[50 50 1250 700]);hold on;axis equal;axis([-0.01 0.11 -0.01 0.06])
        for i = 1:Nx
           plot([xs(i),xs(i)],[0 d/2],'k-'); 
        end
        for i = 1:Ny
           plot([0 d],[ys(i),ys(i)],'k-'); 
        end

        plot([0 d/2],[d/2 d/2],'b-','linewidth',2);
        plot([0 0],[0 d/2],'k--','linewidth',1);
        plot([0 d],[0 0],'k--','linewidth',1);
        plot([d/2 + d/2.*cos(theta)],[d/2.*sin(theta)],'r-','linewidth',2)
        plot([d/2 d/2],[d/2 d/2],'k--','linewidth',1)
        %plot([d d],[0 d/2],'k--','linewidth',1);
    end

    %% Find and Plot Circle Approximation
    xpoints = zeros(Ny);

    % Search in y-direction
    for i = floor(Nx/2)+1:Nx
        dMin = 987654321;
        cY = sqrt((d/2)^2-(xs(i)-d/2)^2);
        for j = 1:Ny
            cX = sqrt((d/2)^2-ys(j)^2)+d/2;
            %plot(xs(i),ys(j),'ko');
            D = sqrt((cY - ys(j))^2 + (cX - xs(i))^2);
            %pause;
            if D < dMin
                dMin = D;
                idx = j;
            end
        end
        xpoints(i-floor(Nx/2)) = idx;
    end

    % Account for repeats
    jj = 1;
    for i = 1:Ny-1
        xpts(jj) = xpoints(i);
        if (xpoints(i) - xpoints(i+1) > 1)
            k = 1;
            while(xpoints(i+1) < xpts(jj) - 1)
                jj = jj + 1;
                xpts(jj) = xpoints(i)-k;
                k = k + 1;
            end
        end
        jj = jj + 1;
    end
    xpts = [xpts (xpts(end)-1:-1:1)];

    if doPlot
        plot(xs(floor(Nx/2)+fliplr(xpts)),ys(xpts),'r.','markersize',25);
    end

    %% Generate Node Type Array

    NTA = zeros(Ny,Nx);
    fxpts = fliplr(xpts);
    for i = 1:length(xpts)
        NTA(Ny+1-xpts(i),floor(Nx/2)+fxpts(i)) = 1;
    end
    for i = 2:Ny
        j = 1;
        while (true)
            if NTA(i,j) == 0
                NTA(i,j) = 3;
            else
                break;
            end
            j = j + 1;
        end
    end
    NTA(2:end,1) = 4;
    NTA(end,1:end-1) = 5;
    NTA(end,1) = 6;
    NTA(1,1:floor(Nx/2)) = 2;
    NTA(end,end) = 8;
    NTA(end-1,end) = 7;
end
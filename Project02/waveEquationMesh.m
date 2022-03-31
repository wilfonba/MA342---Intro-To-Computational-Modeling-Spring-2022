function [xs,ys,NTA] = waveEquationMesh(Ny,p,doPlot)
    %% Initialize Things
    Nx = Ny;

    h = 1/(Ny-1);
    
    %% Generate and Plot Mesh

    xs = 0:h:1;
    ys = 0:h:1;
    
    bdxs = linspace(0,1,1000);
    bdys = (1-bdxs.^p).^(1/p);

    if doPlot
        figure("position",[50 50 700 700]);hold on;axis equal;axis([-0.1 1.1 -0.1 1.1])
        for i = 1:Nx
           plot([xs(i),xs(i)],[0 1],'k-'); 
        end
        for i = 1:Ny
           plot([0 1],[ys(i),ys(i)],'k-'); 
        end


        plot([0 0],[0 1],'k--','linewidth',1);
        plot([0 1],[0 0],'k--','linewidth',1);
        plot(bdxs,bdys,'k-','linewidth',2);
    end
    drawnow;
    %% Find and Plot Circle Approximation
    xpoints = zeros(1,Ny);

    % Search in y-direction
    for i = 1:Nx
        dMin = 987654321;
        cY = (1-xs(i)^p)^(1/p);
        for j = 1:Ny
            cX = (1-ys(j)^p)^(1/p);
            %plot(xs(i),ys(j),'ko');
            D = sqrt((cY - ys(j))^2 + (cX - xs(i))^2);
            %pause;
            if D < dMin
                dMin = D;
                idx = j;
            end
        end
        xpoints(i) = idx;
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
    if p > 100
        xpts = [1:1:Nx,Nx.*ones(1,Ny-1)];
    end
    
    if doPlot
        plot(xs(fliplr(xpts)),ys(xpts),'k.','markersize',20);
    end

    %% Generate Node Type Array
    NTA = zeros(Ny,Nx);
    
    NTA(2:end,1) = 3;
    NTA(end,1:end-1) = 4;
    NTA(end,1) = 5;
    fxpts = fliplr(xpts);
    for i = 1:length(xpts)
        NTA(Ny+1-xpts(i),fxpts(i)) = 2;
    end
    idx = find(fxpts == 2,1);
    for i = idx:Ny
        j = 2;
        while (true)
            if NTA(i,j) == 0
                NTA(i,j) = 1;
            else
                break;
            end
            j = j + 1;
        end
    end
end
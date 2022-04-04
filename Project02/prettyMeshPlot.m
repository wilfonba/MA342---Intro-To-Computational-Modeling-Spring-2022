clc;clear;close all;

[xs,ys,NTA] = waveEquationMesh(8,2,0);

Nx = length(xs);
Ny = length(ys);
d = 0.1;
theta = linspace(0,pi/2,1000);

figure("position",[50 50 1250 700]);hold on;axis equal;axis([-0.1 1.1 -0.1 1.1])
for i = 2:Nx
   plot([xs(i),xs(i)],[0 1],'k-'); 
end
for i = 2:Ny
   plot([0 1],[ys(i),ys(i)],'k-'); 
end

% plot([0 d/2],[d/2 d/2],'k-','linewidth',2);
% plot([0 0],[0 d/2],'k--','linewidth',1);
% plot([0 d],[0 0],'k--','linewidth',1);
% plot([d/2 + d/2.*cos(theta)],[d/2.*sin(theta)],'k-','linewidth',2)
% plot([d/2 d/2],[d/2 d/2],'k--','linewidth',1)
% plot([d d],[0 d/2],'k--','linewidth',1);
plot([0 0],[0 1],'k--','linewidth',2); hold on;
plot([0 1],[0 0],'k--','linewidth',2);
plot([cos(theta)],[sin(theta)],'k-','linewidth',2)

ys = fliplr(ys);

for i = 1:Nx
    for j = 1:Ny
        
        type = NTA(j,i);
        switch(type)
            case 0
                scatter(xs(i),ys(j),300,'MarkerFaceColor','c','MarkerEdgeColor','c','MarkerFaceAlpha',0.5);
                text(xs(i),ys(j),"0",'color','w','HorizontalAlignment','center','FontSize',17,'FontWeight','bold');
            case 1
                scatter(xs(i),ys(j),300,'MarkerFaceColor','k','MarkerEdgeColor','k','MarkerFaceAlpha',0.5);
                text(xs(i),ys(j),"1",'color','w','HorizontalAlignment','center','FontSize',17,'FontWeight','bold');
            case 2
                scatter(xs(i),ys(j),300,'MarkerFaceColor','b','MarkerEdgeColor','b','MarkerFaceAlpha',0.5);
                text(xs(i),ys(j),"2",'color','w','HorizontalAlignment','center','FontSize',17,'FontWeight','bold');
            case 3
                scatter(xs(i),ys(j),300,'MarkerFaceColor','m','MarkerEdgeColor','m','MarkerFaceAlpha',0.5);
                text(xs(i),ys(j),"3",'color','w','HorizontalAlignment','center','FontSize',17,'FontWeight','bold');
            case 4
                scatter(xs(i),ys(j),300,'MarkerFaceColor','m','MarkerEdgeColor','m','MarkerFaceAlpha',0.5);
                text(xs(i),ys(j),"4",'color','w','HorizontalAlignment','center','FontSize',17,'FontWeight','bold');
            case 5
                scatter(xs(i),ys(j),300,'MarkerFaceColor','m','MarkerEdgeColor','m','MarkerFaceAlpha',0.5);
                text(xs(i),ys(j),"5",'color','w','HorizontalAlignment','center','FontSize',17,'FontWeight','bold');
            case 6
                scatter(xs(i),ys(j),300,'MarkerFaceColor','m','MarkerEdgeColor','m','MarkerFaceAlpha',0.5);
                text(xs(i),ys(j),"6",'color','w','HorizontalAlignment','center','FontSize',17,'FontWeight','bold');
            case 7 
                scatter(xs(i),ys(j),300,'MarkerFaceColor','r','MarkerEdgeColor','r','MarkerFaceAlpha',0.5);
                text(xs(i),ys(j),"7",'color','w','HorizontalAlignment','center','FontSize',17,'FontWeight','bold');
            case 8
                scatter(xs(i),ys(j),300,'MarkerFaceColor','r','MarkerEdgeColor','r','MarkerFaceAlpha',0.5);
                text(xs(i),ys(j),"8",'color','w','HorizontalAlignment','center','FontSize',17,'FontWeight','bold');
        end
    end
end
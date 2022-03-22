function A = calcA(Ls,ts,n,x,b,b2)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % function A = calcA(ds,ts,n,x)
    %
    % Description: Calculates the coefficient matrix A to perform calcualte
    % lift via the panel method
    %
    % Inputs:
    %   Ls - Nx1 array of the length L of each panel
    %   ts - Nx1 array of rotation angle for each panel's horizontal
    %        mapping to the origin
    %   n  - Nx2 array of the inward facing normals of each panel
    %   x  - (N+2)x2 array of x and y coordinates of each node point
    %   b  - percent distance from front of panel to calculate doublet
    %
    % Outputs:
    %   A  - The N-1xN-1 coefficient matrix used to calculate doublet
    %        strengths
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Initialize empty arrays
    N = size(Ls,1);      % number of panels
    A = zeros(N-1,N);    % coefficient matrix a
    M = zeros(N,2);        % Nx2 interior point matrix
    
    % duplicate because I overwrite it...
    X = x;
    
    % Populate the matrix of interior points on each panel
    for i = 1:N-1
       if x(i+1,1) < x(i,1)
           d = x(i,:) - x(i+1,:);
           M(i,:) = x(i+1,:) + b.*d;
       else
           d = x(i+1,:) - x(i,:);
           M(i,:) = x(i,:) + b.*d;
       end
    end
    d = x(end,:) - x(end-1,:);
    M(N,:) = x(N,:) + b2.*d;
    
    % populate A
    for i = 1:N
        theta = ts(i);
        R = [cos(theta) -sin(theta);
             sin(theta)  cos(theta)];
        Mt = R*(M(:,:) - M(i,:))';
        
        % debugging code for transforms
        
%         Xt = R*(X(:,:) - M(i,:))';
%         plot(Xt(1,:),Xt(2,:),'ko-');hold on;axis equal;
%         plot(Mt(1,:),Mt(2,:),'b.','markersize',20);
%         pause;
%         cla;

        for j = 1:N-1
           x = Mt(1,j);
           z = Mt(2,j);
           L = Ls(i);
           if i ~= N
              if i == j
                    D2 = -L/(2*L^2*pi*b^2 - 2*L^2*pi*b + 4*L*pi*b*x - 2*L*pi*x + 2*pi*x^2);
                    D = -1.*[0;D2];
                    int1 = R\D;
                    A(j,i) = n(j,:)*int1;
               else
                    d1 = z/(2*pi*(abs(z)^2 + (1 - b)^2*L^2 - 2*x*(1 - b)*L + x^2));
                    d2 = z/(2*pi*(abs(z)^2 + b^2*L^2 + 2*x*b*L + x^2));
                    D1 = (d1-d2);
                    d1 = ((abs(z)^2 + (-x + 0.5*L)^2)*(z - abs(z))*(z + abs(z))*atan((-x + 0.5*L)/abs(z)) +...
                        abs(z)*(abs(z)^2 + z^2)*(-x + 0.5*L))/(4*(abs(z)^2 + (-x + 0.5*L)^2)*pi*abs(z)^3);
                    d2 = ((abs(z)^2 + (-x - 0.5*L)^2)*(z - abs(z))*(z + abs(z))*atan((-x - 0.5*L)/abs(z)) +...
                        abs(z)*(abs(z)^2 + z^2)*(-x - 0.5*L))/(4*(abs(z)^2 + (-x - 0.5*L)^2)*pi*abs(z)^3);
                    D2 = (d1-d2);
                    D = -1.*[D1;D2];
                    int1 = R\D;
                    A(j,i) = n(j,:)*int1;
              end
           else
              if i == j
                    D2 = -L/(2*L^2*pi*b2^2 - 2*L^2*pi*b2 + 4*L*pi*b2*x - 2*L*pi*x + 2*pi*x^2);
                    D = [0;D2];
                    int1 = R\D;
                    A(j,i) = n(j,:)*int1;
               else
                    d1 = z/(2*pi*(abs(z)^2 + (1 - b2)^2*L^2 - 2*x*(1 - b2)*L + x^2));
                    d2 = z/(2*pi*(abs(z)^2 + b2^2*L^2 + 2*x*b2*L + x^2));
                    D1 = (d1-d2);
                    d1 = ((abs(z)^2 + (-x + 0.5*L)^2)*(z - abs(z))*(z + abs(z))*atan((-x + 0.5*L)/abs(z)) +...
                        abs(z)*(abs(z)^2 + z^2)*(-x + 0.5*L))/(4*(abs(z)^2 + (-x + 0.5*L)^2)*pi*abs(z)^3);
                    d2 = ((abs(z)^2 + (-x - 0.5*L)^2)*(z - abs(z))*(z + abs(z))*atan((-x - 0.5*L)/abs(z)) +...
                        abs(z)*(abs(z)^2 + z^2)*(-x - 0.5*L))/(4*(abs(z)^2 + (-x - 0.5*L)^2)*pi*abs(z)^3);
                    D2 = (d1-d2);
                    D = [D1;D2];
                    int1 = R\D;
                    A(j,i) = n(j,:)*int1;
              end
           end
        end
    end   
end
function [z]=CubicSpline(x,y,v)
    %function [z]=CubicSpline(x,y,v)
    %Description:
    %Computes a natural cubic spline
    %Inputs:
    %x - A vector of length n that specifies the x-coordinates of the data
    %y - A vector of length n that specifies the y-coordinates of the data
    %v - an optional argument with a default value of x where the cubic
    %    spline should be evaluated.
    %Outpus:
    %z - A vector containing f(v(i))
    
    if ~exist('v','var')
        v=[];
    end
    
    %sort everything
    [x,k]=sort(x);
    y=y(k);
    
    n=length(x);
    
    w=zeros(n-1,1);  %RHS of A*b=s system
    w(1)=NaN;
    
    dx=zeros(n-1,1);   %dx(i)
    dx(1)=x(2)-x(1);
    
    s=zeros(n,1);   %s(i)
    s(1)=0;
    s(n)=0;
    
    CE=zeros(n-2,n-2);  %Coefficient matrix A
    
    %Populate dx(i) and w(i)
    for i=2:n-1
        dx(i)=x(i+1)-x(i);
        w(i,1)=6*(((y(i+1)-y(i))/dx(i))-((y(i)-y(i-1))/dx(i-1)));
    end
    
    %Form the coefficieent matrix
    CE(1,1)=2*(dx(2)+dx(1));
    CE(1,2)=dx(2);
    for j=2:n-3
        CE(j,j-1)=dx(j,1);
        CE(j,j)=2*(dx(j+1,1)+dx(j,1));
        CE(j,j+1)=dx(j+1,1);
    end
    CE(n-2,n-3)=dx(n-2);
    CE(n-2,n-2)=2*(dx(n-1)+dx(n-2));

    %Perform LU factorization on coefficient matrix
    L=eye(n-2,n-2);
    for i=1:n-3
        L(i+1,i)=CE(i+1,i)/CE(i,i);
        CE(i+1,:)=CE(i+1,:)-L(i+1,i)*CE(i,:);
    end

    %Perform forward and backward substitution
    f=zeros(n-2,1); %Intermediate variable for TDMS
    f(1)=w(2);
    for i=2:n-2
        f(i)=w(i+1)-L(i,i-1)*f(i-1);
    end

    s(n-1)=f(n-2)/CE(n-2,n-2);
    for i=n-2:-1:2
        s(i)=(f(i-1)-CE(i-1,i)*s(i+1))/CE(i-1,i-1);
    end
    
    %Calcuate a(i), b(i), c(i), and d(i) using s(i) and y(i)
    for i=1:n-1
        a(i)=y(i);
        b(i)=(y(i+1)-y(i))/dx(i)-dx(i)*((s(i+1)+2*s(i))/6);
        c(i)=s(i)/2;
        d(i)=(s(i+1)-s(i))/(6*dx(i));
    end
    
    %Evaluate the spline at the points in v
    for i=1:length(v)
        if v(i) < x(1)
            z(i,1)=0;
        elseif v(i) > x(length(x))
            z(i,1)=0;
        else
            u=1;
            while(true)
                if v(i)>=x(u) && v(i)<=x(u+1)
                    z(i,1)=a(u)+b(u)*(v(i)-x(u))+c(u)*(v(i)-x(u)).^2+d(u)*(v(i)-x(u)).^3;
                    break;
                else
                    u=u+1;
                end
            end
        end
    end
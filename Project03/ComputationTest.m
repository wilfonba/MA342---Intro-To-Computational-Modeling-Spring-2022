a2 = 0.5;
a3 = 0.5;
a0 = 0.1;

b1 = 0.5;
b3 = 0.5;
b0 = 0.1;

c1 = 0.5;
c2 = 0.5;
c0 = 10;

delays = [2;2;2;2];

history = [0;0;0;0];

start = 0;
stop = 100;

options = ddeset('RelTol',1e-6);
% options2 = ddeset('Events',events);

sol = ddesd(@(t,D,Ddel) ...
        ([I(t) - a2*(D(1) - Ddel(2)) - a3*(D(1) - Ddel(3)) - a0*D(1);
          -b1*(D(2) - Ddel(1)) - b3*(D(2) - Ddel(3)) - b0*D(2);
          -c1*(D(3) - Ddel(1)) - c2*(D(3) - Ddel(2)) - c0*D(3);
          a0*Ddel(1)+b0*Ddel(2)+c0*Ddel(3)]), ...
        delays,history,[start, stop], options);

sol.x
sol.y

plot(sol.x, sol.y(1, 1:end));
hold on
plot(sol.x, sol.y(2, 1:end));
plot(sol.x, sol.y(3, 1:end));
plot(sol.x, sol.y(4, 1:end));
legend("S1", "S2", "S3", "Out")
hold off

function i = I(t)
%    if t < 5
        i = 1/(t^2+0.5);
%    else
%        i = 0;
%    end
    return
end

%function [value,isterminal,direction] = events(t,y,YDEL)
%    if y < 0
%        value = 0;
%    else
%        value = y;
%    end
%    isterminal = 0;
%    direction = 0;
%end



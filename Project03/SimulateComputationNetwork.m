function sol = SimulateComputationNetwork(network, delays, time, processrates, startingdata, input)
%
% Simulates a network of n computers running in parallel of using a system of DDEs.
% Returns the solution data and plots the number of packets at each
% computer at a given time and the number of total processed packets.
%
% network:      A nxn matrix of nonnegative integers, representing a computer's
%               priorities to transfer from one computer to another, or to
%               process its own data (on the diagonal). A priority of 0 means
%               effectively no communication in that direction.
% delays:       A length n+1 vector of nonnegative delays between sending data 
%               from a node, and for processing time.
% time:         How long to run the simulation for.
% processrates: The maximum amount of data each computer can process. Omit
%               for UNLIMITED PROCESSING POWER.
% startingdata: A length n+1 vector of the number of packets of data at time 
%               zero. Omit for no starting data.
% input:        The input rate of data into each computer as a function of
%               time, i.e., a function from a scalar to a length n vector.
%               Omit for the zero function.

n = size(network, 1);

if nargin < 6
    input = @(t) zeros(n, 1);
end

if nargin < 5
    startingdata = zeros(n, 1);
end

if nargin < 4
    startingdata = inf(n, 1);
end

start = 0;
stop = time;
options = ddeset('RelTol',1e-6);

sol = ddesd(@(t,D,Ddel) generateEquations(input, network, processrates, t, D, Ddel), ...
    delays, startingdata, [start, stop], options);

figure
hold on
for i = 1:n+1
    plot(sol.x, sol.y(n, 1:end))
    if i == n + 1
        legend("S" + n)
    else
        legend("Processed Packets")
    end
end
hold off
end

function out = generateEquations(input, network, processrates, t, D, Ddel)
    out = zeros(n, 1);
    for i = 1;n
        out(i) = input(i) - network(1, 1:end)*(D(i)-Ddel) + network(i,i)*(D(i)-Ddel(i)) ...
        - min(processrates(i), network(i, i)*D(i));
    end
    out = [out ; sum(min(processrates, diag(network).*Ddel))];
end
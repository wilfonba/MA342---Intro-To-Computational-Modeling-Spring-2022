% Baseline
% This matrix is transposed in the write-up I think
network = [1 0.2 0.2;
           0.2 1 0.2
           0.2 0.2 1];
delays = [2; 2; 2; 2];
time = 25;
processrates = [1; 5; 5];
startingdata = [0; 0; 0; 0];

SimulateComputationNetwork(network, delays, time, processrates, startingdata, @I);


% Asymmetric Baseline
% This matrix is transposed in the write-up I think
network = [1 0.2 0.2;
           0.2 1 0.2
           0.0 0.2 1];
delays = [2; 2; 2; 2];
time = 25;
processrates = [1; 5; 5];
startingdata = [0; 0; 0; 0];

SimulateComputationNetwork(network, delays, time, processrates, startingdata, @I);


% K_4
network = [1 0.5 0.5 0.5;
           0.5 1 0.5 0.5;
           0.5 0.5 1 0.5;
           0.5 0.5 0.5 1];
delays = [2; 2; 2; 2; 2];
time = 50;
processrates = [5; 1; 2; 4];
startingdata = [0; 0; 0; 0; 0];

sol = SimulateComputationNetwork(network, delays, time, processrates, startingdata, @I2);
test = sol.x(find(sol.y > 99.5) ./ 5);
test(1)


% C_4
network = [1 0.5 0 0.5;
           0.5 1 0.5 0;
           0 0.5 1 0.5;
           0.5 0 0.5 1];
delays = [2; 2; 2; 2; 2];
time = 50;
processrates = [5; 1; 2; 4];
startingdata = [0; 0; 0; 0; 0];

sol = SimulateComputationNetwork(network, delays, time, processrates, startingdata, @I2);
test = sol.x(find(sol.y > 99.5) ./ 5);
test(1)

% P_4
network = [1 0.5 0 0;
           0.5 1 0.5 0;
           0 0.5 1 0.5;
           0 0 0.5 1];
delays = [2; 2; 2; 2; 2];
time = 30;
processrates = [5; 1; 2; 4];
startingdata = [0; 0; 0; 0; 0];

sol = SimulateComputationNetwork(network, delays, time, processrates, startingdata, @I2);
test = sol.x(find(sol.y > 99.5) ./ 5);
test(1)

% S_4
network = [1 0.5 0.5 0.5;
           0.5 1 0 0;
           0.5 0 1 0;
           0.5 0 0 1];
delays = [2; 2; 2; 2; 2];
time = 30;
processrates = [5; 1; 2; 4];
startingdata = [0; 0; 0; 0; 0];

sol = SimulateComputationNetwork(network, delays, time, processrates, startingdata, @I2);
test = sol.x(find(sol.y > 99.5) ./ 5);
test(1)

function i = I(t)
    if t < 5
        i = [10, 0, 0, 0];
    else
        i = [0, 0, 0, 0];
    end
    return
end


function i = I2(t)
    if t < 0.1
        i = [1000, 0, 0, 0];
    else
        i = [0, 0, 0, 0];
    end
    return
end
network = [0.5 0.5 0.5; 0.5 0.5 0.5; 0.5 0.5 0.5];
delays = [2; 2; 2; 2];
time = 50;
processrates = [2; 2; 0.5];
startingdata = [0; 0; 0; 0];

SimulateComputationNetwork(network, delays, time, processrates, startingdata, @I)

function i = I(t)
    if t < 5
        i = [5*t, 0, 0];
    else
        i = [0, 0, 0];
    end
    return
end
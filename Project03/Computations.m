network = [0.2 0.1 0 0; 
            0 0.2 0.1 0; 
            0 0 0.2 0.1; 
            0.1 0 0 0.2];
delays = [2; 2; 2; 2; 2];
time = 50;
processrates = [2; 2; 2; 2];
startingdata = [0; 0; 0; 0; 0];

SimulateComputationNetwork(network, delays, time, processrates, startingdata, @I)

function i = I(t)
    if t < 0.1
        i = [10000, 0, 0, 0];
    else
        i = [0, 0, 0, 0];
    end
    return
end
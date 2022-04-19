network = [0.5 0.5 0.1; 0.5 0.1 0.5; 0.5 0.5 0.1];
delays = [2; 2; 2; 2];
time = 20;
processrates = [0.5; 0.5; 0.5];
startingdata = [0; 0; 0; 0];

SimulateComputationNetwork(network, delays, time, processrates, startingdata, I)



function i = I(t)
    if t < 5
        i = t;
    else
        i = 0;
    end
    return
end
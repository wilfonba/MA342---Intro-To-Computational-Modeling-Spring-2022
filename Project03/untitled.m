N = 10;
Ws = dec2bin(0:2^N-1)' - '0';

times = zeros(1, size(Ws, 2));
for i=1:size(Ws, 2)
    
    W = Ws(1:end, i);
    network = diag(ones(1, 5));
    x = 1;
    for a=1:5
        for b=1:(a-1)
            network(a, b) = W(x)/2;
            network(b, a) = W(x)/2;
            x = x + 1;
        end
    end
    delays = [2; 2; 2; 2; 2; 2];
    time = 60;
    processrates = [2; 2; 2; 2; 2];
    startingdata = [0; 0; 0; 0; 0; 0];
    network

    sol = SimulateComputationNetwork(network, delays, time, processrates, startingdata, @I2);
    test = sol.x(find(sol.y > 99.5) / 6);
    if size(test, 1) > 0
        times(i) = test(1);
    else
        times(i) = 60;
    end
end

times
min(times)

function i = I2(t)
    if t < 0.1
        i = [1000, 0, 0, 0, 0];
    else
        i = [0, 0, 0, 0, 0];
    end
    return
end
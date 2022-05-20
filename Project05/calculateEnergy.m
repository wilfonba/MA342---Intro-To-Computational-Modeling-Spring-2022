function E = calculateEnergy(S,A,J,H)
    E = 0;
    N = size(S,1);
    for j = 1:size(A,1)
       E = E - J*S(A(j,1),1)*S(A(j,2),1);
    end
    for j = 1:N
        E = E - H*S(j,1);
    end
    E;
end
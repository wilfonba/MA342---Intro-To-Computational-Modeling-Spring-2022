function sigma = updateSigma(S,A,T,p)
    samples = randsample(size(S,1),p*size(S,1));
    sigma = zeros(size(S,1),1);
    for i = 1:size(S,1)
       if ismember(i,samples)
            sigmaSum = 0;
            idx = find(A(:,1) == i);
            sigmaSum = sigmaSum + sum(S(A(idx,2),1));
            idx = find(A(:,2) == i);
            sigmaSum = sigmaSum + sum(S(A(idx,1),1));
            Ediff = -2*S(i,1)*sigmaSum;
            
            if Ediff > 0
                Pswap = 1;
            else
                Pswap = exp(Ediff/T);
            end
            
            if (Pswap > rand())
                sigma(i) = -1*S(i);
            else
                sigma(i) = S(i);
            end
            
       else
           sigma(i) = S(i);
       end
    end
end
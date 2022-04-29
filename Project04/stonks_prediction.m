function [P_next] = stonks_prediction(dt,P,sigma,mu)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Description: Uses previous stock data to predict the future stock prices
% 
% Inputs:
%   day = Current day we are predicting
%   dt = size of the time step
%   P = Previous stock prices we will be predicting. At this moment
%            it will be after 40 days
%   sigma = Calculated value for the volatility parameter for each stock
%   mu = The drift/return parameter
%
% Outputs:
%   P_next = Prediction of future prices at the next time step

phi = randn(size(sigma));

P_next = P + mu'.*P*dt+sigma'.*P*sqrt(dt).*phi';

end
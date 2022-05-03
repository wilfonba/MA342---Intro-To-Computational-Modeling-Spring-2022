function [sigma,mu,C,prices] = updateStonksHistory(prices,newData)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Description: Appends new prices from data from readstonksHistory.m
%
% Inputs:
%       prices: Existing array of prices. Stocks are indexed by columns and
%       dates by rows with most recent data at the top
%       newData: New prices to add to the beginning of prices.
%
% Outputs:
%       sigma: new sigma
%       mu: new mu
%       c: new C
%       prices: new prices
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    prices = [newData;prices];
    returns = (prices(2:end,:) - prices(1:end-1,:))./(prices(1:end-1,:));
    sigma = (std(returns))';
    mu = mean(returns)';
    C = corrcoef(returns);
end
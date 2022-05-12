function [sigma,mu,C,stonks,prices] = readStonksHistory(startDate,endDate,interval,collectionPoint,filename)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Description: Reads stock histories from Yahoo Finnance and creates sigma
%              and mu vectors for protfolio optimization
%
% Inputs:
%   startDate - history start date as string or integer number of months of
%               history to read from today's date. ex. "1-Jan-2020" or 6
%   endDate - history end date as string. ex. "1-Jan-2020", leave blank for
%             today's date
%   interval - interval at which to read history. '1d' '5d' '1w' '1m' '3mo'
%   collectionPoint - Price at which to take. 'Open' 'High' 'Low' 'Close'
%                     'Mean'(average of 'High' and 'Low')
% Outputs:
%   sigma - nx1 vector of sigma values
%   mu - Nx1 vector of mu values
%   stonks - Nx1 cell array of stonk names
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    if (isempty(endDate))
        t = now;
        t2 = floor(now);
        endDate = string(datetime(addtodate(t2,-1,'day'),'convertFrom','datenum'));
        startDate = string(datetime(addtodate(t2,-startDate,'month'),'convertFrom','datenum'));
    end
    
    [~,stonks,~] = xlsread(filename);
    N = size(stonks,1);
    sigma = zeros(N,1);
    mu = zeros(N,1);
    C = zeros(N,1);

   %Artem Lenskiy (2022). Yahoo Finance and Quandl data downloader 
   %(https://github.com/Lenskiy/Yahoo-Quandl-Market-Data-Donwloader/...
   %releases/tag/v1.131), GitHub. Retrieved May 9, 2022.
   data = getMarketDataViaYahoo(stonks{1},startDate,endDate,interval);
   days = size(data, 1);
    
   prices = zeros(days, N);
    for i = 1:N
       fprintf("%s\n",stonks{i});
       clear data;
       data = getMarketDataViaYahoo(stonks{i},startDate,endDate,interval);
       cdays = size(data, 1);
       if (strcmp(collectionPoint,'Mean'))
           prices(1:min(days, cdays),i) = (data.High(1:min(days, cdays)) + data.Low(1:min(days, cdays)))./2;
       elseif (strcmp(collectionPoint,'Open'))
           prices(1:min(days, cdays),i) = data.Open(1:min(days, cdays));
       elseif (strcmp(collectionPoint,'Close'))
           prices(1:min(days, cdays),i) = data.Close(1:min(days, cdays));
       elseif (strcmp(collectionPoint,'High'))
           prices(1:min(days, cdays),i) = data.High(1:min(days, cdays));
       elseif (strcmp(collectionPoint,'Low'))
           prices(1:min(days, cdays),i) = data.Low(1:min(days, cdays));
       end
       if cdays < days 
            prices(cdays+1:days, i) = prices(cdays, i)+zeros(days-cdays, 1);
       end
    end
   returns = (prices(2:end,:) - prices(1:end-1,:))./(prices(1:end-1,:));
   sigma = std(returns)';
   mu = mean(returns)';
   C = cov(returns);
end
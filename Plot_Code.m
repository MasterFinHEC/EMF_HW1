%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EMPIRICAL METHODS FOR FINANCE
% Homework I
%
% Benjamin Souane, Antoine-Michel Alexeev and Julien Bisch
% Due Date: 5 March 2020
%==========================================================================

%% Weekdate

%Computing Week Dates (For ploting)
weekdate=[];
for i=1:5:length(date)
    weekdate=[weekdate;date(i)];
end

%% Plot of the prices

f = figure('visible','off');
plot(data)
legend(Names,'Location','northwest')
saveas(f,'Plots/Prices.png')

%% Plot S&P500
f = figure('visible','off');
x=date(2:end);
y1=data(2:end,1);
yyaxis right;
title('Prices of S&P500 from 31/12/1999 to 31/12/2019');
plot(x,y1);
ylabel('Prices of S&P500');
y2=LogRD(:,1);
yyaxis left;
plot(x,y2);
ylabel('Log-returns of S&P500');
datetick('x','dd-mmm-yyyy');
% axis([733668,737620,0,3000]);
xlabel('Time' ,'Color','k','FontSize',12);
saveas(f,'Plots/SP500.png')
%%
f = figure('visible','off');
x=date(2:end);
y1=data(2:end,2);
yyaxis right;
title('Prices of Government bond from 31/12/1999 to 31/12/2019');
plot(x,y1);
ylabel('Prices of Governement bond');
y2=LogRD(:,2);
yyaxis left;
plot(x,y2);
ylabel('Log-returns of Goverment bond');
datetick('x','dd-mmm-yyyy');
xlabel('Time' ,'Color','k','FontSize',12);
saveas(f,'Plots/GovBond.png')
%%
f = figure('visible','off');
x=date(2:end);
y1=data(2:end,3);
yyaxis right;
title('Prices of Corporate bond from 31/12/1999 to 31/12/2019');
plot(x,y1);
ylabel('Prices of Corporate bond');
y2=LogRD(:,3);
yyaxis left;
plot(x,y2);
ylabel('Log-returns of Corporate bond');
datetick('x','dd-mmm-yyyy');
xlabel('Time' ,'Color','k','FontSize',12);
saveas(f,'Plots/CorpBond.png')
%%
f = figure('visible','off');
x=date(2:end);
y1=data(2:end,4);
yyaxis right;
title('Prices of Real Estate securities from 31/12/1999 to 31/12/2019');
plot(x,y1);
ylabel('Prices of Real Estate securities');
y2=LogRD(:,4);
yyaxis left;
plot(x,y2);
ylabel('Log-returns of Real Estate securities');
datetick('x','dd-mmm-yyyy');
xlabel('Time' ,'Color','k','FontSize',12);
saveas(f,'Plots/RealEstateSec.png')
%%
f = figure('visible','off');
x=date(2:end);
y1=data(2:end,5);
yyaxis right;
title('Prices of CBS spot index from 31/12/1999 to 31/12/2019');
plot(x,y1);
ylabel('Prices of CBS spot index');
y2=LogRD(:,5);
yyaxis left;
plot(x,y2);
ylabel('Log-returns of CBS spot index');
datetick('x','dd-mmm-yyyy');
xlabel('Time' ,'Color','k','FontSize',12);
saveas(f,'Plots/CBSspot.png')
%%
f = figure('visible','off');
x=date(2:end);
y1=data(2:end,6);
yyaxis right;
title('Prices of currencies index from 31/12/1999 to 31/12/2019');
plot(x,y1);
ylabel('Prices of currencies index');
y2=LogRD(:,6);
yyaxis left;
plot(x,y2);
ylabel('Log-returns of currencies index');
datetick('x','dd-mmm-yyyy');
xlabel('Time' ,'Color','k','FontSize',12);
saveas(f,'Plots/Currencies.png')

%% Empiricial CDF VS Theoretical S&P500

x=sort(LogRD);

for j = 1:K
f = figure('visible','off');
L=length(x);
cdfplot(x(:,j));
meanRD = mean(x(:,j));
vola = sqrt(var(x(:,j)));
hold on
x2=normrnd(meanRD,vola,[L,1]);
cdfplot(x2);
legend('Empirical CDF','Theoretical CDF','Location','best')
title(sprintf('CDF of %s compare to the CDF a normal law',string(Names(j))))
xlim([-0.05 0.05])
ylim([0 1])
hold off
graphname = sprintf('Plots/CDF of  %s.png',string(Names(j)));
saveas(f,graphname);
end 

%% Autocorrelation Daily


%Setting parameters for the loops
CFD.lags = 10; %Number of lags
CFD.lagN = (1:CFD.lags)'; % lag number vector
Autocorr_Daily = zeros(CFD.lags+1,K); %Matrice to store the lags and the confidence interval

for j=1:K

[CFD.AC,~] = sacf(LogRD(:,j),CFD.lags,1,0);

% define confidence bands
CFD.confBands = 2* length(LogRD(:,j))^(-1/2);

%Store Data into the Matrice (For each asset asset class)
Autocorr_Daily(1:10,j) = CFD.AC;
Autocorr_Daily(11,j) = CFD.confBands; 

%Graph the Autocorrelation
f = figure('visible','off');
set(gcf,'color','w','PaperUnits','centimeters',...
    'PaperPosition',[0 5 10 10])
bar(CFD.lagN,CFD.AC,'FaceColor',[0, 0.4, 0.8])
hold on
line([0,0;CFD.lags,CFD.lags],...
    [CFD.confBands,-CFD.confBands;CFD.confBands,-CFD.confBands],...
    'Color','k','LineStyle','--')
title(sprintf('Correlogram for %s daily returns',string(Names(j))))
axis([0 CFD.lags+1 -.05 +.05])
xlabel('Number of lags','FontSize',12,'FontName','Calibri')
ylabel('ACF','FontSize',12,'FontName','Calibri')
set(gcf,'position',[200,200,800,300])
graphname = sprintf('Plots/Correlogram for %s daily returns.png',string(Names(j)));
saveas(f,graphname)

end

%% Autocorrelation Weekly

Autocorr_Weekly = zeros(CFD.lags+1,K); %Matrice to store the lags and the confidence interval

for j=1:K

[CFD.AC,~] = sacf(LogWeekR(:,j),CFD.lags,1,0);

% define confidence bands
CFD.confBands = 2* length(LogWeekR(:,j))^(-1/2);

%Store Data into the Matrice (For each asset asset class)
Autocorr_Weekly(1:10,j) = CFD.AC;
Autocorr_Weekly(11,j) = CFD.confBands; 

%Graph the Autocorrelation
f = figure('visible','off');
set(gcf,'color','w','PaperUnits','centimeters',...
    'PaperPosition',[0 5 10 10])
bar(CFD.lagN,CFD.AC,'FaceColor',[0, 0.4, 0.8])
hold on
line([0,0;CFD.lags,CFD.lags],...
    [CFD.confBands,-CFD.confBands;CFD.confBands,-CFD.confBands],...
    'Color','k','LineStyle','--')
title(sprintf('Correlogram for %s weekly returns',string(Names(j))))
axis([0 CFD.lags+1 -.08 +.08])
xlabel('Number of lags','FontSize',12,'FontName','Calibri')
ylabel('ACF','FontSize',12,'FontName','Calibri')
set(gcf,'position',[200,200,800,300])
graphname = sprintf('Plots/Correlogram for %s weekly returns.png',string(Names(j)));
saveas(f,graphname)

end

%% Autocorrelation Daily Squared

Autocorr_DailySquared = zeros(CFD.lags+1,K); %Matrice to store the lags and the confidence interval
DailySquared = LogRD.^2; 
for j=1:K

[CFD.AC,~] = sacf(DailySquared(:,j),CFD.lags,1,0);

% define confidence bands
CFD.confBands = 2* length(DailySquared(:,j))^(-1/2);

%Store Data into the Matrice (For each asset asset class)
Autocorr_DailySquared(1:10,j) = CFD.AC;
Autocorr_DailySquared(11,j) = CFD.confBands; 

%Graph the Autocorrelation
f = figure('visible','off');
set(gcf,'color','w','PaperUnits','centimeters',...
    'PaperPosition',[0 5 10 10])
bar(CFD.lagN,CFD.AC,'FaceColor',[0, 0.4, 0.8])
hold on
line([0,0;CFD.lags,CFD.lags],...
    [CFD.confBands,-CFD.confBands;CFD.confBands,-CFD.confBands],...
    'Color','k','LineStyle','--')
title(sprintf('Correlogram for %s daily squared returns',string(Names(j))))
axis([0 CFD.lags+1 -.4 +.4])
xlabel('Number of lags','FontSize',12,'FontName','Calibri')
ylabel('ACF','FontSize',12,'FontName','Calibri')
set(gcf,'position',[200,200,800,300])
graphname = sprintf('Plots/Correlogram for %s daily squared returns.png',string(Names(j)));
saveas(f,graphname)

end

%% Autocorrelation Weekly Squared

Autocorr_WeeklySquared = zeros(CFD.lags+1,K); %Matrice to store the lags and the confidence interval
WeeklySquared = LogWeekR.^2; 

for j=1:K

[CFD.AC,~] = sacf(WeeklySquared(:,j),CFD.lags,1,0);

% define confidence bands
CFD.confBands = 2* length(WeeklySquared(:,j))^(-1/2);

%Store Data into the Matrice (For each asset asset class)
Autocorr_WeeklySquared(1:10,j) = CFD.AC;
Autocorr_WeeklySquared(11,j) = CFD.confBands; 

%Graph the Autocorrelation
f = figure('visible','off');
set(gcf,'color','w','PaperUnits','centimeters',...
    'PaperPosition',[0 5 10 10])
bar(CFD.lagN,CFD.AC,'FaceColor',[0, 0.4, 0.8])
hold on
line([0,0;CFD.lags,CFD.lags],...
    [CFD.confBands,-CFD.confBands;CFD.confBands,-CFD.confBands],...
    'Color','k','LineStyle','--')
title(sprintf('Correlogram for %s weekly squared returns',string(Names(j))))
axis([0 CFD.lags+1 -.3 +.3])
xlabel('Number of lags','FontSize',12,'FontName','Calibri')
ylabel('ACF','FontSize',12,'FontName','Calibri')
set(gcf,'position',[200,200,800,300])
graphname = sprintf('Plots/Correlogram for %s weekly squared returns.png',string(Names(j)));
saveas(f,graphname)

end

%% Plot of daily portfolio vs other
PRDCUM = cumprod(PRD+1);
SimRDCum = cumprod(SimpleRD + 1);

f = figure('visible','off');
plot(date(2:end,:),SimRDCum)
hold on
plot(date(2:end,:),PRDCUM)
xlabel('Date','FontSize',12,'FontName','Calibri')
ylabel('Cumulative returns','FontSize',12,'FontName','Calibri')
legend([Names,'Portfolio'],'Location','northwest')
saveas(f,'Plots/PricesAndPortfolio.png')

%% Plot of weekly portfolio vs other
PRWCUM = cumprod(PRW+1);
SimRWCum = cumprod(SimWeekR + 1);

f = figure('visible','off');
plot(weekdate(2:end,:),SimRWCum)
hold on
plot(weekdate(2:end,:),PRWCUM)
xlabel('Date','FontSize',12,'FontName','Calibri')
ylabel('Cumulative Weekly returns','FontSize',12,'FontName','Calibri')
legend([Names,'Portfolio'],'Location','northwest')
saveas(f,'Plots/WeeklyPricesAndPortfolio.png')



%% Plot daily Simple returns & Portfolio
f = figure('visible','off');
x=date(2:end);
plot(x,Portfolio_SRD)
legend([Names,'Portfolio'],'Location','southeast')
title('Daily Simple Returns') 
datetick('x','dd-mmm-yyyy');
saveas(f,'Plots/Daily_Simple_Returns.png')

%% Plot weekly Simple returns & Portfolio
f = figure('visible','off');
x=weekdate(2:end);
plot(x,Portfolio_SRW)
legend([Names,'Portfolio'],'Location','southeast')
title('Weekly Simple Returns') 
datetick('x','dd-mmm-yyyy');
saveas(f,'Plots/Weekly_Simple_Returns.png')

%% Plot daily log returns & Portfolio
f = figure('visible','off');
x=date(2:end);
plot(x,Portfolio_LRD)
legend([Names,'Portfolio'],'Location','southeast')
title('Daily Log-Returns') 
datetick('x','dd-mmm-yyyy');
saveas(f,'Plots/Daily_Log_Returns.png')

%% Plot weekly log returns & Portfolio
f = figure('visible','off');
x=weekdate(2:end);
plot(x,Portfolio_LRW)
legend([Names,'Portfolio'],'Location','southeast')
title('Weekly Log-Returns') 
datetick('x','dd-mmm-yyyy');
saveas(f,'Plots/Weekly_Log_Returns.png')

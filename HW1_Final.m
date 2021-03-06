%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EMPIRICAL METHODS FOR FINANCE
% Homework I
%
% Benjamin Souane, Antoine-Michel Alexeev and Julien Bisch
% Due Date: 5 March 2020
%==========================================================================

close all
clc

%import KevinShepperd Toolbox
addpath(genpath('C:\Users\Benjamin\OneDrive\1. HEC\Master\MScF 4.2\EMF\2020\Homeworks\KevinSheperdToolBox'))

%% Import Data

[data,txt] = xlsread('DATA_HW1.xlsx','sheet1','','basic');
date=datetime(data(:,1),'ConvertFrom','excel','Format', 'dd-MM-yyyy');
data = data(:,2:end); %Take out the date from the matrix of price

Names = txt(2,2:end);
N = length(data); %Creating a object for the number of observation of each asset class
K = size(data,2); %Creating a object for the number of asset classes 

%% 2.a Simple and Log-returns at daily frequency

SimpleRD = data(2:end,:)./data(1:end-1,:)-1;
LogRD = log(data(2:end,:)./data(1:end-1,:));


%Descriptive statistics of daily returns

%Annualized mean
MeanSRD = (1 + mean(SimpleRD)).^252 -1; %252 days in a trading year
MeanLRD = (1 + mean(LogRD)).^252 -1; 

%Annualized Volatility 
VolSRD = sqrt(252*var(SimpleRD));
VolLRD = sqrt(252*var(LogRD));

%Skewness and Kurtosis
SkewSRD = skewness(SimpleRD);
SkewLRD = skewness(LogRD);
KurtSRD = kurtosis(SimpleRD);
KurtLRD = kurtosis(LogRD);

%Maximum and Minimum
MaxSRD = max(SimpleRD);
MinSRD = min(SimpleRD);
MaxLRD = max(LogRD);
MinLRD = min(LogRD);

% Creating a Dataset of descriptive Statistics
StatSRD = array2table([MeanSRD*100;VolSRD*100;SkewSRD;KurtSRD;MaxSRD;MinSRD],'VariableNames',Names,'RowNames',{'AnnualizedMean',...
    'AnnualizedVol','Skewness','Kurtosis','Maximum','Minimum'});
filename = 'Results/statSRD.xlsx';
writetable(StatSRD,filename,'Sheet',1,'Range','D1','WriteRowNames',true)

filename = 'Results/statLRD.xlsx';
StatLRD = array2table([MeanLRD*100;VolLRD*100;SkewLRD;KurtLRD;MaxLRD;MinLRD],'VariableNames',Names,'RowNames',{'AnnualizedMean',...
    'AnnualizedVol','Skewness','Kurtosis','Maximum','Minimum'});
writetable(StatLRD,filename,'Sheet',1,'Range','D1','WriteRowNames',true)

%% 2.a Simple and Log-returns at Weekly frequency

%Finding weekly returns
SimReturns = SimpleRD(1:end-2,:); %We only consider full week of data
LogReturns = LogRD(1:end-2,:); %We only consider full week of data

%Creating empty matrices for the weekly returns
SimWeekR = zeros(length(SimReturns)/5,K);
LogWeekR = SimWeekR;

%Loop computing weekly returns for each week
for i = 1:(length(SimReturns)/5) %For each week
        for k = 1:K %Each asset class
            SimWeekR(i,k) = (1+SimReturns((i-1)*5+1,k))*(1+SimReturns((i-1)*5+2,k))*(1+SimReturns((i-1)*5+3,k))*(1+SimReturns((i-1)*5+4,k))*(1+SimReturns((i-1)*5+5,k)) - 1;
            LogWeekR(i,k) = LogReturns((i-1)*5+1,k)+LogReturns((i-1)*5+2,k)+LogReturns((i-1)*5+3,k)+LogReturns((i-1)*5+4,k)+LogReturns((i-1)*5+5,k);
        end
end

% Descriptive Statistics of Weekly Returns

%Annualized Mean
MeanSRW = (1+mean(SimWeekR)).^52 -1;
MeanLRW = (1+mean(LogWeekR)).^52 -1;

%Annualized Volatility 
VolSRW = sqrt(52*var(SimWeekR));
VolLRW = sqrt(52*var(LogWeekR));

%Skewness and Kurtosis
SkewSRW = skewness(SimWeekR);
SkewLRW = skewness(LogWeekR);
KurtSRW = kurtosis(SimWeekR);
KurtLRW = kurtosis(LogWeekR);

%Maximum and minimum
MaxSRW = max(SimWeekR);
MinSRW = min(SimWeekR);
MaxLRW = max(LogWeekR);
MinLRW = min(LogWeekR);


% Creating a Dataset of descriptive Statistics
StatSRW = array2table([MeanSRW*100;VolSRW*100;SkewSRW;KurtSRW;MaxSRW;MinSRW],'VariableNames',Names,'RowNames',{'AnnualizedMean',...
    'AnnualizedVol','Skewness','Kurtosis','Maximum','Minimum'});
filename = 'Results/statSRW.xlsx';
writetable(StatSRW,filename,'Sheet',1,'Range','D1','WriteRowNames',true)


StatLRW = array2table([MeanLRW*100;VolLRW*100;SkewLRW;KurtLRW;MaxLRW;MinLRW],'VariableNames',Names,'RowNames',{'AnnualizedMean',...
    'AnnualizedVol','Skewness','Kurtosis','Maximum','Minimum'});
filename = 'Results/statLRW.xlsx';
writetable(StatLRW,filename,'Sheet',1,'Range','D1','WriteRowNames',true)

%%  Daily Crashes and Booms

% Daily Crashes and Booms

%Creating a matrice to store the data
P_values=zeros([5 6]);

for i = 1:K
   
%Computing Daily mean and volatility (We only had annualized ones)
DailyMeanLRD = mean(LogRD(:,i));
DailyVolLRD = sqrt(var(LogRD(:,i)));

%Computing the Probabilty of such extremes happening
[daily_log_returns,id_logRD]=sort(LogRD(:,i),'ascend');
Date =  date(id_logRD);
probability = (1-normcdf(abs(daily_log_returns),DailyMeanLRD,DailyVolLRD));

%Computing p-values
for j=1:5
    [h,p] = ztest(daily_log_returns(j,:),DailyMeanLRD,DailyVolLRD);
    P_values(j,i)=p;
end

%Writing the Crashes in a dataset
CrashesDaily = table(Date(1:5,:),daily_log_returns(1:5)*100,probability(1:5));
filename = 'Results/DailyCrashes.xlsx';
sheet = string(Names(i));
writetable(CrashesDaily,filename,'Sheet',sheet,'Range','D1')

%Writing the booms in a dataset
BoomsDaily = table(Date(end-4:end,:),daily_log_returns(end-4:end)*100,probability(end-4:end));
filename = 'Results/DailyBooms.xlsx';
writetable(BoomsDaily,filename,'Sheet',sheet,'Range','D1')

end

% Creating a dataset with the Pvalues
P_values=array2table(P_values);
P_values.Properties.VariableNames=Names;
P_values.Properties.RowNames={'1','2','3','4','5'};
writetable(P_values,'Results/p_values.xlsx','Sheet',sheet,'Range','D1');

%Lilliefors test
Daily_LFT = Lilliefors(LogRD);

%% Weekly crashes and booms of the SP500

%Creating a matrice to store the P_Values
P_values_weekly=zeros([5 6]);

for i = 1:K

%Computing Weekly means and volatility (We only had annualized ones)
WeeklyMeanLRW = mean(LogWeekR(i)); 
WeeklyVolLRW = sqrt(var(LogWeekR(i)));

%Ordering and computing the Probabilty of such extremes happening
[weekly_log_returns,id]=sort(LogWeekR(:,i),'ascend');
Weeks = date(2+5*(id-1));
probability_weekly = (1-normcdf(abs(weekly_log_returns),WeeklyMeanLRW,WeeklyVolLRW));

%Computing p-values
for j=1:5
    [h,p] = ztest(weekly_log_returns(j,:),WeeklyMeanLRW,WeeklyVolLRW);
    P_values_weekly(j,i)=p;
end

%Writing the Weekly Crashes in a dataset
CrashesWeekly = table(Weeks(1:5,:),weekly_log_returns(1:5)*100,probability_weekly(1:5));
filename = 'Results/WeeklyCrashes.xlsx';
sheet = string(Names(i));
writetable(CrashesWeekly,filename,'Sheet',sheet,'Range','D1')

%Writing the Weekly booms in a dataset
BoomsWeekly = table(Weeks(end-4:end,:),weekly_log_returns(end-4:end)*100,probability_weekly(end-4:end));
filename = 'Results/WeeklyBooms.xlsx';
writetable(BoomsWeekly,filename,'Sheet',sheet,'Range','D1')

end

% Creating a dataset with the Pvalues
P_values_weekly=array2table(P_values_weekly);
P_values_weekly.Properties.VariableNames=Names;
P_values_weekly.Properties.RowNames={'1','2','3','4','5'};
writetable(P_values_weekly,'Results/p_values_weekly.xlsx','Sheet',sheet,'Range','D1');

%Lilliefors on weekly data
Weekly_LFT = Lilliefors(LogWeekR);

%% How many data are bigger/smaller than mean + 3*sigma

% For a normal law, 0.27% of the data should be smaller or bigger than 
% the mean +- 3 sigma. 

%Daily
GreaterDaily = zeros(1,K);
for i = 1:K
ThreeSigmaD = mean(LogRD(:,i))+3*sqrt(var(LogRD(:,i))); %Threshold of mean + 3 sigma
AbsDailyLR = abs(LogRD(:,i)); %Taking the absolute value since the normal law is symmetric
greater = sum(AbsDailyLR>ThreeSigmaD); %Creating a vector of 1 if the value is greater and 0 otherwise
GreaterDaily(1,i) = greater/length(AbsDailyLR)*100; %Computing the percentage of value bigger than the threshold
end 

%Weekly 
GreaterWeekly = zeros(1,K);
for i = 1:K
ThreeSigmaW = mean(LogWeekR(:,i))+3*sqrt(var(LogWeekR(:,i))); %Threshold of mean + 3 sigma
AbsWeeklyLR = abs(LogWeekR(:,i)); %Taking the absolute value since the normal law is symmetric
greater = sum(AbsWeeklyLR>ThreeSigmaW); %Creating a vector of 1 if the value is greater and 0 otherwise
GreaterWeekly(1,i) = greater/length(AbsWeeklyLR)*100; %Computing the percentage of value bigger than the threshold
end 

GreaterAll = array2table([GreaterDaily;GreaterWeekly],'VariableNames',Names,'RowNames',{'Daily','Weekly'});
writetable(GreaterAll,'Results/GreaterThan3Sigma.xlsx','sheet','Non-Normal','Range','A1','WriteRowNames',true);

%% Jarque and Bera Test

% The function is coded in a separate m file

%Daily Data

JbStatDaily = JarqueBera(LogRD);

%Weekly Data

JbStatWeekly = JarqueBera(LogWeekR);

JBstats = array2table([JbStatDaily;JbStatWeekly],'VariableNames',Names,'RowNames',{'Daily','Weekly'});
writetable(JBstats,'Results/JarqueBera.xlsx','sheet','JarqueBera','Range','A1','WriteRowNames',true);

%% 3d. Autocorrelation Daily

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

end

%Create a DataSet with the Autocorrelation
Autocorr_Daily = array2table(Autocorr_Daily,'VariableNames',Names,'RowNames',{'Lag 1','Lag 2','Lag 3','Lag 4','Lag 5','Lag 6','Lag 7','Lag 8','Lag 9','Lag 10','Confidence Interval'});
filename = 'Results/Autocorrelation_Daily.xlsx';
writetable(Autocorr_Daily,filename,'Sheet','AutoCorrelation','Range','A1','WriteRowNames',true)

%% 3d. Autocorrelation Weekly

Autocorr_Weekly = zeros(CFD.lags+1,K); %Matrice to store the lags and the confidence interval

for j=1:K

[CFD.AC,~] = sacf(LogWeekR(:,j),CFD.lags,1,0);

% define confidence bands
CFD.confBands = 2* length(LogWeekR(:,j))^(-1/2);

%Store Data into the Matrice (For each asset asset class)
Autocorr_Weekly(1:10,j) = CFD.AC;
Autocorr_Weekly(11,j) = CFD.confBands; 

end

%Create a DataSet with the Autocorrelation
Autocorr_Weekly = array2table(Autocorr_Weekly,'VariableNames',Names,'RowNames',{'Lag 1','Lag 2','Lag 3','Lag 4','Lag 5','Lag 6','Lag 7','Lag 8','Lag 9','Lag 10','Confidence Interval'});
filename = 'Results/Autocorrelation_Weekly.xlsx';
writetable(Autocorr_Weekly,filename,'Sheet','AutoCorrelation','Range','A1','WriteRowNames',true)

%% Autocorrelation of Daily Squared returns

Autocorr_DailySquared = zeros(CFD.lags+1,K); %Matrice to store the lags and the confidence interval
DailySquared = LogRD.^2; 

for j=1:K

[CFD.AC,~] = sacf(DailySquared(:,j),CFD.lags,1,0);

% define confidence bands
CFD.confBands = 2* length(DailySquared(:,j))^(-1/2);

%Store Data into the Matrice (For each asset asset class)
Autocorr_DailySquared(1:10,j) = CFD.AC;
Autocorr_DailySquared(11,j) = CFD.confBands; 

end

%Create a DataSet with the Autocorrelation
Autocorr_DailySquared = array2table(Autocorr_DailySquared,'VariableNames',Names,'RowNames',{'Lag 1','Lag 2','Lag 3','Lag 4','Lag 5','Lag 6','Lag 7','Lag 8','Lag 9','Lag 10','Confidence Interval'});
filename = 'Results/Autocorrelation_DailySquared.xlsx';
writetable(Autocorr_DailySquared,filename,'Sheet','AutoCorrelation','Range','A1','WriteRowNames',true)

%% Autocorrelation of Weekly Squared returns


Autocorr_WeeklySquared = zeros(CFD.lags+1,K); %Matrice to store the lags and the confidence interval
WeeklySquared = LogWeekR.^2; 

for j=1:K

[CFD.AC,~] = sacf(WeeklySquared(:,j),CFD.lags,1,0);

% define confidence bands
CFD.confBands = 2* length(WeeklySquared(:,j))^(-1/2);

%Store Data into the Matrice (For each asset asset class)
Autocorr_WeeklySquared(1:10,j) = CFD.AC;
Autocorr_WeeklySquared(11,j) = CFD.confBands; 

end

%Create a DataSet with the Autocorrelation
Autocorr_WeeklySquared = array2table(Autocorr_WeeklySquared,'VariableNames',Names,'RowNames',{'Lag 1','Lag 2','Lag 3','Lag 4','Lag 5','Lag 6','Lag 7','Lag 8','Lag 9','Lag 10','Confidence Interval'});
filename = 'Results/Autocorrelation_WeeklySquared.xlsx';
writetable(Autocorr_WeeklySquared,filename,'Sheet','AutoCorrelation','Range','A1','WriteRowNames',true)
%% LungBoxTest

% Daily 
DailyLjung_2 = zeros(3,K);

for i = 1:K
 DailyLjung_2(1:3,i) = LjungBoxTest(LogRD(:,i),10,0,0.05);
end 
DailyLjung = array2table(DailyLjung_2,'VariableNames',Names,'RowNames',{'QLBStat','LBCritVal','LBPvalue'});
filename = 'Results/Ljungbox_daily.xlsx';
writetable(DailyLjung,filename,'Sheet','LjunboxTest','Range','A1','WriteRowNames',true)

% Weekly 
WeeklyLjung_2 = zeros(3,K);

for i = 1:K
 WeeklyLjung_2(1:3,i) = LjungBoxTest(LogWeekR(:,i),10,0,0.05);
end 
WeeklyLjung = array2table(WeeklyLjung_2,'VariableNames',Names,'RowNames',{'QLBStat','LBCritVal','LBPvalue'});
filename = 'Results/Ljungbox_Weekly.xlsx';
writetable(WeeklyLjung,filename,'Sheet','LjunboxTest','Range','A1','WriteRowNames',true)

%Daily Squared
DailySquaredLjung_2 = zeros(3,K);

for i = 1:K
 DailySquaredLjung_2(1:3,i) = LjungBoxTest(DailySquared(:,i),10,0,0.05);
end 
DailySquaredLjung = array2table(DailySquaredLjung_2,'VariableNames',Names,'RowNames',{'QLBStat','LBCritVal','LBPvalue'});
filename = 'Results/Ljungbox_dailySquared.xlsx';
writetable(DailySquaredLjung,filename,'Sheet','LjunboxTest','Range','A1','WriteRowNames',true)

%Weekly Squared 
WeeklySquaredLjung_2 = zeros(3,K);

for i = 1:K
 WeeklySquaredLjung_2(1:3,i) = LjungBoxTest(WeeklySquared(:,i),10,0,0.05);
end 
WeeklySquaredLjung = array2table(WeeklySquaredLjung_2,'VariableNames',Names,'RowNames',{'QLBStat','LBCritVal','LBPvalue'});
filename = 'Results/Ljungbox_WeeklySquared.xlsx';
writetable(WeeklySquaredLjung,filename,'Sheet','LjunboxTest','Range','A1','WriteRowNames',true)

AllLjungbox = array2table([DailyLjung_2;WeeklyLjung_2;DailySquaredLjung_2;WeeklySquaredLjung_2],'VariableNames',Names,'RowNames',{'Daily','1','2','Weekly','3','4','Daily Squared','5','6','Weekly Squared','7','8'});

%% 4. Portofolio Statistic

% 4a. Compute the summary statistics of point 2 (sample mean, variance, skewness, kurtosis,
% minimum, and maximum) at daily frequency. Compare the statistics with those of the
% individual stocks (point 2a.). Elaborate on the contemporaneous aggregate normality
% feature.

W=ones(1,K)*1/K;

%% Daily returns of the portfolio

PRD=SimpleRD*W';
mean_PRD = mean(PRD);
amean_PRD = (1+mean_PRD).^252-1; % annualized mean
var_PRD = var(PRD);
avol_PRD = sqrt(var_PRD*252); % annualized volatility
skew_PRD = skewness(PRD);
kurt_PRD = kurtosis(PRD);
minPRD = min(PRD);
maxPRD = max(PRD);

%Creating a vector of the portfolio and simple returns
Portfolio_SRD=[PRD SimpleRD];

% Creating a table with the Portfolio Data
Portfolio_stat_D =[amean_PRD*100;mean_PRD;avol_PRD*100;skew_PRD;kurt_PRD;minPRD*100;maxPRD*100];
Portfolio_stat_D= array2table(Portfolio_stat_D,'VariableNames',{'Porfolio'},'RowNames',{'AnnualizedMean','Mean','AnnualizedVol','Skewness','Kurtosis','Minimum','Maximum'});

% Creating a dataset with the descriptive statistics of the portfolio and
% each individual asset class
amean_PD=[amean_PRD MeanSRD];
mean_PD=[mean_PRD mean(SimpleRD)];
avol_PD=[avol_PRD VolSRD];
skew_PD=[skew_PRD SkewSRD];
kurt_PD=[kurt_PRD KurtSRD];
minPD=[minPRD MinSRD];
maxPD=[maxPRD MaxSRD];

Pnames=['Portfolio' Names]; %Vector with the portfolio and the names of the individual assets 

%Creating the table
Summary_stat_D=[amean_PD*100;mean_PD;avol_PD*100;skew_PD;kurt_PD;minPD*100;maxPD*100];
Summary_stat_D= array2table(Summary_stat_D,'VariableNames',Pnames,'RowNames',{'AnnualizedMean','Mean','AnnualizedVol','Skewness','Kurtosis','Minimum','Maximum'});


%% Daily Log-returns of the portfolio

PLD=LogRD*W';
mean_PLD = mean(PLD);
amean_PLD = (1+mean_PLD).^252-1; % annualized mean
var_PLD = var(PLD);
avol_PLD = sqrt(var_PLD*252); % annualized volatility
skew_PLD = skewness(PLD);
kurt_PLD = kurtosis(PLD);
minPLD = min(PLD);
maxPLD = max(PLD);

%Creating a vector of the portfolio and simple returns
Portfolio_LRD=[PLD LogRD];

% Creating a table with the Portfolio Data
Portfolio_stat_LD =[amean_PLD*100;mean_PLD;avol_PLD*100;skew_PLD;kurt_PLD;minPLD*100;maxPLD*100];
Portfolio_stat_LD= array2table(Portfolio_stat_LD,'VariableNames',{'Porfolio'},'RowNames',{'AnnualizedMean','Mean','AnnualizedVol','Skewness','Kurtosis','Minimum','Maximum'});

% Creating a dataset with the descriptive statistics of the portfolio and
% each individual asset class
amean_LPD=[amean_PLD MeanLRD];
mean_LPD=[mean_PLD mean(LogRD)];
avol_LPD=[avol_PLD VolLRD];
skew_LPD=[skew_PLD SkewLRD];
kurt_LPD=[kurt_PLD KurtLRD];
minLPD=[minPLD MinLRD];
maxLPD=[maxPLD MaxLRD];

LPnames=['Portfolio' Names]; %Vector with the portfolio and the names of the individual assets 

%Creating the table
Summary_stat_LD=[amean_LPD*100;mean_LPD;avol_LPD*100;skew_LPD;kurt_LPD;minLPD*100;maxLPD*100];
Summary_stat_LD= array2table(Summary_stat_LD,'VariableNames',LPnames,'RowNames',{'AnnualizedMean','Mean','AnnualizedVol','Skewness','Kurtosis','Minimum','Maximum'});

%% Weekly returns of the portfolio
% 4b. Re-do the same exercise at weekly frequency. Elaborate on the relative effect of
% temporal and contemporaneous aggregate normality features.

%Computing descriptive statistics
PRW=SimWeekR*W';
mean_PRW = mean(PRW);
amean_PRW = (1+mean_PRW).^52-1; % annualized mean
var_PRW = var(PRW);
avol_PRW = sqrt(var_PRW*52); % annualized volatility
skew_PRW = skewness(PRW);
kurt_PRW = kurtosis(PRW);
minPRW = min(PRW);
maxPRW = max(PRW);

%DataSet of the portfolio return
Portfolio_stat_W =[amean_PRW*100;mean_PRW;avol_PRW*100;skew_PRW;kurt_PRW;minPRW*100;maxPRW*100];
Portfolio_stat_W= array2table(Portfolio_stat_W,'VariableNames',{'Porfolio'},'RowNames',{'AnnualizedMean','Mean','AnnualizedVol','Skewness','Kurtosis','Minimum','Maximum'});

% Creating a vector with the returns of the portfolio and each asset class
Portfolio_SRW=[PRW SimWeekR];

% Computing vector of descriptive statistics for the portfolio and
% individuals assets
amean_PW=[amean_PRW MeanSRW];
mean_PW=[mean_PRW mean(SimWeekR)];
avol_PW=[avol_PRW VolSRW];
skew_PW=[skew_PRW SkewSRW];
kurt_PW=[kurt_PRW KurtSRW];
min_PW=[minPRW MinSRW];
max_PW=[maxPRW MaxSRW];

% Creating a dataset with the descriptive statistics of the portfolio and
% each asset class 
Summary_stat_W=[amean_PW*100;mean_PW;avol_PW*100;skew_PW;kurt_PW;min_PW*100;max_PW*100];
Summary_stat_W= array2table(Summary_stat_W,'VariableNames',['Porfolio',Names],'RowNames',{'AnnualizedMean','Mean','AnnualizedVol','Skewness','Kurtosis','Minimum','Maximum'});


%% Weekly Log returns of the portfolio
% 4b. Re-do the same exercise at weekly frequency. Elaborate on the relative effect of
% temporal and contemporaneous aggregate normality features.

%Computing descriptive statistics
PLW=LogWeekR*W';
mean_PLW = mean(PLW);
amean_PLW = (1+mean_PLW).^52-1; % annualized mean
var_PLW = var(PLW);
avol_PLW = sqrt(var_PLW*52); % annualized volatility
skew_PLW = skewness(PLW);
kurt_PLW = kurtosis(PLW);
minPLW = min(PLW);
maxPLW = max(PLW);

%DataSet of the portfolio return
Portfolio_stat_LW =[amean_PLW*100;mean_PLW;avol_PLW*100;skew_PLW;kurt_PLW;minPLW*100;maxPLW*100];
Portfolio_stat_LW= array2table(Portfolio_stat_LW,'VariableNames',{'Porfolio'},'RowNames',{'AnnualizedMean','Mean','AnnualizedVol','Skewness','Kurtosis','Minimum','Maximum'});

% Creating a vector with the returns of the portfolio and each asset class
Portfolio_LRW=[PLW LogWeekR];

% Computing vector of descriptive statistics for the portfolio and
% individuals assets
amean_LPW=[amean_PLW MeanLRW];
mean_LPW=[mean_PLW mean(LogWeekR)];
avol_LPW=[avol_PLW VolLRW];
skew_LPW=[skew_PLW SkewLRW];
kurt_LPW=[kurt_PLW KurtLRW];
min_LPW=[minPLW MinLRW];
max_LPW=[maxPRW MaxLRW];

% Creating a dataset with the descriptive statistics of the portfolio and
% each asset class 
Summary_stat_LW=[amean_LPW*100;mean_LPW;avol_LPW*100;skew_LPW;kurt_LPW;min_LPW*100;max_LPW*100];
Summary_stat_LW= array2table(Summary_stat_LW,'VariableNames',['Porfolio',Names],'RowNames',{'AnnualizedMean','Mean','AnnualizedVol','Skewness','Kurtosis','Minimum','Maximum'});

%% Calling plots and latex code

disp('Analysis code finished, Starting conversion of table !')

% Creating latex code from table
tabletolatex
disp('Conversion of table done ! ')

% Asking the user if he want to plot the graph because it quiet long !
prompt = 'Do you want to plot the graphs ?\n This make take up to two minutes ! y/n [y]: ';
str = input(prompt,'s');

% Setting that if the user does respond, it's taken as yes
if isempty(str)
    str = 'y';
end

% Conditions that plots graph or not
if str == 'y'
    disp('Starting to plot graphs ! ')
    Plot_Code
    App_AutoCorrelations
    disp('Code finished !')
else
    disp('Code finished !')
end



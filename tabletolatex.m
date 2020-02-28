addpath(genpath('C:\Users\Benjamin\OneDrive\1. HEC\Master\MScF 4.2\EMF\2020\Homeworks\table2latex.m'))

%% Creating the latex code 

table2latex(StatSRD,'Latex_Table\StatSRD.tex')
table2latex(StatLRD,'Latex_Table\StatLRD.tex')
table2latex(StatSRW,'Latex_Table\StatSRW.tex')
table2latex(StatLRW,'Latex_Table\StatLRW.tex')
table2latex(Autocorr_Daily,'Latex_Table\AutocorrDaily.tex')
table2latex(Autocorr_Weekly,'Latex_Table\AutocorrWeekly.tex')
table2latex(DailyLjung,'Latex_Table\DailyLjung.tex')
table2latex(WeeklyLjung,'Latex_Table\WeeklyLjung.tex')
table2latex(Portfolio_stat_D,'Latex_Table\Portfolio_stat_D.tex')
table2latex(Portfolio_stat_W,'Latex_Table\Portfolio_stat_W.tex')
table2latex(GreaterAll,'Latex_Table\GreaterthanSigma.tex')
table2latex(JBstats,'Latex_Table\JarqueBera.tex')
table2latex(P_values,'Latex_Table\P_values.tex')
table2latex(P_valuesW,'Latex_Table\P_valuesW.tex')

%% These tables do not work for now

%table2latex(CrashesDaily,'Latex_Table\CrashesDaily.tex')
%table2latex(BoomsDaily,'Latex_Table\BoomsDaily.tex')
%table2latex(CrashesWeekly,'Latex_Table\CrashesWeekly.tex')
%table2latex(BoomsWeekly,'Latex_Table\BoomsWeekly.tex')

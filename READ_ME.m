%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EMPIRICAL METHODS FOR FINANCE
% Homework I
%
% Benjamin Souane, Antoine-Michel Alexeev and Julien Bisch
% Due Date: 5 March 2020
%==========================================================================

% This is the code for the Homework 1 of empirical method in finance given
% by Professor Eric Jondeau. 

%% Package Required 

% The code needs "Kevin Sheperd ToolBox" to run. 
% You can add your path, if not already done, changing the path in the line
% 13 of the code. 

%% How to use and what does the code

% The main code is "HW1_Final.m". It does every computations necessary for
% the homework. 

% To do so it uses the following functions : 

    % 1. JarqueBera.m (Written by the group) in order to perform Jarque and
    % bera tests. 

    % 2. Lilliefors.m (Written by the group) in order to perfom Lilliefors
    % test.

    % 3. LjungBoxTest.m (Not written by the group) in order to perform Ljung
    % box tests. 

%  Other code called : 

    % The last lines of the code call "tabletolatex.m" that create the latex
    % code of all the table (Using the code "table2latex.m") and store them in 
    %the folder Latex_Table. 

    % Then it calls, "Plot_Code.m" to plot all the necessary plot and store
    % them into the folders plots. It also calls "App_AutoCorrelations.m" that
    % create an graphical application for the AutoCorrelations graphs.

    % During all the code, excel table are create and store in the folder
    % Results. 


function App_AutoCorrelations
% SIMPLE_GUI2 Select a data set from the pop-up menu, then
% click one of the plot-type push buttons. Clicking the button
% plots the selected data in the axes.

%  Create and then hide the UI as it is being constructed.
f = figure('Visible','off','Position',[360,500,450,285]);

% Construct the components.
hsurf    = uicontrol('Style','pushbutton',...
             'String','Daily','Position',[315,150,100,25],...
             'Callback',@surfbutton_Callback);
hDailySquared    = uicontrol('Style','pushbutton',...
             'String','Daily Squared','Position',[315,120,100,25],...
             'Callback',@DailySquaredbutton_Callback);
hWeekly    = uicontrol('Style','pushbutton',...
             'String','Weekly','Position',[315,90,100,25],...
             'Callback',@Weeklybutton_Callback);
hWeeklySquared    = uicontrol('Style','pushbutton',...
             'String','Weekly Squared','Position',[315,60,100,25],...
             'Callback',@WeeklySquaredbutton_Callback);
htext  = uicontrol('Style','text','String','Select Data',...
           'Position',[325,220,60,15]);
hpopup = uicontrol('Style','popupmenu',...
           'String',{'S&P Comp','MLGTRSA','MLCORPM','WILURET','CRBSPOT','JPUSEEN'},...
           'Position',[300,190,100,25],...
           'Callback',@popup_menu_Callback);
ha = axes('Units','pixels','Position',[50,60,200,185]);
align([htext,hpopup,hsurf,hDailySquared,hWeekly,hWeeklySquared],'Center','None');

% Initialize the UI.
% Change units to normalized so components resize automatically.
f.Units = 'normalized';
ha.Units = 'normalized';
htext.Units = 'normalized';
hpopup.Units = 'normalized';
hsurf.Units = 'normalized';
hDailySquared = 'normalized';
hWeekly = 'normalized';
hWeeklySquared = 'normalized';

%% Generate the data to plot.

Autocorr_Daily = evalin('base','Autocorr_Daily'); % Daily Autocorrelation
Autocorr_DailySquared = evalin('base','Autocorr_DailySquared'); %Auto-correlation of market risk
Autocorr_WeeklySquared = evalin('base','Autocorr_WeeklySquared'); %Auto-correlation of weekly risk
Autocorr_Weekly = evalin('base','Autocorr_Weekly'); %Auto-correlation of weekly returns

%Creating matrix of auto-correlation for each asset class
SP_data = [Autocorr_Daily(1:10,1),Autocorr_DailySquared(1:10,1),Autocorr_Weekly(1:10,1),Autocorr_WeeklySquared(1:10,1)];
MLG_data = [Autocorr_Daily(1:10,2),Autocorr_DailySquared(1:10,2),Autocorr_Weekly(1:10,2),Autocorr_WeeklySquared(1:10,2)];
MLCORP_data = [Autocorr_Daily(1:10,3),Autocorr_DailySquared(1:10,3),Autocorr_Weekly(1:10,3),Autocorr_WeeklySquared(1:10,3)];
WILURET_data = [Autocorr_Daily(1:10,4),Autocorr_DailySquared(1:10,4),Autocorr_Weekly(1:10,4),Autocorr_WeeklySquared(1:10,4)];
CRBSPOT_data = [Autocorr_Daily(1:10,5),Autocorr_DailySquared(1:10,5),Autocorr_Weekly(1:10,5),Autocorr_WeeklySquared(1:10,5)];
JPUSEEN_data = [Autocorr_Daily(1:10,6),Autocorr_DailySquared(1:10,6),Autocorr_Weekly(1:10,6),Autocorr_WeeklySquared(1:10,6)];

%Setting the lags (x axis)
x = (1:10);

% Create a plot in the axes.
current_data = SP_data;
bar(x,current_data(:,1))
       hold on
line([0,0;10,10],...
    [Autocorr_Daily(11,1),-Autocorr_Daily(11,1);Autocorr_Daily(11,1),-Autocorr_Daily(11,1)],...
    'Color','k','LineStyle','--')
        hold off

% Assign the a name to appear in the window title.
f.Name = 'Auto-Correlation of Returns';

% Move the window to the center of the screen.
movegui(f,'center')

% Make the window visible.
f.Visible = 'on';

%  Pop-up menu callback. Read the pop-up menu Value property to
%  determine which item is currently displayed and make it the
%  current data. This callback automatically has access to 
%  current_data because this function is nested at a lower level.
   function popup_menu_Callback(source,eventdata) 
      % Determine the selected data set.
      str = get(source, 'String');
      val = get(source,'Value');
      % Set current data to the selected data set.
      switch str{val}
      case 'S&P Comp' % User selects S&P Comp.
         current_data = SP_data;
      case 'MLGTRSA' % User selects MLGTRSA.
         current_data = MLG_data;
      case 'MLCORPM' % User selects MLCCORPM.
         current_data = MLCORP_data;
      case 'WILURET' % User selects WILURET.
         current_data = WILURET_data;
      case 'CRBSPOT' % User selects CRBSPOT.
         current_data = CRBSPOT_data;
      case 'JPUSEEN' % User selects JPUSEEN.
         current_data = JPUSEEN_data;
      end
   end

%Function to graph Daily returns
function surfbutton_Callback(source,eventdata) %Displaying Daily Autocorrelation
  % Display surf plot of the currently selected data.
       bar(x,current_data(1:10,1))
        hold on
line([0,0;10,10],...
    [Autocorr_Daily(11,1),-Autocorr_Daily(11,1);Autocorr_Daily(11,1),-Autocorr_Daily(11,1)],...
    'Color','k','LineStyle','--')
        hold off
end

%Function to graph daily Squared returns
function DailySquaredbutton_Callback(source,eventdata) %Displaying Daily Autocorrelation
  % Display surf plot of the currently selected data.
       bar(x,current_data(1:10,2))
        hold on
line([0,0;10,10],...
    [Autocorr_DailySquared(11,1),-Autocorr_DailySquared(11,1);Autocorr_DailySquared(11,1),-Autocorr_DailySquared(11,1)],...
    'Color','k','LineStyle','--')
        hold off
end

%Function to graph Weekly returns
function Weeklybutton_Callback(source,eventdata) %Displaying Daily Autocorrelation
  % Display surf plot of the currently selected data.
       bar(x,current_data(1:10,3))
        hold on
line([0,0;10,10],...
    [Autocorr_Weekly(11,1),-Autocorr_Weekly(11,1);Autocorr_Weekly(11,1),-Autocorr_Weekly(11,1)],...
    'Color','k','LineStyle','--')
        hold off
end

%Function for Graphing Daily Squared returns 
function WeeklySquaredbutton_Callback(source,eventdata) %Displaying Daily Autocorrelation
  % Display surf plot of the currently selected data.
       bar(x,current_data(1:10,4))
        hold on
line([0,0;10,10],...
    [Autocorr_WeeklySquared(11,1),-Autocorr_WeeklySquared(11,1);Autocorr_WeeklySquared(11,1),-Autocorr_WeeklySquared(11,1)],...
    'Color','k','LineStyle','--')
        hold off
  end
end


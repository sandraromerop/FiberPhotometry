function Analysis=A_FilterState(Analysis,State,noState)
% Function to filter trials according to the active state 'State'.
% Also generates a noState filter.
%
% Function designed by Quentin 2017 for Analysis_Photometry

%% Parameters
%Name
if nargin==2
    noState=State+'Inv';
end

FilterNb=length(Analysis.Filters.Names);
Analysis.Filters.Names{FilterNb+1}=State;
Analysis.Filters.Names{FilterNb+2}=noState;

%Filter
Logicals=false(Analysis.AllData.nTrials,1);

%% Filter
for i=1:Analysis.AllData.nTrials
    if isnan(Analysis.AllData.States{1,i}.(State))==0
        Logicals(i)=true;
    end
end
Analysis.Filters.Logicals=[Analysis.Filters.Logicals Logicals ~Logicals];
end
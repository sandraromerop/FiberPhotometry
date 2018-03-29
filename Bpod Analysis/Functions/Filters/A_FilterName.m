function Analysis=A_FilterName(Analysis,Name)
% This script creates a filter according to the name of the trial types. 
% 
% Function designed by Quentin 2017 for Analysis_Photometry

%% Parameters
TypeNb=A_NameToTrialNumber(Analysis,Name);
%Name
FilterNb=length(Analysis.Filters.Names);
Analysis.Filters.Names{FilterNb+1}=Name;

%% Filter
Logicals=false(Analysis.AllData.nTrials,1);
Logicals(ismember(Analysis.AllData.TrialTypes,TypeNb))=true;
Analysis.Filters.Logicals=[Analysis.Filters.Logicals Logicals];
end
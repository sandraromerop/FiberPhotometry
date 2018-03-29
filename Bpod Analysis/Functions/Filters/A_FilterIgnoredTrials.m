function Analysis=A_FilterIgnoredTrials(Analysis,IT,test)
%Allows to ignore trials specified in 'IT'. 'IT' will be save as a .mat file. 
%'Test' can be used to specificy whether the function should load a .mat
%file containing the 'IT' variable (test=1 by default, test=0 will not load
%the file).
%
%function designed by Quentin 2016 for Analysis_Photometry

%% Checks and loads IT
if nargin==2
    test=1;
end

ITFile=[Analysis.Properties.Name '_ignoredTrials.mat'];
if isempty(IT)==1 && exist(ITFile,'file') && test==1
  load(ITFile);  
end

%% Generates the filter
Analysis.Filters.ignoredTrials=true(1,Analysis.Properties.nTrials);
% for i=IT
        Analysis.Filters.ignoredTrials(IT)=false;
% end

%% Saves the filter
if isempty(IT)==0
    Analysis.Properties.ignoredTrials=IT;
    save(ITFile,'IT');
end
end